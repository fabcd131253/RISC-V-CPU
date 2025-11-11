// boot.c — descriptor-based DMA + ISR（專用位址版）
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/*==================== DMA 暫存器（你的規格） ====================*/
#define DMA_REG_DMAEN       (*(volatile uint32_t*)0x10020100u)  // 1=enable, 0=ack/disable
#define DMA_REG_DESC_BASE   (*(volatile uint32_t*)0x10020200u)  // descriptor 起始實體位址

/*==================== descriptor list 固定放置區（你的規格） ====================*/
#define DESCLIST_BASE_ADDR  (0x0002FF00u)
#define DESCLIST_END_ADDR   (0x0002FFFFu)
#define DESCLIST_CAP_BYTES  (DESCLIST_END_ADDR - DESCLIST_BASE_ADDR + 1u) // 0x100 (=256B)

/*==================== 連結器符號（依你的 link.ld） ====================*/
// instruction in DRAM / instruction start in IMEM
extern unsigned int _dram_i_start;
extern unsigned int _dram_i_end;
extern unsigned int _imem_start;

// sdata in DMEM / its image in DRAM
extern unsigned int _sdata_start;
extern unsigned int _sdata_end;
extern unsigned int _sdata_paddr_start;

// data in DMEM / its image in DRAM
extern unsigned int _data_start;
extern unsigned int _data_end;
extern unsigned int _data_paddr_start;

/*==================== RISC-V 柵欄 ====================*/
static inline void fence_rw(void)  { __asm__ volatile ("fence iorw, iorw" ::: "memory"); }
static inline void fence_i(void)   { __asm__ volatile ("fence.i" ::: "memory"); }

/*==================== Descriptor 佈局（你的欄位） ====================*/
/* 欄位：DMASRC, DMADST, DMALEN, NEXT_DESC, EOC
 * 以 32B 對齊（每筆 8*4B），三筆共 96B，容納於 0x0002FF00~0x0002FFFF (256B) 內。
 */
typedef struct __attribute__((packed, aligned(16))) {
    uint32_t DMASRC;
    uint32_t DMADST;
    uint32_t DMALEN;
    uint32_t NEXT_DESC;
    uint32_t EOC;
    uint32_t rsv0, rsv1, rsv2;
} dma_desc_t;

#define MAX_DESCS  3u  // IMEM、.sdata、.data 三段

static volatile dma_desc_t* const g_descs = (volatile dma_desc_t*)DESCLIST_BASE_ADDR;
static volatile uint32_t          g_desc_count = 0;
static volatile uint32_t          g_dma_done_flag = 0;

/*==================== 小工具 ====================*/
static inline uint32_t align_up(uint32_t v, uint32_t a) {
    return (a > 1u) ? ((v + (a - 1u)) & ~(a - 1u)) : v;
}
static inline uintptr_t align_up_ptr(uintptr_t v, uintptr_t a) {
    return (a > 1u) ? ((v + (a - 1u)) & ~(a - 1u)) : v;
}

/* 4-byte 對齊；不切段（DMALEN=32b 可吃到 4GB） */
static bool append_desc(uintptr_t src, uintptr_t dst, uint32_t len)
{
    if (len == 0) return false;

    // 4-byte 對齊保險
    src = align_up_ptr(src, 4);
    dst = align_up_ptr(dst, 4);
    len = align_up(len, 4);
    if (((src | dst | len) & 0x3u) != 0) return false;

    if (g_desc_count >= MAX_DESCS) return false;

    // 確認寫入不超出 256B 規定區
    uintptr_t next_addr = (uintptr_t)&g_descs[g_desc_count + 1u];
    if (next_addr > (DESCLIST_END_ADDR + 1u)) return false;

    volatile dma_desc_t* d = &g_descs[g_desc_count++];
    d->DMASRC    = (uint32_t)src;
    d->DMADST    = (uint32_t)dst;
    d->DMALEN    = len;
    d->NEXT_DESC = 0;
    d->EOC       = 0;
    d->rsv0 = d->rsv1 = d->rsv2 = 0;
    return true;
}

static void build_descriptor_chain(void)
{
    g_desc_count = 0;

    // 1) IMEM：DRAM_I → IMEM
    {
        uintptr_t src = (uintptr_t)&_dram_i_start;
        uintptr_t dst = (uintptr_t)&_imem_start;
        uint32_t  len = (uint32_t)((uintptr_t)&_dram_i_end - (uintptr_t)&_dram_i_start);
        (void)append_desc(src, dst, len);
    }

    // 2) .sdata：DRAM_D → DMEM
    {
        uintptr_t src = (uintptr_t)&_sdata_paddr_start;
        uintptr_t dst = (uintptr_t)&_sdata_start;
        uint32_t  len = (uint32_t)((uintptr_t)&_sdata_end - (uintptr_t)&_sdata_start);
        (void)append_desc(src, dst, len);
    }

    // 3) .data：DRAM_D → DMEM
    {
        uintptr_t src = (uintptr_t)&_data_paddr_start;
        uintptr_t dst = (uintptr_t)&_data_start;
        uint32_t  len = (uint32_t)((uintptr_t)&_data_end - (uintptr_t)&_data_start);
        (void)append_desc(src, dst, len);
    }

    // NEXT_DESC 與 EOC
    for (uint32_t i = 0; i < g_desc_count; ++i) {
        uint32_t next = (i + 1u < g_desc_count) ? (uint32_t)(uintptr_t)&g_descs[i + 1u] : 0u;
        g_descs[i].NEXT_DESC = next;
        g_descs[i].EOC       = (i + 1u == g_desc_count) ? 1u : 0u;
    }
}

/*==================== 啟動 DMA（DESC_BASE + DMAEN） ====================*/
static void start_dma_chain(void)
{
    if (g_desc_count == 0) { g_dma_done_flag = 1; return; }

    fence_rw(); // 確保 descriptors 已寫入 0x0002FF00~0x0002FFFF

    DMA_REG_DESC_BASE = (uint32_t)(uintptr_t)&g_descs[0];  // 0x0002FF00
    DMA_REG_DMAEN     = 1u;                                // 啟動 DMA FSM
}

/*==================== ISR（DMA_interrupt） ====================*/
/* 綁定到 DMA 的中斷號；你的規格：ISR 需將 DMAEN 拉低以清除中斷 */
void dma_isr(void)
{
    // 清中斷語意：拉低 DMAEN
    DMA_REG_DMAEN = 0u;

    // 指令同步（IMEM 有搬運時必須）
    fence_rw();
    fence_i();

    g_dma_done_flag = 1;
}

/*==================== ROM 入口呼叫 ====================*/
void boot_main(void)
{
    g_dma_done_flag = 0;

    build_descriptor_chain();
    start_dma_chain();

    // 等 ISR 設定完成旗標；此處可同時做其他初始化
    while (!g_dma_done_flag) { /* optional: do other init */ }

    // 清零 .sbss/.bss（若需要，請在 link.ld 暴露 __sbss_start/__sbss_end/__bss_start/__bss_end）
    // extern unsigned int __sbss_start, __sbss_end, __bss_start, __bss_end;
    // for (volatile unsigned int* p=&__sbss_start; p<&__sbss_end; ++p) *p=0;
    // for (volatile unsigned int* p=&__bss_start;  p<&__bss_end;  ++p) *p=0;

    // 跳主程式
    extern void main(void);
    main();
}
