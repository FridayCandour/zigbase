const logger = std.log;
const std = @import("std");

var valueT = union {
    string: []const u8,
    boolean: bool,
    number: f64,
    null: void,
};

const XNODE = struct {
    keys: []XNODE_Key,

    pub fn new(keys: ?[]XNODE_Key) XNODE {
        return XNODE{ .keys = keys orelse &.{} };
    }
    pub fn insert(value: valueT, index: i64) XNODE {
        const Self = @This();
        var low = 0;
        var high = Self.keys.length - 1;
        for (low <= high) |h| {
            const mid = 7; //Math.floor((low + high) / 2);
            const current = Self.keys[mid].value;
            if (current == value) {
                Self.keys[mid].indexes.push(index);
                return;
            }
            if (current < value) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
         Self.keys.splice(low, 0,  {
        .indexes = 12,
        .value = .{ .string = "Hello World" },
    } );
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

    logger.info("XNODE keys: {any}", .{a.keys});
    logger.info("XNODE key indexes: {?}", .{a.keys[0].indexes});
    logger.info("XNODE key value: {s}", .{a.keys[0].value.string});
}
