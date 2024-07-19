const fs = @import("./fs-methods.zig");
const configs = @import("./configs.zig");
const query = @import("./query.zig");
const utils = @import("./utils.zig");
const manager = @import("./manager.zig");
const std = @import("std");

pub const Schema = struct {
    tableName: []const u8,
    columns: []const configs.Column,
    manager: manager.ExabaseManager,
    pub fn new(options: configs.SchemaOptions) Schema {
        const newSchema = Schema{
            .tableName = utils.trimAndUpcase(options.tableName),
            .columns = options.columns,
            .manager = manager.ExabaseManager{ .name = options.tableName },
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
    pub fn newQuery(self: *Schema, allocator: std.mem.Allocator) query.Query {
        return query.Query{ .nanager = self.manager, .allocator = allocator };
    }
};
