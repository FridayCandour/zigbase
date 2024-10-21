const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/fs-methods.zig");
const Schema = @import("./primitives/schema.zig").Schema;
const configs = @import("./primitives/configs.zig");

pub fn main() !void {
    // ? not used yet
    const mem = try std.heap.page_allocator.alloc(u8, 1 * 1024 * 1024);
    defer std.heap.page_allocator.free(mem);
    var fba = std.heap.FixedBufferAllocator.init(mem);
    const allocator = fba.allocator();

    // ? define schema an Exabase Schema
    const options = configs.SchemaOptions{
        .tableName = "vehicle",
        .columns = &[_]configs.Column{
            configs.Column{
                .name = "id",
                .type = .Number,
                .required = false,
                .unique = true,
            },
            configs.Column{
                .name = "type",
                .type = .String,
            },
        },
        .allocator = allocator,
    };

    const schema = try Schema.new(options);
    const trx = schema.newQuery(allocator);
    const many = try trx.findMany();
    std.debug.print("many: {s}\n", .{many});
    // try trx.insert("friday will be great.");
    std.debug.print("Schema table name: {s}\n", .{schema.tableName});
    for (schema.columns) |column| {
        std.debug.print("Column: {s}, Type: {?}, Nullable: {?}, Unique: {?}\n", .{ column.name, column.type, column.required, column.unique });
    }
}
