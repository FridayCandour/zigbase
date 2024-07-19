const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

pub fn readFIle(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    return file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
}
pub fn writeFIle(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().openFile(path, .{});
    try file.writer().writeAll(content);
    file.close();
}
