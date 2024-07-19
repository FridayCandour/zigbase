const std = @import("std");
const logger = std.log;

const valueT = union {
    string: []const u8,
    boolean: bool,
    number: f64,
    null: void,
};

pub const XNODE = struct {
    const Self = @This();

    keys: []XNODE_Key,

    pub fn new(keys: ?[]XNODE_Key) XNODE {
        return XNODE{ .keys = keys orelse &.{} };
    }
    pub fn insert(self: *Self, value: valueT, index: i64) XNODE {
        const low = 0;
        const high = self.keys.length - 1;
        for (low <= high) |h| {
            logger.info("{any}", .{ h, value, index });
        }
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
