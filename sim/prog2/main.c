
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;




void timer_interrupt_handler(void) {
  asm("csrsi mstatus, 0x0"); // MIE of mstatus
  WDT_addr[0x40] = 0; // WDT_en
  asm("j _start");
}

void external_interrupt_handler(void) {
	volatile unsigned int *dma_addr_boot = (int *) 0x10020000;
	asm("csrsi mstatus, 0x0"); // MIE of mstatus
	dma_addr_boot[0x40] = 0; // disable DMA
} 

void trap_handler(void) {
    uint32_t mip;
    asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));
	
    if ((mip & MIP_MTIP) >> 7) {
        timer_interrupt_handler();
    }

    if ((mip & MIP_MEIP) >> 11) {
        external_interrupt_handler();
    }
}

static uint16_t le16(const uint8_t *p) {
    return (uint16_t)p[0] | ((uint16_t)p[1] << 8);
}
static uint32_t le32(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

int main(void) {
    FILE *fi = fopen("image.bmp", "rb");
    if (!fi) { perror("無法開啟 image.bmp"); return 1; }
    FILE *fo = fopen("output.bmp", "wb");
    if (!fo) { perror("無法建立 output.bmp"); fclose(fi); return 1; }

    uint8_t bf[14], bi[40];
    fread(bf, 1, 14, fi);
    fread(bi, 1, 40, fi);
    fwrite(bf, 1, 14, fo);
    fwrite(bi, 1, 40, fo);

    uint32_t bfOffBits = le32(&bf[10]);
    fseek(fi, (long)(bfOffBits - 54), SEEK_CUR);

    int32_t width  = (int32_t)le32(&bi[4]);
    int32_t height = (int32_t)le32(&bi[8]);
    uint32_t row_bytes = ((uint32_t)width * 3u + 3u) & ~3u;
    uint32_t pad = row_bytes - (uint32_t)width * 3u;
    uint8_t *row = malloc(row_bytes);
    if (!row) { fprintf(stderr, "記憶體配置失敗\n"); goto FAIL; }

    for (int32_t y = 0; y < (height < 0 ? -height : height); ++y) {
        fread(row, 1, row_bytes, fi);
        uint8_t *p = row;
        for (int32_t x = 0; x < width; ++x) {
            double b = (double)p[0];
            double g = (double)p[1];
            double r = (double)p[2];
            double xd = 0.11 * b + 0.59 * g + 0.3 * r;

            /* 使用 IEEE 754 round-to-nearest, ties-to-even */
            long g8 = lrint(xd);  // 或 nearbyint(xd) 再轉 long
            if (g8 < 0)   g8 = 0;
            if (g8 > 255) g8 = 255;

            p[0] = p[1] = p[2] = (uint8_t)g8;
            p += 3;
        }
        for (uint32_t k = 0; k < pad; ++k) row[row_bytes - pad + k] = 0;
        fwrite(row, 1, row_bytes, fo);
    }

    free(row);
    fclose(fi);
    fclose(fo);
    return 0;

FAIL:
    fclose(fi);
    fclose(fo);
    return 1;
}