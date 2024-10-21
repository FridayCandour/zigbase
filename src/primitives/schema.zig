const fs = @import("./fs-methods.zig");
const configs = @import("./configs.zig");
const Query = @import("./query.zig").Query;
const utils = @import("./utils.zig");
const ExabaseManager = @import("./manager.zig").ExabaseManager;
const std = @import("std");

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
    /// Exabase
    /// ---
    pub fn newQuery(self: *const Schema, allocator: std.mem.Allocator) Query {
        return Query{ .manager = self.manager, .allocator = allocator };
    }
};
