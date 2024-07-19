const std = @import("std");

pub fn getTimestamp(_id: []const u8) !u64 {
    const slice = _id[0..8];
    // const hex_string = std.mem.bytesToSliceAligned(0, slice);
    const hex_string = std.mem.bytesAsSlice(u8, slice);
    const result = try std.fmt.parseInt(u64, hex_string, 16);
    return result / 1000;
}

// pub fn main() !void {
//     const stdout = std.io.getStdOut().writer();
//     const id = "667af953e1c6770005166fef";
//     const time = try getTimestamp(id);
//     try stdout.print("Timestamp: {}\n", .{time});
// }
