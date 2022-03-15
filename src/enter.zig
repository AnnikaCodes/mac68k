const video = @import("video.zig");

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
export fn zigEntry() void {
    // Welcome to Zig!
    video.fastFillScreen(.White);

    var i: u16 = 0;
    while (i < video.SCREEN_HEIGHT) : (i += 1) {
        video.drawPixel(.Black, i, i);
    }

    while (i >= 0) : (i -= 1) {
        video.drawPixel(.Black, i, @intCast(u16, video.SCREEN_HEIGHT) - i);
    }

    while (true) {}
}
