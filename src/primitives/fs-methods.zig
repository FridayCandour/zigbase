const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

// pub fn readFIle(name: []const u8) std.fs.File.OpenError!std.fs.File {
//     if (std.fs.cwd().openFile(name, .{})) |file| {
//         // file opened successfully
//         var buffer: [100]u8 = undefined;
//         try file.seekTo(0);
//         const bytes_read = try file.readAll(&buffer);
//         return bytes_read;
//     } else |err| {
//         // info("{!}", err);
//         return err;
//         // it failed, err explains why
//     }
// }

pub fn readFIle(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    return file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
}
