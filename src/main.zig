const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/fs-methods.zig");
const schemaS = @import("./primitives/schema.zig");
const configs = @import("./primitives/configs.zig");

pub fn main() !void {
    // ? not used yet
    // const mem = try std.heap.page_allocator.alloc(u8, 100 * 1024 * 1024);
    // defer std.heap.page_allocator.free(mem);
    // var fba = std.heap.FixedBufferAllocator.init(mem);
    // const allocator = fba.allocator();

    // ? define schema an Exabase Schema
    const options = configs.SchemaOptions{
        .tableName = "example_table",
        .columns = &[_]configs.Column{
            configs.Column{
                .name = "id",
                .type = configs.ColumnType.Number,
                .required = false,
                .unique = true,
            },
            configs.Column{
                .name = "name",
                .type = configs.ColumnType.String,
            },
        },
    };

    const schema = schemaS.Schema.new(options);
    std.debug.print("Schema table name: {s}\n", .{schema.tableName});
    for (schema.columns) |column| {
        std.debug.print("Column: {s}, Type: {?}, Nullable: {?}, Unique: {?}\n", .{ column.name, column.type, column.required, column.unique });
    }
}
