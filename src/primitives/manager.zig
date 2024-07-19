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
    pub fn write(self: *ExabaseManager, content: []const u8) !void {
        fs.writeFIle(self.name, content);
    }
    pub fn read(self: *ExabaseManager, allocator: std.mem.Allocator) !void {
        fs.readFIle(allocator, self.name);
    }
    pub fn readAll(self: *ExabaseManager, allocator: std.mem.Allocator) !void {
        fs.readFIle(allocator, self.name);
    }
};
