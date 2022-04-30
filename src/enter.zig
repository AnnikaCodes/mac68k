const Terminal = @import("terminal.zig").Terminal;

fn wasteTime(amount: u32) void {
    var i: u32 = 0;
    while (i < amount * 10000) {
        i += 1;
    }
}
export fn zigEntry() void {
  // Welcome to Zig!
  var term = Terminal {};
  term.setForegroundColor(.Black);
  term.clearScreen();

  // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  term.printString("ABCDEFGHIJKLMNÑOPQRSTUVWXYZÅÄÖabcdefghijklmnñopqrstuvwxyzåäö1234567890,;]?.!\n\n");
  term.printString("SPHINX OF BLACK QUARTZ, JUDGE MY VOW.\n");
  var n: u32 = 0;
  while (true) {
    term.printString(" \n");
    wasteTime(10);
    n += 1;
    if (n > 4) {
      term.printString("Z\n");
    }
  }
}
