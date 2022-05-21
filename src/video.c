#include "stdint.h"
#include "video.h"
#include "font.h"

void fillScreen(uint32_t fill) {
    uint32_t i = 0;
    while (i < (FRAMEBUFFER_SIZE_BYTES / 4)) {
        (*((uint32_t *) FRAMEBUFFER_START_POINTER + i)) = fill;
        i++;
    }
}

void blackenScreen() {
    fillScreen(0xFFFFFFFF);
}

void whitenScreen() {
    fillScreen(0x00000000);
}

void drawCharacter(uint16_t termX, uint16_t termY, char c, bool isWhiteFg) {
    if ((int)c > 127) {
        c = (char)0;
    }

    // Necessary to properly interpret the funky bitmaps in the font I stole from the Internet
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            bool color = FONT[c][x] & 1 << y;
            drawPixel(termX * 8 + y, termY * 8 + x, isWhiteFg ? !color : color);
        }
    }
}

// TODO: implement scrolling
// TODO: implement a terminal with persisten cursor and color tracking (struct? data passed around?)
// TODO: implement line wrapping
void drawString(uint16_t termX, uint16_t termY, char *s, bool isWhiteFg) {
    for (int i = 0; s[i] != '\0'; i++) {
        drawCharacter(termX + i, termY, s[i], isWhiteFg);
    }
}

void drawPixel(uint16_t pixelX, uint16_t pixelY, bool isBlack) {
    if (pixelX > SCREEN_WIDTH_PIXELS || pixelY > SCREEN_HEIGHT_PIXELS) {
        return; // TODO: error
    }

    uint8_t xOffset = 7 - (pixelX % 8);
    uint8_t *next8 = (uint8_t *) FRAMEBUFFER_START_POINTER + (pixelX / 8) + pixelY * SCREEN_WIDTH_CHARACTERS;
    if (isBlack) {
        // Set pixel to black
        (*next8) |= 1 << xOffset;
    } else {
        // Set pixel to white
        (*next8) &= ~(1 << xOffset);
    }
}
