// Terminal emulation

#include <video.h>
#include <terminal.h>

void printChar(Terminal* term, char c) {
    if (c == '\n') {
        term->cursorY++;
        term->cursorX = 0;
    } else {
        drawCharacter(term->cursorX, term->cursorY, c, term->textColor);
        term->cursorX++;
    }

    if (term->cursorX > term->maxX) {
        term->cursorX = 0;
        term->cursorY++;
    }

    if (term->cursorY > term->maxY) {
        // Scroll
        scroll(1, term->backgroundColor);
        term->cursorY--;
    }
}


void printString(Terminal* term, char* s) {
    for (int i = 0; s[i] != '\0'; i++) {
        printChar(term, s[i]);
    }
}

inline uint8_t getBackgroundByte(Terminal* term) {

}
void resetTerminal(Terminal* term) {
    switch (term->textColor) {
        case COLOR_WHITE:
            clearScreen(COLOR_BLACK);
            break;
        case COLOR_BLACK:
            clearScreen(COLOR_WHITE);
            break;
    }
    term->cursorX = 0;
    term->cursorY = 0;
}

Terminal createTerminal(enum Color textColor, enum Color backgroundColor) {
    Terminal term;

    term.cursorX = 0;
    term.cursorY = 0;

    term.maxX = SCREEN_WIDTH_BYTES - 1;
    term.maxY = SCREEN_HEIGHT_BYTES - 1;

    term.textColor = textColor;
    term.backgroundColor = backgroundColor;

    return term;
}