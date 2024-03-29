
#include "video.h"
typedef struct {
    // X- and Y-positions are in character, not pixel, coordinates
    uint8_t cursorX;
    uint8_t cursorY;

    uint8_t maxX;
    uint8_t maxY;

    // current text color
    enum Color textColor;
    enum Color backgroundColor;
} Terminal;

void printChar(Terminal* term, char c);
void printString(Terminal* term, char* str);
void resetTerminal(Terminal* term);

Terminal createTerminal(enum Color textColor, enum Color backgroundColor);
