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
  while (true) {}
}
