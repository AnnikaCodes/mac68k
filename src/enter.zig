const video = @import("video.zig");

fn wasteTime(amount: u32) void {
    var i: u32 = 0;
    while (i < amount * 10000) {
        i += 1;
    }
}
export fn zigEntry() void {
  // Welcome to Zig!
  video.fastFillScreen(.Black);

  // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  var x: u16 = 0;
  var y: u16 = 0;
  while (y < video.SCREEN_HEIGHT_PIXELS) {
    while (x < (video.SCREEN_WIDTH_PIXELS + 7)) {
      video.drawLetter(x, y, true, .A);
      x += 8;
    }
    x = 0;
    y += 8;
  }
  while (true) {}
}
