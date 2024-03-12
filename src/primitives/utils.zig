const std = @import("std");
fn trimAndUpcase(str: []u8) []const u8 {
    const trimmed = @constCast(std.mem.trim(u8, str, &std.ascii.whitespace));
    for (trimmed) |*c| c.* = std.ascii.toUpper(c.*);
    return trimmed;
}
