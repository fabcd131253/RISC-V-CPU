#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;


extern int array_size;
extern int array_addr[];
extern long long _test_start;


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



int main() {
    int n = array_size;
    if (n <= 0) return 0;

    // Allocate local buffer on the stack (assume n is small, e.g., 32)
    int buf[64]; // safe upper bound (if n > 64, fallback below)

    if (n <= 64) {
        // Single pass copy from external memory to local buffer
        for (int i = 0; i < n; ++i) {
            buf[i] = array_addr[i];
        }

        // Insertion sort on local buffer (minimize memory accesses to external)
        for (int i = 1; i < n; ++i) {
            int key = buf[i];
            int j = i - 1;
            while (j >= 0 && buf[j] > key) {
                buf[j + 1] = buf[j];
                --j;
            }
            buf[j + 1] = key;
        }

        // Single pass write to _test_start
        unsigned int *dst = (unsigned int *)&_test_start;
        for (int i = 0; i < n; ++i) dst[i] = (unsigned int)buf[i];

    } else {
        // Fallback for large n: process in-place to avoid large stack allocation.
        // This fallback will perform standard in-place insertion sort on external memory.
        int *arr = array_addr;
        for (int i = 1; i < n; ++i) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                --j;
            }
            arr[j + 1] = key;
        }
        // Write sorted result to _test_start (copy)
        unsigned int *dst = (unsigned int *)&_test_start;
        for (int i = 0; i < n; ++i) dst[i] = (unsigned int)arr[i];
    }

    return 0;
}
