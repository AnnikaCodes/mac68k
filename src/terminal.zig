//! Terminal stuff

const video = @import("video.zig");

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

            if (self.cursorX >= video.SCREEN_HEIGHT_CHARACTERS) {
                // TODO: scroll the screen contents up
            } else {
                self.cursorY += 1;
            }
        }
    }
};



