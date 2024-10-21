const std = @import("std");

pub fn trimAndUpcase(allocator: std.mem.Allocator, str: []const u8) error{OutOfMemory}![]const u8 {
    const trimmed = try allocator.dupe(u8, std.mem.trim(u8, str, &std.ascii.whitespace));
    for (trimmed) |*c| {
        c.* = std.ascii.toUpper(c.*);
    }
    return trimmed;
}
