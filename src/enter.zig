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

    // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    var x: u16 = 0;
    var y: u16 = 0;
    while (y < video.SCREEN_HEIGHT_PIXELS) {
      while (x < video.SCREEN_WIDTH_PIXELS) {
        video.drawLetterA(x, y);
        x += 7;
      }
      x = 0;
      y += 7;
    }


    while (true) {}
}
