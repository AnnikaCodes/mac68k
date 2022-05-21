#include "stdint.h"
#include "video.h"

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