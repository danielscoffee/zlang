const std = @import("std");
const file = std.fs;

/// This function is used to read file and by now its just return a print by reading a buffer
// TODO: MAKE IT USABLE TO TOKENIZER
// TODO: MAKE OUTPUT PATH AVAIBLE
// WARN: LITERRALY ANYTHING IS READY LMAO
pub fn readFile(path: []const u8) !void {
    // Verify file extension
    const file_extension = ".zl";
    if (!std.mem.endsWith(u8, path, file_extension)) {
        std.log.err("Wrong file extension on {s}", .{path});
        return error.InvalidFileExtension;
    }

    // This one start read :)
    const input_file = try file.cwd().openFile(path, .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    const reader = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (reader.readUntilDelimiterOrEof(&buf, '\n') catch |err| {
        std.log.err("Read failed: {}", .{err});
        return err;
    }) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
