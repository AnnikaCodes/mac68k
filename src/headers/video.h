#pragma once

#include "stdint.h"
#include <stdbool.h>
#define SCREEN_HEIGHT_PIXELS 342
#define SCREEN_WIDTH_PIXELS 512
#define SCREEN_HEIGHT_BYTES (SCREEN_HEIGHT_PIXELS / 8)
#define SCREEN_WIDTH_BYTES (SCREEN_WIDTH_PIXELS / 8)

// FB size should be 21888
#define FRAMEBUFFER_SIZE_BYTES 21888 // (SCREEN_HEIGHT_PIXELS * SCREEN_WIDTH_PIXELS / 8)

#define FRAMEBUFFER_START_POINTER  (*((volatile uint32_t*) 0x824))

enum Color {
    COLOR_BLACK = 0,
    COLOR_WHITE = 1,
};


// Color support?
void drawCharacter(uint16_t x, uint16_t y, char c, enum Color foreground);
void drawString(uint16_t termX, uint16_t termY, char *s, enum Color foreground);

// TODO: graphics/pixel drawing
void clearScreen(enum Color color);

void drawPixel(uint16_t pixelX, uint16_t pixelY, enum Color color);
void scroll(uint16_t lines, enum Color background_color);