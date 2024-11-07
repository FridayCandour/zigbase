const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

pub fn trimAndUpcase(allocator: std.mem.Allocator, str: []const u8) error{OutOfMemory}![]const u8 {
    const trimmed = try allocator.dupe(u8, std.mem.trim(u8, str, &std.ascii.whitespace));
    for (trimmed) |*c| {
        c.* = std.ascii.toUpper(c.*);
    }
    return trimmed;
}

pub fn getTimestamp(_id: []const u8) !u64 {
    const slice = _id[0..8];
    // const hex_string = std.mem.bytesToSliceAligned(0, slice);
    const hex_string = std.mem.bytesAsSlice(u8, slice);
    const result = try std.fmt.parseInt(u64, hex_string, 16);
    return result / 1000;
}

pub fn readFile(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    const file = try getFile(path);
    return file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
}
pub fn writeFile(path: []const u8, content: []const u8) !void {
    const file = try getFile(path);
    try file.writer().writeAll(content);
    file.close();
}
pub fn getFile(path: []const u8) !std.fs.File {
    var file = std.fs.cwd().openFile(path, std.fs.File.OpenFlags{ .mode = .read_write });
    if (file) |_| {} else |err| switch (err) {
        std.fs.File.OpenError.FileNotFound => {
            _ = try std.fs.cwd().createFile(path, .{});
            file = std.fs.cwd().openFile(path, std.fs.File.OpenFlags{ .mode = .read_write });
        },
        else => {
            unreachable;
        },
    }
    return file;
}

// pub fn main() !void {
//     const stdout = std.io.getStdOut().writer();
// // timestamp
//     const id = "667af953e1c6770005166fef";
//     const time = try getTimestamp(id);
//     try stdout.print("Timestamp: {}\n", .{time});
// // ?
// }
