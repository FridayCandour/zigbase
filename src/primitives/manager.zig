const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./fs-methods.zig");
const configs = @import("./configs.zig");

pub const ExabaseManager = struct {
    // constructor
    pub fn new(options: configs.ManagerOptionType) ExabaseManager {
        const newExabaseManager = ExabaseManager{ .name = options.name };
        return newExabaseManager;
    }
    name: []const u8,
    pub fn write(self: *const ExabaseManager, content: []const u8) !void {
        try fs.writeFIle(self.name, content);
    }
    pub fn read(self: *ExabaseManager, allocator: std.mem.Allocator) !void {
        fs.readFIle(allocator, self.name);
    }
    pub fn readAll(self: *const ExabaseManager, allocator: std.mem.Allocator) ![]const u8 {
        const data = try fs.readFIle(allocator, self.name);
        return data;
    }
};
