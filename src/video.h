#pragma once

#include "stdint.h"

#define SCREEN_HEIGHT_PIXELS 512
#define SCREEN_WIDTH_PIXELS 342
#define SCREEN_HEIGHT_CHARACTERS (SCREEN_HEIGHT_PIXELS / 8)
#define SCREEN_WIDTH_CHARACTERS (SCREEN_WIDTH_PIXELS / 8)

#define FRAMEBUFFER_SIZE_BYTES (SCREEN_HEIGHT_PIXELS * SCREEN_WIDTH_PIXELS / 8)

#define FRAMEBUFFER_START_POINTER  (*((volatile uint32_t*) 0x824))

// Color support?
void drawCharacter(uint16_t x, uint16_t y, char c);

// TODO: graphics/pixel drawing
void blackenScreen();
void whitenScreen();
