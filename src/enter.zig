const video = @import("video.zig");

extern fn _SysError(_: u16) callconv(.C) void;
fn wasteTime(amount: u32) void {
    var i: u32 = 0;
    while (i < amount * 10000) {
        i += 1;
    }
}

fn removeMacLogo() void {
    // TODO: figure out why _SysError is broken
    var x: u16 = 243;
    var y: u16 = 145;
    while (y < 177) {
        var white: u16 = 0;
        if (y % 2 == 0) {
            white = 1;
        }
        while (x < 268) {
            var color: video.Color = .Black;
            if (x % 2 == white) {
                color = .White;
            }
            video.drawPixel(color, x, y);
            x += 1;
        }
        x = 243;
        y += 1;
    }
}

export fn zigEntry() void {
    // removeMacLogo();
    video.fastFillScreen(.Black);
    for (0..video.SCREEN_HEIGHT_PIXELS) |x| {
        var i = @intCast(u16, x);
        video.drawPixel(.White, i, i);
    }
    video.fastFillScreen(.White);

    var x: u16 = 0;
    var y: u16 = 0;
    while (y < video.SCREEN_HEIGHT_PIXELS) {
        while (x < (video.SCREEN_WIDTH_PIXELS + 7)) {
            video.drawLetter(x, y, false, .A);
            x += 8;
        }
        x = 0;
        y += 8;
    }
    while (true) {}
}
