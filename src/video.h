#pragma once

#include "stdint.h"
#include <stdbool.h>
#define SCREEN_HEIGHT_PIXELS 342
#define SCREEN_WIDTH_PIXELS 512
#define SCREEN_HEIGHT_CHARACTERS (SCREEN_HEIGHT_PIXELS / 8)
#define SCREEN_WIDTH_CHARACTERS (SCREEN_WIDTH_PIXELS / 8)

#define FRAMEBUFFER_SIZE_BYTES (SCREEN_HEIGHT_PIXELS * SCREEN_WIDTH_PIXELS / 8)

#define FRAMEBUFFER_START_POINTER  (*((volatile uint32_t*) 0x824))

enum Color {
    COLOR_BLACK,
    COLOR_WHITE,
};


// Color support?
void drawCharacter(uint16_t x, uint16_t y, char c, enum Color foreground);
void drawString(uint16_t termX, uint16_t termY, char *s, enum Color foreground);

// TODO: graphics/pixel drawing
void clearScreen(enum Color color);

void drawPixel(uint16_t pixelX, uint16_t pixelY, enum Color color);