// Entry point for C code

#include "stdint.h"
#include <stdbool.h>
#include "video.h"

// Wastes time
void wasteTime(uint32_t amount) {
    uint32_t i = 0;
    while (i < amount) {
        i++;
    }
}

void systemError(uint16_t code) {
   asm("move.l (%sp)+,%d0; .short 0xA9C9");
}

volatile void x() {}
// Never returns
void entryPoint() {
    whitenScreen();
    drawString(25, 20, "mac68k project", false);
    for (;;) {}
}