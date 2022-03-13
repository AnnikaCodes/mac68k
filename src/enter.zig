fn system_error(_: u32) callconv(.C) void {
  asm volatile (
    // All the moves are to get to the arg :(
    // Binding causes a segfault in compilation
    "move (%sp)+,%d0;move (%sp)+,%d0;move (%sp)+,%d0;move (%sp)+,%d0;move (%sp)+,%d0;move (%sp)+,%d0;.short 0xA9C9"
  );
}

export fn zig_entry() callconv(.C) void {
  // Welcome to Zig!
  system_error(0xEDCB);
  while (true) {}
}
