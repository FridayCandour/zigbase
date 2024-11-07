// An Xtree is an algorithm to index categorical data.

// Objectives of Xnodes
//  ---
//   1. An indexed map of schema attribute X
//   2. Create method that mutates indexed map of schema attribute X
//   3. Remove method that mutates indexed map of schema attribute X
//   4. Check method that reads the indexed map of schema attribute X

const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

// thomas
pub const XNode = struct {
    const Indexes = std.ArrayListUnmanaged(u32);
    const Map = std.StringHashMapUnmanaged(Indexes);
    map: Map = Map{},

    pub fn create(self: *XNode, allocator: std.mem.Allocator, key: []const u8, value: u32) !void {
        // Get or allocate a pair of pointers to the internals of the map (key + value)
        const gop = try self.map.getOrPut(allocator, key);
        // If we allocated a new slot and any further allocation fails, remember to remove the slot again
        errdefer if (!gop.found_existing) {
            std.debug.assert(self.map.remove(key));
        };
        // If we allocated a new hashmap slot...
        if (!gop.found_existing) {
            // Duplicate (allocate) and insert the newly allocated key
            gop.key_ptr.* = try allocator.dupe(u8, key);
            // Set the value memory to an empty list
            gop.value_ptr.* = Indexes{};
        }
        // If appending the value fails, free the key we allocated (duped) ^
        errdefer if (!gop.found_existing) {
            allocator.free(gop.key_ptr.*);
        };
        // Append the value to the empty list
        try gop.value_ptr.append(allocator, value);
    }

    pub fn drop(self: *XNode, allocator: std.mem.Allocator, key: []const u8, value: u32) void {
        const entry = self.map.getEntry(key) orelse return;
        const idx = std.mem.indexOfScalar(u32, entry.value_ptr.items, value) orelse return;
        _ = entry.value_ptr.swapRemove(idx);
        if (entry.value_ptr.items.len == 0) {
            allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(allocator);
            self.map.removeByPtr(entry.key_ptr);
        }
    }

    pub fn deinit(self: *XNode, allocator: std.mem.Allocator) void {
        var it = self.map.iterator();
        while (it.next()) |entry| {
            allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(allocator);
        }
        self.map.deinit(allocator);
    }

    pub fn getIndexes(self: *XNode, val: []const u8) []const u32 {
        return if (self.map.get(val)) |list| list.items else &.{};
    }
};

// pub fn main() !void {
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     defer std.debug.assert(gpa.deinit() == .ok);
//     const allocator = gpa.allocator();
//     var node = XNode{};
//     try node.create(allocator, "example_key", 42);
//     try node.create(allocator, "example_key", 43);
//     const key = "example_key";
//     const a = node.getIndexes(key);
//     info("{d} {d} \n", .{ a[0], a[1] });
//     node.drop(allocator, "example_key", 42);
//     node.drop(allocator, "example_key", 43);
//     node.deinit(allocator);
// }
// friday

// const XNode = struct {
//     map: std.StringHashMap([]u32),

//     pub fn init(allocator: *std.mem.Allocator) XNode {
//         return XNode{
//             .map = std.StringHashMap([]u32).init(allocator.*),
//         };
//     }

//     pub fn create(self: *XNode, allocator: *std.mem.Allocator, key: []const u8, value: u32) !void {
//         const existing = self.map.get(key) orelse &[_]u32{};
//         var newList = try allocator.alloc(u32, existing.len + 1);
//         std.mem.copyForwards(u32, newList[0..existing.len], existing);
//         newList[existing.len] = value;
//         try self.map.put(key, newList);
//     }

//     pub fn drop(self: *XNode, allocator: *std.mem.Allocator, key: []const u8, value: u32) void {
//         const list = self.map.get(key);
//         if (list) |existing| {
//             const idx = find(existing, value);
//             if (idx != null) {
//                 const actual_idx = idx.?;
//                 var newList = allocator.alloc(u32, existing.len - 1) catch unreachable;
//                 std.mem.copyForwards(u32, newList, existing[0..actual_idx]);
//                 std.mem.copyForwards(u32, newList[actual_idx..], existing[actual_idx + 1 ..]);
//                 self.map.put(key, newList) catch {};
//                 _ = if (newList.len == 0) self.map.remove(key);
//             }
//         }
//     }

//     pub fn deinit(self: *XNode) void {
//         self.map.deinit();
//     }

//     fn find(list: []const u32, value: u32) ?usize {
//         var idx: usize = 0;
//         for (list) |item| {
//             if (item == value) return idx;
//             idx += 1;
//         }
//         return null;
//     }
//     pub fn getIndexes(self: *XNode, val: []const u8) []u32 {
//         return self.map.get(val) orelse &[_]u32{};
//     }
// };

// pub fn main() !void {
//     var allocator = std.heap.page_allocator;
//     var node = XNode.init(&allocator);
//     try node.create(&allocator, "example_key", 42);
//     try node.create(&allocator, "example_key", 43);
//     const key = "example_key";
//     const a = node.getIndexes(key);
//     info("{d} {d} \n", .{ a[0], a[1] });
//     node.drop(&allocator, "example_key", 42);
//     node.drop(&allocator, "example_key", 43);
//     node.deinit();
// }
