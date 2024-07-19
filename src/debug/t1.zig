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
    column_type: ColumnType,
    nullable: bool,
    unique: bool,
};

pub fn main() !void {
    // Example usage

    // Define some columns
    const column1 = Column{
        .name = "id",
        .column_type = ColumnType.Number,
        .nullable = false,
        .unique = true,
    };

    const column2 = Column{
        .name = "name",
        .column_type = ColumnType.String,
        .nullable = false,
        .unique = false,
    };

    const column3 = Column{
        .name = "created_at",
        .column_type = ColumnType.Date,
        .nullable = false,
        .unique = false,
    };

    // Print column definitions
    std.debug.print("Column1: {s}, Type: {}, Nullable: {}, Unique: {}\n", .{ column1.name, column1.column_type, column1.nullable, column1.unique });
    std.debug.print("Column2: {s}, Type: {}, Nullable: {}, Unique: {}\n", .{ column2.name, column2.column_type, column2.nullable, column2.unique });
    std.debug.print("Column3: {s}, Type: {}, Nullable: {}, Unique: {}\n", .{ column3.name, column3.column_type, column3.nullable, column3.unique });
}
