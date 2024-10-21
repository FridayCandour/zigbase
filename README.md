## zigbase is a basic prototype of [Exabase](https://github.com/Uiedbook/Exabase) in zig.

Progress? some more of ---

```c
pub fn main() !void {

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
```

Wanna help?, please dm [me](https://t.me/Procal)
