//! Utility functions
pub fn memcpy(dest: [*]u8, src: [*]const u8, byte_count: usize) void {
    var cur: usize = 0;
    while (cur < byte_count) {
        dest[cur] = src[cur];
        cur += 1;
    }
}
