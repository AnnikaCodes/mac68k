//! Terminal stuff

const video = @import("video.zig");
const memcpy = @import("utils.zig").memcpy;

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



