// Entry point for C code

#include <stdint.h>
#include <stdbool.h>
#include <terminal.h>

void systemError(uint16_t code) {
   asm("move.l (%sp)+,%d0; .short 0xA9C9");
}

// Never returns
void entryPoint() {
    Terminal t = createTerminal(COLOR_BLACK);
    resetTerminal(&t);
    printString(&t, "                          Hello, world!\n");
    printString(&t, "Let's test line wrapping...............................have a nice day!\n\n");
    printString(&t, "What about scrolling?\n");

    const char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789\n";
    for (int i = 0; alphabet[i] != '\0'; i++) {
        printChar(&t, '\n');
        printChar(&t, ' ');
        printChar(&t, alphabet[i]);
    }

    printString(&t, "looks like scrolling works!\n");

    for (;;) {}
}