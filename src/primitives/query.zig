const std = @import("std");
const ExabaseManager = @import("./manager.zig").ExabaseManager;

pub const Query = struct {
    manager: ExabaseManager,
    allocator: std.mem.Allocator,
    pub fn findOne(
        self: *Query,
    ) !void {
        try self.manager.read(self.allocator);
    }
    pub fn findMany(
        self: *const Query,
    ) ![]const u8 {
        const data = try self.manager.readAll(self.allocator);
        return data;
    }
    pub fn search(
        self: *Query,
    ) !void {
        try self.manager.readAll(self.allocator);
    }
    pub fn insert(self: *const Query, data: []const u8) !void {
        try self.manager.write(data);
    }
    pub fn update(
        self: *Query,
    ) !void {
        try self.manager.readAll(self.allocator);
    }
    pub fn remove(
        self: *Query,
    ) !void {
        try self.manager.readAll(self.allocator);
    }
};
