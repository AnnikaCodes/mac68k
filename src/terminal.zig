//! Terminal stuff

const video = @import("video.zig");
const memcpy = @import("utils.zig").memcpy;

const POWERS_OF_SIXTEEN: [8]u32 = .{
    1,
    16,
    256,
    4096,
    65536,
    1048576,
    16777216,
    268435456,
};

pub const Terminal = struct {
    foregroundColor: video.Color = .Black,
    cursorX: u16 = 0,
    cursorY: u16 = 0,

    pub fn setForegroundColor(self: *Terminal, color: video.Color) void {
        self.foregroundColor = color;
    }

    pub fn clearScreen(self: *const Terminal) void {
        const fillColor: video.Color = switch (self.foregroundColor) {
            .White => .Black,
            .Black => .White,
        };

        video.fastFillScreen(fillColor);
    }

    pub fn printChar(self: *Terminal, char: u8) void {
        if (char == '\n') {
            self.cursorX = video.SCREEN_WIDTH_CHARACTERS - 1;
        } else {
            video.drawCharacter(self.cursorX, self.cursorY, char, self.foregroundColor);
        }

        self.incrementScroll();
    }

    // Zig/GCC bug: this fails at
    pub fn printString(self: *Terminal, comptime string: []const u8) void {
        inline for (string) |char| {
            self.printChar(char);
        }
    }

    pub fn printHexNumber(self: *Terminal, number: u32) void {
        var buffer: [8]u8 = .{0, 0, 0, 0, 0, 0, 0, 0};

        var index: u8 = 0;
        var n: u32 = number;

        while (n != 0) {
            const digit: u8 = @intCast(u8, n % 16);
            if (digit < 0xA) {
                buffer[index] = '0' + digit;
            } else {
                buffer[index] = 'A' + digit - 0xA;
            }

            n /= 16;
            index += 1;
        }

        while (index != 0) {
            index -= 1;
            self.printChar(buffer[index]);
        }
    }

    fn incrementScroll(self: *Terminal) void {
        self.cursorX += 1;
        if (self.cursorX >= video.SCREEN_WIDTH_CHARACTERS) {
            self.cursorX = 0;

            self.cursorY += 1;
            if (self.cursorY >= video.SCREEN_HEIGHT_CHARACTERS) {
                // Scroll up: keep the cursor in the same place, but move all text onscreen up.
                // We can achieve this with memcpy
                const fb_start_ptr = @intToPtr([*]u8, video.POINTER_TO_FB_START_ADDRESS.*);
                const fb_plus_one_line_of_text_ptr = @intToPtr([*]u8, video.POINTER_TO_FB_START_ADDRESS.* + (video.SCREEN_WIDTH_PIXELS * 8));

                memcpy(fb_start_ptr, fb_plus_one_line_of_text_ptr, video.SCREEN_WIDTH_CHARACTERS * video.SCREEN_HEIGHT_CHARACTERS);
            }
        }
    }
};



