const logger = std.log;
const std = @import("std");

const valueT = union {
    string: []const u8,
    boolean: bool,
    number: f64,
    null: void,
};

pub const XNODE = struct {
    keys: []XNODE_Key,

    pub fn new(keys: ?[]XNODE_Key) XNODE {
        return XNODE{ .keys = keys orelse &.{} };
    }
    pub fn insert(value: valueT, index: i64) XNODE {
        const Self = @This();
        const low = 0;
        const high = Self.keys.length - 1;
        for (low <= high) |h| {
            logger.info("{any}", .{ h, value, index });
            // const mid = @floor((low + high) / 2);
            // const current = Self.keys[mid].value;
            // if (current == value) {
            //     Self.keys[mid].indexes.push(index);
            //     return;
            // }
            // if (current < value) {
            //     low = mid + 1;
            // } else {
            //     high = mid - 1;
            // }
        }
        //      Self.keys.splice(low, 0,  {
        //     .indexes = 12,
        //     .value = .{ .string = "Hello World" },
        // } );
    }
};

const XNODE_Key = struct {
    indexes: i64,
    value: union {
        string: []const u8,
        boolean: bool,
        number: f64,
        null: void,
    },
};

pub fn main() void {
    const b = XNODE_Key{
        .indexes = 12,
        .value = .{ .string = "Hello World" },
    };

    var c = [_]XNODE_Key{b};

    const a = XNODE.new(&c);
    a.insert(&.{ .string = "lol" }, 12);
    logger.info("XNODE keys: {any}", .{a.keys});
    logger.info("XNODE key indexes: {?}", .{a.keys[0].indexes});
    logger.info("XNODE key value: {s}", .{a.keys[0].value.string});
}
