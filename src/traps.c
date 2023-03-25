// Traps file

#include <stdint.h>
void _SysError(uint16_t const trap) {
    __asm__ volatile("movel #44444444,%d0; .short 0xA9C9");
}
