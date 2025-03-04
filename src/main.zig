const std = @import("std");
const root = @import("root.zig");
const cli = @import("cli/cli.zig");
pub fn main() !void {
    try cli.initCli();
    //root.scanner.readFile("example.txt") catch |err| {
    //    std.debug.print("Failed to read file: {}\n", .{err});
    //    return err;
    //};
}
