const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/fs-methods.zig");

pub fn main() !void {
    const mem = try std.heap.page_allocator.alloc(u8, 100 * 1024 * 1024);
    defer std.heap.page_allocator.free(mem);
    var fba = std.heap.FixedBufferAllocator.init(mem);
    const allocator = fba.allocator();
    const a = try fs.readFIle(allocator, "README.md");
    info("'{s}'", .{a});
}
