//! Video drivers

/// A pointer to the address at which the framebuffer starts
pub const POINTER_TO_FB_START_ADDRESS: *u32 = @intToPtr(*u32, 0x824);
/// The height of the screen in pixels
pub const SCREEN_HEIGHT_PIXELS: u32 = 342;
/// The width of the screen in pixels
pub const SCREEN_WIDTH_PIXELS: u32 = 512;
/// The height of the screen in characters
pub const SCREEN_WIDTH_CHARACTERS: u32 = @divExact(SCREEN_WIDTH_PIXELS, 8);
/// The height of the screen in characters
pub const SCREEN_HEIGHT_CHARACTERS: u32 = @divTrunc(SCREEN_HEIGHT_PIXELS, 8);

/// The possible colors of a pixel
pub const Color = enum {
    Black,
    White,
};

pub fn systemError(_: u16) callconv(.C) void {
    // Zig bug: binding a u16 value causes a segfault in compilation
    asm volatile ("move.l (%sp)+,%d0; .short 0xA9C9");
}

// Zig bug: adding any arguments after an enum argument causes Zig to generate
// C code that doesn't compile
//
// Indiced on a 64x42 terminal grid where each character is 8x8 pixels.
pub fn drawCharacter(x: u16, y: u16, character: u8, color: Color) void {
    // TODO: errors
    if (x >= 64 or y >= 42) {
        return;
    }

    const fb_start = POINTER_TO_FB_START_ADDRESS.*;

    const pixelY = y * 8;
    const row0 = @intToPtr(*u8, fb_start + x + (pixelY * SCREEN_WIDTH_CHARACTERS));
    const row1 = @intToPtr(*u8, fb_start + x + ((pixelY + 1) * SCREEN_WIDTH_CHARACTERS));
    const row2 = @intToPtr(*u8, fb_start + x + ((pixelY + 2) * SCREEN_WIDTH_CHARACTERS));
    const row3 = @intToPtr(*u8, fb_start + x + ((pixelY + 3) * SCREEN_WIDTH_CHARACTERS));
    const row4 = @intToPtr(*u8, fb_start + x + ((pixelY + 4) * SCREEN_WIDTH_CHARACTERS));
    const row5 = @intToPtr(*u8, fb_start + x + ((pixelY + 5) * SCREEN_WIDTH_CHARACTERS));
    const row6 = @intToPtr(*u8, fb_start + x + ((pixelY + 6) * SCREEN_WIDTH_CHARACTERS));

    // `switch` causes Sad Mac crashes
    // use a lookup table?
    if (character == 'A') {
        drawLetterA(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'B') {
        drawLetterB(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'C') {
        drawLetterC(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'D') {
        drawLetterD(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'E') {
        drawLetterE(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'F') {
        drawLetterF(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'G') {
        drawLetterG(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'H') {
    //     drawLetterH(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'I') {
    //     drawLetterI(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'J') {
    //     drawLetterJ(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'K') {
    //     drawLetterK(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'L') {
    //     drawLetterL(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'M') {
    //     drawLetterM(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'N') {
    //     drawLetterN(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'Ñ') {
    //     drawLetterEnya(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'O') {
    //     drawLetterO(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'P') {
    //     drawLetterP(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'Q') {
    //     drawLetterQ(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'R') {
    //     drawLetterR(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'S') {
    //     drawLetterS(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'T') {
    //     drawLetterT(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'U') {
    //     drawLetterU(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'V') {
    //     drawLetterV(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'W') {
    //     drawLetterW(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'X') {
    //     drawLetterX(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == 'Y') {
        drawLetterY(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == 'Z') {
    //     drawLetterZ(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '0') {
    //     drawNumber0(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '1') {
    //     drawNumber1(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '2') {
    //     drawNumber2(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '3') {
    //     drawNumber3(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '4') {
    //     drawNumber4(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '5') {
    //     drawNumber5(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '6') {
    //     drawNumber6(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '7') {
    //     drawNumber7(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '8') {
    //     drawNumber8(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '9') {
    //     drawNumber9(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == ',') {
        drawComma(row0, row1, row2, row3, row4, row5, row6, color);
    } else if (character == '.') {
        drawPeriod(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == ';'' {
    //     drawSemicolon(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == ':') {
    //     drawColon(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '!') {
    //     drawExclamationMark(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '?') {
    //     drawQuestionMark(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '\'') {
    //     drawApostrophe(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '"') {
    //     drawQuote(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '-') {
    //     drawHyphen(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '+') {
    //     drawPlus(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '=') {
    //     drawEquals(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '*') {
    //     drawAsterisk(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '%') {
    //     drawPercent(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '<') {
    //     drawLessThan(row0, row1, row2, row3, row4, row5, row6, color);
    // } else if (character == '>') {
    //     drawGreaterThan(row0, row1, row2, row3, row4, row5, row6, color);
    } else {
        drawNonExistantSymbol(row0, row1, row2, row3, row4, row5, row6, color);
    }
}

// (x, y) is for top left of letter
pub fn drawLetterA(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11100111;
            row1.* = 0b11011011;
            row2.* = 0b10111101;
            row3.* = 0b10000001;
            row4.* = 0b10111101;
            row5.* = 0b10111101;
            row6.* = 0b10111101;
        },
        .Black => {
            row0.* = 0b00011000;
            row1.* = 0b00100100;
            row2.* = 0b01000010;
            row3.* = 0b01111110;
            row4.* = 0b01000010;
            row5.* = 0b01000010;
            row6.* = 0b01000010;
        },
    }
}

pub fn drawLetterB(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .Black => {
            row0.* = 0b01111100;
            row1.* = 0b01000010;
            row2.* = 0b01000010;
            row3.* = 0b01111100;
            row4.* = 0b01000010;
            row5.* = 0b01000010;
            row6.* = 0b01111100;
        },
        .White => {
            row0.* = 0b10111101;
            row1.* = 0b10111101;
            row2.* = 0b10111101;
            row3.* = 0b10000011;
            row4.* = 0b10111101;
            row5.* = 0b10111101;
            row6.* = 0b10000011;
        },
    }
}

pub fn drawLetterC(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11000011;
            row1.* = 0b10111111;
            row2.* = 0b10111111;
            row3.* = 0b10111111;
            row4.* = 0b10111111;
            row5.* = 0b10111111;
            row6.* = 0b11000011;
        },
        .Black => {
            row0.* = 0b00111100;
            row1.* = 0b01000000;
            row2.* = 0b01000000;
            row3.* = 0b01000000;
            row4.* = 0b01000000;
            row5.* = 0b01000000;
            row6.* = 0b00111100;
        },
    }
}

pub fn drawLetterD(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11000011;
            row1.* = 0b10111111;
            row2.* = 0b10111111;
            row3.* = 0b10111111;
            row4.* = 0b10111111;
            row5.* = 0b10111111;
            row6.* = 0b11000011;
        },
        .Black => {
            row0.* = 0b11111000;
            row1.* = 0b01000100;
            row2.* = 0b01000100;
            row3.* = 0b01000100;
            row4.* = 0b01000100;
            row5.* = 0b01000100;
            row6.* = 0b11111000;
        },
    }
}

pub fn drawLetterE(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b10000011;
            row1.* = 0b10111111;
            row2.* = 0b10111111;
            row3.* = 0b10000111;
            row4.* = 0b10111111;
            row5.* = 0b10111111;
            row6.* = 0b10000011;
        },
        .Black => {
            row0.* = 0b01111100;
            row1.* = 0b01000000;
            row2.* = 0b01000000;
            row3.* = 0b01111000;
            row4.* = 0b01000000;
            row5.* = 0b01000000;
            row6.* = 0b01111100;
        },
    }
}

pub fn drawLetterF(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b10000011;
            row1.* = 0b10111111;
            row2.* = 0b10111111;
            row3.* = 0b10000111;
            row4.* = 0b10111111;
            row5.* = 0b10111111;
            row6.* = 0b10111111;
        },
        .Black => {
            row0.* = 0b01111100;
            row1.* = 0b01000000;
            row2.* = 0b01000000;
            row3.* = 0b01111000;
            row4.* = 0b01000000;
            row5.* = 0b01000000;
            row6.* = 0b01000000;
        },
    }
}

pub fn drawLetterG(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11000111;
            row1.* = 0b10111011;
            row2.* = 0b10111111;
            row3.* = 0b10100011;
            row4.* = 0b10111011;
            row5.* = 0b10111011;
            row6.* = 0b11000011;
        },
        .Black => {
            row0.* = 0b00111000;
            row1.* = 0b01000100;
            row2.* = 0b01000000;
            row3.* = 0b01011100;
            row4.* = 0b01000100;
            row5.* = 0b01000100;
            row6.* = 0b00111100;
        },
    }
}


pub fn drawLetterY(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b10111110;
            row1.* = 0b10111110;
            row2.* = 0b11011101;
            row3.* = 0b11100011;
            row4.* = 0b11110111;
            row5.* = 0b11110111;
            row6.* = 0b11110111;
        },
        .Black => {
            row0.* = 0b01000001;
            row1.* = 0b01000001;
            row2.* = 0b00100010;
            row3.* = 0b00011100;
            row4.* = 0b00001000;
            row5.* = 0b00001000;
            row6.* = 0b00001000;
        },
    }
}

pub fn drawSpace(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    const fill: u8 = switch (color) {
        .White => 0b11111111,
        .Black => 0b00000000,
    };

    row0.* = fill;
    row1.* = fill;
    row2.* = fill;
    row3.* = fill;
    row4.* = fill;
    row5.* = fill;
    row6.* = fill;
}

pub fn drawNonExistantSymbol(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .Black => {
            row0.* = 0b01010100;
            row1.* = 0b00101010;
            row2.* = 0b01010100;
            row3.* = 0b00101010;
            row4.* = 0b01010100;
            row5.* = 0b00101010;
            row6.* = 0b01010100;
        },
        .White => {
            row0.* = 0b11010101;
            row1.* = 0b10101011;
            row2.* = 0b11010101;
            row3.* = 0b10101011;
            row4.* = 0b11010101;
            row5.* = 0b10101011;
            row6.* = 0b11010101;
        },
    }
}

pub fn drawComma(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11111111;
            row1.* = 0b11111111;
            row2.* = 0b11111111;
            row3.* = 0b11111111;
            row4.* = 0b10011111;
            row5.* = 0b10011111;
            row6.* = 0b00111111;
        },
        .Black => {
            row0.* = 0b00000000;
            row1.* = 0b00000000;
            row2.* = 0b00000000;
            row3.* = 0b00000000;
            row4.* = 0b01100000;
            row5.* = 0b01100000;
            row6.* = 0b11000000;
        },
    }
}

pub fn drawPeriod(row0: *u8, row1: *u8, row2: *u8, row3: *u8, row4: *u8, row5: *u8, row6: *u8, color: Color) void {
    switch (color) {
        .White => {
            row0.* = 0b11111111;
            row1.* = 0b11111111;
            row2.* = 0b11111111;
            row3.* = 0b11111111;
            row4.* = 0b11111111;
            row5.* = 0b00111111;
            row6.* = 0b00111111;
        },
        .Black => {
            row0.* = 0b00000000;
            row1.* = 0b00000000;
            row2.* = 0b00000000;
            row3.* = 0b00000000;
            row4.* = 0b00000000;
            row5.* = 0b11000000;
            row6.* = 0b11000000;
        },
    }
}

/// Draws a pixel on the screen with the given color and coordinates.
///
/// (0, 0) is the top left corner of the screen; (511, 341) is the bottom right corner.
/// This is NOT like your standard Cartesian plane!
pub fn drawPixel(color: Color, x: u16, y: u16) void {
    // TODO: Use an error when it doesn't break transpilation to C
    if (y >= SCREEN_HEIGHT_PIXELS) {
        return;
    }
    if (x >= SCREEN_WIDTH_PIXELS) {
        return;
    }

    var offset: u32 = y * SCREEN_WIDTH_PIXELS + x;
    const byteOffset: u32 = @divTrunc(offset, 8);
    const bitOffset: u3 = 7 - @intCast(u3, offset % 8);

    // TODO: investigate using a u1 here?
    const next8: *u8 = @intToPtr(*u8, POINTER_TO_FB_START_ADDRESS.* + byteOffset);
    const one: u8 = 1;
    switch (color) {
        // Make the first bit (pixel) a 1 (black) and leave the rest as they are
        .Black => next8.* |= one << bitOffset,
        // Make the first bit (pixel) a 0 (white) and leave the rest as they are
        .White => next8.* &= ~(one << bitOffset),
    }
}

fn naiveFillScreen(color: Color) !void {
    var x: u16 = 0;
    var y: u16 = 0;
    while (y < SCREEN_HEIGHT_PIXELS) : (y += 1) {
        while (x < SCREEN_WIDTH_PIXELS) : (x += 1) {
            try drawPixel(color, x, y);
        }
        x = 0;
    }
}


/// Quickly fills the screen with a single color.
pub fn fastFillScreen(color: Color) void {
    const fill: u32 = switch (color) {
        .Black => 0xFFFFFFFF,
        .White => 0x00000000,
    };

    const totalChunks = @divTrunc(SCREEN_HEIGHT_PIXELS * SCREEN_WIDTH_PIXELS, 32);
    var chunksSoFar: u32 = 0;

    while (chunksSoFar < totalChunks) : (chunksSoFar += 1) {
        const next32 = @intToPtr(*u32, POINTER_TO_FB_START_ADDRESS.* + chunksSoFar * 4);
        next32.* = fill;
    }
}
