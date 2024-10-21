const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

pub fn readFIle(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    const file = try getFIle(path);
    info("{s}", .{path});
    return file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
}
pub fn writeFIle(path: []const u8, content: []const u8) !void {
    const file = try getFIle(path);
    try file.writer().writeAll(content);
    file.close();
}
pub fn getFIle(path: []const u8) !std.fs.File {
    var file = std.fs.cwd().openFile(path, .{});
    if (file) |_| {} else |err| switch (err) {
        std.fs.File.OpenError.FileNotFound => {
            _ = try std.fs.cwd().createFile(path, .{});
            file = std.fs.cwd().openFile(path, .{});
        },
        else => {
            unreachable;
        },
    }
    return file;
}
