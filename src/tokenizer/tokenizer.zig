const std = @import("std");

pub const Token = struct {
    type: TokenType,
    lexeme: []const u8,
};

pub const TokenType = enum {
    INTEGER,
    FLOAT,
    IDENTIFIER,
    LITERAL_STRING,
    COMMA,
    SEMICOLON,
    NEWLINE,
    // Add other token types as needed
};

///! Lexer
/// TODO: FIX THE LEXEME OUTPUT(ACTUAL OUTPUT IS A BUG)
/// WARN: LEXER WITH BUGS!
pub fn Lexer(reader: anytype) ![]Token {
    var tokens = std.ArrayList(Token).init(std.heap.page_allocator);
    defer tokens.deinit();

    var buf: [1024]u8 = undefined;

    while (true) {
        const maybe_line = try reader.readUntilDelimiterOrEof(&buf, '\n');
        if (maybe_line) |line| {
            var iter = std.mem.split(u8, line, " ");
            while (iter.next()) |lexeme| {
                if (lexeme.len == 0) continue;
                // token_type is used to verify the type by conditions
                const token_type = if (std.mem.eql(u8, lexeme, ",")) TokenType.COMMA else if (std.mem.eql(u8, lexeme, ";")) TokenType.SEMICOLON else if (std.ascii.isDigit(lexeme[0])) TokenType.INTEGER else TokenType.IDENTIFIER;
                try tokens.append(.{ .type = token_type, .lexeme = lexeme });
            }
            try tokens.append(.{ .type = .NEWLINE, .lexeme = "\n" });
        } else {
            break;
        }
    }

    return tokens.toOwnedSlice();
}
