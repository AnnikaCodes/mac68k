#include "stdint.h"

// Wastes time
void wasteTime(uint32_t amount) {
    uint32_t i = 0;
    while (i < amount) {
        i++;
    }
}

// Memory copying tool
//
// Copies `bytes` bytes from `src` to `dest`.
void copyMemory(const uint8_t* src, uint8_t* dest, long unsigned int bytes) {
    for (uint32_t i = 0; i < bytes; i++) {
        dest[i] = src[i];
    }
}
