const std = @import("std");
const root = @import("root.zig");
pub fn main() !void {
    root.scanner.readFile("example.txt") catch |err| {
        std.debug.print("Failed to read file: {}\n", .{err});
        return err;
    };
}
