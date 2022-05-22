// Terminal emulation

typedef struct {
    // X- and Y-positions are in character, not pixel, coordinates
    uint8_t cursorX;
    uint8_t cursorY;

    Color color;
} Terminal;