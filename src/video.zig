//! Video drivers

/// A pointer to the address at which the framebuffer starts
const POINTER_TO_FB_START_ADDRESS: *u32 = @intToPtr(*u32, 0x824);
/// The height of the screen in pixels
pub const SCREEN_HEIGHT_PIXELS: u32 = 342;
/// The width of the screen in pixels
pub const SCREEN_WIDTH_PIXELS: u32 = 512;
const SCREEN_WIDTH_BYTES: u32 = @divExact(SCREEN_WIDTH_PIXELS, 8);

/// The possible colors of a pixel
pub const Color = enum {
    Black,
    White,
};


fn systemError(_: u16) callconv(.C) void {
    // Zig bug: binding a u16 value causes a segfault in compilation
    asm volatile ("move.l (%sp)+,%d0; .short 0xA9C9");
}

// Zig bug: adding any arguments after an enum argument causes Zig to generate
// C code that doesn't compile
// TODO: index this based on screen indice (per 8x8 not per 1x1)
pub fn drawCharacter(x: u16, y: u16, character: u8, color: Color) void {
    // TODO: errors
    if (x + 6 > SCREEN_WIDTH_PIXELS) {
        return;
    }
    if (y + 7 > SCREEN_HEIGHT_PIXELS) {
        return;
    }

    // This breaks the switch, idk why
    if (character == 'Y' or character == 'y') {
        drawLetterY(x, y, color);
        return;
    }

    switch (character) {
        // Lowercase isn't supported yet
        // Zig bug: generated C code doesn't compile without the braces
        'A', 'a' => { drawLetterA(x, y, color); },
        'G', 'g' => { drawLetterG(x, y, color); },
        ' ' => { drawSpace(x, y, color); },
        else => { drawNonExistantSymbol(x, y, color); },
    }
}

// (x, y) is for top left of letter
// TODO: support black background?
pub fn drawLetterA(x: u16, y: u16, color: Color) void {
    const fb_start = POINTER_TO_FB_START_ADDRESS.*;
    const row0 = @intToPtr(*u8, fb_start + @divTrunc(x + (y * SCREEN_WIDTH_PIXELS), 8));
    const row1 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 1) * SCREEN_WIDTH_PIXELS), 8));
    const row2 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 2) * SCREEN_WIDTH_PIXELS), 8));
    const row3 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 3) * SCREEN_WIDTH_PIXELS), 8));
    const row4 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 4) * SCREEN_WIDTH_PIXELS), 8));
    const row5 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 5) * SCREEN_WIDTH_PIXELS), 8));
    const row6 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 6) * SCREEN_WIDTH_PIXELS), 8));

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

pub fn drawLetterG(x: u16, y: u16, color: Color) void {
    const fb_start = POINTER_TO_FB_START_ADDRESS.*;

    const row0 = @intToPtr(*u8, fb_start + @divTrunc(x + (y * SCREEN_WIDTH_PIXELS), 8));
    const row1 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 1) * SCREEN_WIDTH_PIXELS), 8));
    const row2 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 2) * SCREEN_WIDTH_PIXELS), 8));
    const row3 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 3) * SCREEN_WIDTH_PIXELS), 8));
    const row4 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 4) * SCREEN_WIDTH_PIXELS), 8));
    const row5 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 5) * SCREEN_WIDTH_PIXELS), 8));
    const row6 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 6) * SCREEN_WIDTH_PIXELS), 8));

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

pub fn drawLetterY(x: u16, y: u16, color: Color) void {
    const fb_start = POINTER_TO_FB_START_ADDRESS.*;

    const row0 = @intToPtr(*u8, fb_start + @divTrunc(x + (y * SCREEN_WIDTH_PIXELS), 8));
    const row1 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 1) * SCREEN_WIDTH_PIXELS), 8));
    const row2 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 2) * SCREEN_WIDTH_PIXELS), 8));
    const row3 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 3) * SCREEN_WIDTH_PIXELS), 8));
    const row4 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 4) * SCREEN_WIDTH_PIXELS), 8));
    const row5 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 5) * SCREEN_WIDTH_PIXELS), 8));
    const row6 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 6) * SCREEN_WIDTH_PIXELS), 8));

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

pub fn drawSpace(x: u16, y: u16, color: Color) void {
    const fb_start = POINTER_TO_FB_START_ADDRESS.*;

    const row0 = @intToPtr(*u8, fb_start + @divTrunc(x + (y * SCREEN_WIDTH_PIXELS), 8));
    const row1 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 1) * SCREEN_WIDTH_PIXELS), 8));
    const row2 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 2) * SCREEN_WIDTH_PIXELS), 8));
    const row3 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 3) * SCREEN_WIDTH_PIXELS), 8));
    const row4 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 4) * SCREEN_WIDTH_PIXELS), 8));
    const row5 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 5) * SCREEN_WIDTH_PIXELS), 8));
    const row6 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 6) * SCREEN_WIDTH_PIXELS), 8));

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

pub fn drawNonExistantSymbol(x: u16, y: u16, color: Color) void {
    const fb_start = POINTER_TO_FB_START_ADDRESS.*;

    const row0 = @intToPtr(*u8, fb_start + @divTrunc(x + (y * SCREEN_WIDTH_PIXELS), 8));
    const row1 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 1) * SCREEN_WIDTH_PIXELS), 8));
    const row2 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 2) * SCREEN_WIDTH_PIXELS), 8));
    const row3 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 3) * SCREEN_WIDTH_PIXELS), 8));
    const row4 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 4) * SCREEN_WIDTH_PIXELS), 8));
    const row5 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 5) * SCREEN_WIDTH_PIXELS), 8));
    const row6 = @intToPtr(*u8, fb_start + @divTrunc(x + ((y + 6) * SCREEN_WIDTH_PIXELS), 8));

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
