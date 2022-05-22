// Entry point for C code

#include "stdint.h"
#include <stdbool.h>
#include "terminal.h"

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

// Never returns
void entryPoint() {
    Terminal t = createTerminal(COLOR_BLACK);
    resetTerminal(&t);
    printString(&t, "                          Hello, world!\n");
    printString(&t, "Let's test line wrapping...............................have a nice day!\n");

    for (;;) {}
}