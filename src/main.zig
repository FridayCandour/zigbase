const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/utils.zig");
const Schema = @import("./primitives/structs.zig").Schema;
const types = @import("./primitives/types.zig");

pub fn main() !void {
    // ? not used yet
    const mem = try std.heap.page_allocator.alloc(u8, 1 * 1024 * 1024);
    defer std.heap.page_allocator.free(mem);
    var fba = std.heap.FixedBufferAllocator.init(mem);
    const allocator = fba.allocator();
    // ? define schema an Exabase Schema
    const options = types.SchemaOptions{
        .tableName = "vehicle",
        .columns = &[_]types.Column{
            types.Column{
                .name = "id",
                .type = .Number,
                .required = false,
                .unique = true,
            },
            types.Column{
                .name = "type",
                .type = .String,
            },
        },
        .allocator = allocator,
    };
    const schema = try Schema.new(options);
    _ = schema;
}
