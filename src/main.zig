const logger = std.log;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/fs-methods.zig");

pub fn main() void {
    var a = fs.readFIle();
    _ = &a;
    logger.info("there's sokmething i need to tell you and it is = {s}", .{a});
}
