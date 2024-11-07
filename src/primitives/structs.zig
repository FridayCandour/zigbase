const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./utils.zig");
const utils = @import("./utils.zig");
const configs = @import("./types.zig");

pub const ExabaseManager = struct {
    // constructor
    pub fn new(options: configs.ManagerOptionType) ExabaseManager {
        const newExabaseManager = ExabaseManager{ .name = options.name };
        return newExabaseManager;
    }
    name: []const u8,
    pub fn write(self: *const ExabaseManager, content: []const u8) !void {
        try fs.writeFile(self.name, content);
    }
    pub fn read(self: *ExabaseManager, allocator: std.mem.Allocator) !void {
        fs.readFile(allocator, self.name);
    }
    pub fn readAll(self: *const ExabaseManager, allocator: std.mem.Allocator) ![]const u8 {
        const data = try fs.readFile(allocator, self.name);
        return data;
    }
};

pub const Schema = struct {
    tableName: []const u8,
    columns: []const configs.Column,
    manager: ExabaseManager,
    pub fn new(options: configs.SchemaOptions) !Schema {
        const newSchema = Schema{
            .tableName = try utils.trimAndUpcase(options.allocator, options.tableName),
            .columns = options.columns,
            .manager = ExabaseManager{ .name = options.tableName },
        };
        // ? parse definitions
        if (newSchema.tableName.len != 0) {
            //? setting up _id type on initialisation
            // newSchema.columns = newSchema.columns ++ &[_]configs.Column{.{ .name = "id", .type = .String, .nullable = false, .unique = true }};
            //? setting up secondary types on initialisation
            //? Date
            // inline for (@typeInfo(@TypeOf(newSchema.columns)).Struct.fields) |field| {
            //     const key = field.name;
            //     const value = @field(newSchema.columns, key);
            // }
            // ? parse definitions end
        }
        return newSchema;
    }
};
