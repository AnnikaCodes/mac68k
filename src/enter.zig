const Terminal = @import("terminal.zig").Terminal;

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

  while (true) {}
}
