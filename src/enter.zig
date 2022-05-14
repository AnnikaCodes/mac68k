const Terminal = @import("terminal.zig").Terminal;
const v = @import("video.zig");

fn wasteTime(amount: u32) void {
    var i: u32 = 0;
    while (i < amount * 10000) {
        i += 1;
    }
}
export fn zigEntry() void {
  var term = Terminal {};
  term.setForegroundColor(.Black);
  term.clearScreen();

  term.printString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890,;]?.!\n\n");
  term.printString("SPHINX OF BLACK QUARTZ, JUDGE MY VOW.\n");

  var x: u8 = 1;
  term.printHexNumber(@ptrToInt(&x));
  term.printChar('\n');
  x = 42;
  term.printHexNumber(@ptrToInt(&x));

  // TODO: make a proper font instead of the hacky stuff we've got at the moment
  // Option to NOT it for reverse colors;
  // indexable array based upon the ASCII value of a character?
  const letterA = [7]u8{
            0b00011000,
            0b00100100,
            0b01000010,
          0b01111110,
            0b01000010,
            0b01000010,
            0b01000010,
  };
  v.drawBitmap(30, 30, letterA);

  while (true) {}
}
