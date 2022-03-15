//! Video drivers

/// A pointer to the address at which the framebuffer starts
const POINTER_TO_FB_START_ADDRESS: *u32 = @intToPtr(*u32, 0x824);
/// The height of the screen in pixels
pub const SCREEN_HEIGHT: u32 = 342;
/// The width of the screen in pixels
pub const SCREEN_WIDTH: u32 = 512;

/// The possible colors of a pixel
pub const Color = enum {
    Black,
    White,
};

// pub const VideoError = error {
//     XCoordinateTooLarge,
//     YCoordinateTooLarge,
// };

/// Draws a pixel on the screen with the given color and coordinates.
///
/// (0, 0) is the top left corner of the screen; (511, 341) is the bottom right corner.
/// This is NOT like your standard Cartesian plane!
pub fn drawPixel(color: Color, x: u16, y: u16) void {
    // TODO: Use an error when it doesn't break transpilation to C
    if (y >= SCREEN_HEIGHT) {
        return;
    }
    if (x >= SCREEN_WIDTH) {
        return;
    }

    var offset: u32 = y * SCREEN_WIDTH + x;
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
    while (y < SCREEN_HEIGHT) : (y += 1) {
        while (x < SCREEN_WIDTH) : (x += 1) {
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

    const totalChunks = @divTrunc(SCREEN_HEIGHT * SCREEN_WIDTH, 32);
    var chunksSoFar: u32 = 0;

    while (chunksSoFar < totalChunks) : (chunksSoFar += 1) {
        const next32 = @intToPtr(*u32, POINTER_TO_FB_START_ADDRESS.* + chunksSoFar * 4);
        next32.* = fill;
    }
}
