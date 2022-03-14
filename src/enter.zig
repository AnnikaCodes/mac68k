const framebuffer_start_pointer: *u32 = @intToPtr(*u32, 0x824);
const HEIGHT: u32 = 342;
const WIDTH: u32 = 512;
const TOTAL_32_BIT_CHUNKS: u32 = @divTrunc(512 * 342, 32);

fn systemError(_: u16) callconv(.C) void {
    // Zig bug: binding causes a segfault in compilation
    asm volatile ("move.l (%sp)+,%d0; .short 0xA9C9");
}

fn wasteTime(amount: u32) void {
    var i: u32 = 0;
    while (i < amount * 10000) {
        i += 1;
    }
}

const Color = enum {
    Black,
    White,
};

fn drawPixel(color: Color, x: u16, y: u16) void {
    if (y >= HEIGHT or x >= WIDTH) {
        return; // should probably throw an error once we can
    }

    var offset: u32 = y * WIDTH + x;
    const byteOffset: u32 = @divTrunc(offset, 8);
    const bitOffset: u3 = 7 - @intCast(u3, offset % 8);

    // TODO: investigate using a u1 here?
    const next8: *u8 = @intToPtr(*u8, framebuffer_start_pointer.* + byteOffset);
    const one: u8 = 1;
    switch (color) {
        // Make the first bit (pixel) a 1 (black) and leave the rest as they are
        .Black => next8.* |= one << bitOffset,
        // Make the first bit (pixel) a 0 (white) and leave the rest as they are
        .White => next8.* &= ~(one << bitOffset),
    }
}


// TODO: speed up clearing the screen
fn naiveFillScreen(color: Color) void {
    var x: u16 = 0;
    var y: u16 = 0;
    while (y < HEIGHT) : (y += 1) {
        while (x < WIDTH) : (x += 1) {
            drawPixel(color, x, y);
        }
        x = 0;
    }
}

fn fastFillScreen(color: Color) void {
    const fill: u32 = switch (color) {
        .Black => 0xFFFFFFFF,
        .White => 0x00000000,
    };
    var chunksSoFar: u32 = 0;
    while (chunksSoFar < TOTAL_32_BIT_CHUNKS) : (chunksSoFar += 1) {
        const next32 = @intToPtr(*u32, framebuffer_start_pointer.* + chunksSoFar * 4);
        next32.* = fill;
    }
}

export fn zigEntry() void {
    // Welcome to Zig!
    while (true) {
        fastFillScreen(.White);
        fastFillScreen(.Black);
    }
}
