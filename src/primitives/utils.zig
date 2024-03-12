const std = @import("std");
export fn trimAndUpcase(allocator: std.mem.Allocator, str: []const u8) ![]const u8 {
    const trimmed = std.mem.trim(u8, str, &std.ascii.whitespace);
    const uppercased = try allocator.dupe(u8, trimmed);
    for (uppercased) |*c| c.* = std.ascii.toUpper(c.*);
    return uppercased;
}
