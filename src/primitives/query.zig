const std = @import("std");
const manager = @import("./manager.zig");

pub const Query = struct {
    nanager: manager.ExabaseManager,
    allocator: std.mem.Allocator,
    pub fn findOne(
        self: *Query,
    ) !void {
        try self.nanager.read(self.allocator);
    }
    pub fn findMany(
        self: *Query,
    ) !void {
        try self.nanager.readAll(self.allocator);
    }
    pub fn search(
        self: *Query,
    ) !void {
        try self.nanager.readAll(self.allocator);
    }
    pub fn insert(
        self: *Query,
    ) !void {
        try self.nanager.readAll(self.allocator);
    }
    pub fn update(
        self: *Query,
    ) !void {
        try self.nanager.readAll(self.allocator);
    }
    pub fn remove(
        self: *Query,
    ) !void {
        try self.nanager.readAll(self.allocator);
    }
};
