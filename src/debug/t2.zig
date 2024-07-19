const std = @import("std");

pub const ColumnType = enum {
    Boolean,
    Number,
    Date,
    JSON,
    Schema,
    String,
};

pub const Column = struct {
    name: []const u8,
    type: ColumnType,
    nullable: bool,
    unique: bool,
};

pub const SchemaOptions = struct {
    tableName: []const u8,
    columns: []const Column,
};

pub const Schema = struct {
    tableName: []const u8,
    columns: []const Column,
    pub fn new(options: SchemaOptions) Schema {
        return Schema{
            .tableName = options.tableName,
            .columns = options.columns,
        };
    }
};

pub fn main() !void {
    const options = SchemaOptions{
        .tableName = "example_table",
        .columns = &[_]Column{
            Column{
                .name = "id",
                .type = ColumnType.Number,
                .nullable = false,
                .unique = true,
            },
            Column{
                .name = "name",
                .type = ColumnType.String,
                .nullable = false,
                .unique = false,
            },
        },
    };

    const schema = Schema.new(options);

    std.debug.print("Schema: {s}\n", .{schema.tableName});
    for (schema.columns) |column| {
        std.debug.print("Column: {s}, Type: {}, Nullable: {}, Unique: {}\n", .{ column.name, column.type, column.nullable, column.unique });
    }
}
