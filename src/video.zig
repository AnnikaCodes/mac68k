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

pub const Letter = enum {
    A,
};

// Zig bug: adding any arguments after an enum argument causes Zig to generate
// C code that doesn't compile
pub fn drawLetter(x: u16, y: u16, isBlack: bool, letter: Letter) void {
    // TODO: errors
    if (x + 6 > SCREEN_WIDTH_PIXELS) {
        return;
    }
    if (y + 7 > SCREEN_HEIGHT_PIXELS) {
        return;
    }

    const color = switch (isBlack) {
        true => Color.Black,
        false => Color.White,
    };
    switch (letter) {
        .A => drawLetterA(x, y, color),
    }
}

// (x, y) is for top left of letter
// TODO: support black background?
// TODO:
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
            row0.* = 0b00011000;
            row1.* = 0b00100100;
            row2.* = 0b01000010;
            row3.* = 0b01111110;
            row4.* = 0b01000010;
            row5.* = 0b01000010;
            row6.* = 0b01000010;
        },
        .Black => {
            row0.* = 0b11100111;
            row1.* = 0b11011011;
            row2.* = 0b10111101;
            row3.* = 0b10000001;
            row4.* = 0b10111101;
            row5.* = 0b10111101;
            row6.* = 0b10111101;
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
