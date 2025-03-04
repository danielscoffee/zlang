const std = @import("std");
const scan = @import("../tokenizer/scanner.zig");

pub fn initCli() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.next(); // skip binary name

    // var to CLI
    var verbose: bool = false;
    var help: bool = false;
    var output_path: ?[]const u8 = null;
    var input_path: ?[]const u8 = null;

    // CLI evaluation ;)
    while (args.next()) |arg| {
        if (command("-v", "--verbose", arg)) {
            verbose = true;
        }
        if (command("-h", "--help", arg)) {
            help = true;
        }
        if (command("-o", "--o", arg)) {
            const path = args.next();
            if (path == null) {
                std.log.err("Error: Output need a parameter", .{});
                return error.UnknowArgument;
            }
            output_path = path;
            continue;
        }
        if (input_path != null) {
            std.log.err("Error: You can't put many input files", .{});
            return error.TooManyInputs;
        }
        input_path = arg;
    }

    if (input_path == null) {
        std.log.err("Error: Needed input file to work", .{});
        std.debug.print("Run with --help for usage\n", .{});
        return error.MissingInput;
    }

    if (verbose) {
        std.debug.print("Processing file: {s}\n", .{input_path.?});
        if (output_path != null) {
            std.debug.print("Output will go to: {s}\n", .{output_path.?});
        }
    }

    if (help) {
        std.debug.print(
            \\Usage: myapp [options] <input.txt>
            \\Options:
            \\  -v, --verbose  Print extra info
            \\  -h, --help     Show this message
            \\  -o, --output   Output file path
            \\
        , .{});
        return;
    }

    try scan.readFile(input_path.?, output_path);
}

fn command(short: *const [2:0]u8, long: []const u8, arg: []const u8) bool {
    return std.mem.eql(u8, arg, short) or std.mem.eql(u8, arg, long);
}
