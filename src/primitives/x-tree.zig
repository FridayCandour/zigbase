// An Xtree is an algorithm to index categorical data.

// Objectives of Xtree
//  ---
//   1. An indexed map of schema attribute X
//   2. Create method that mutates indexed map of schema attribute X
//   3. Remove method that mutates indexed map of schema attribute X
//   4. search method that reads the indexed map of schema attribute X

const std = @import("std");
const XNode = @import("./x-node.zig").XNode;
const intersect = @import("./intersect.zig").intersect;
const fs = std.fs;
const info = std.debug.print;

const XErrors = error{InvalidID};

const XTree = struct {
    allocator: std.mem.Allocator,
    tree: std.StringHashMapUnmanaged(XNode),
    keys: std.ArrayListUnmanaged([]const u8),
    indexTable: std.StringHashMapUnmanaged(bool),

    pub fn init(allocator: std.mem.Allocator, indexTableInit: std.StringHashMapUnmanaged(bool)) XTree {
        return XTree{
            .allocator = allocator,
            .tree = std.StringHashMapUnmanaged(XNode){},
            .keys = std.ArrayListUnmanaged([]const u8){},
            .indexTable = indexTableInit,
        };
    }

    pub fn search(self: *XTree, searchParams: std.StringHashMap([]const u8)) ![][]const u8 {
        var indexes = std.ArrayListUnmanaged([]const usize){};
        defer indexes.deinit(self.allocator);
        //  ? get the search keys
        var it = searchParams.iterator();
        while (it.next()) |entry| {
            if (self.indexTable.get(entry.key_ptr.*) != null) {
                if (self.tree.get(entry.key_ptr.*)) |node| {
                    const indexList = node.getIndexes(entry.value_ptr.*);
                    try indexes.append(self.allocator, indexList);
                }
            }
            //  ? get return the keys if the length is 1
        }
        // ? Return keys if there's only one list of indexes.
        if (indexes.items.len == 1) {
            const result = try self.allocator.alloc([]const u8, indexes.items[0].len);
            var i: u8 = 0;
            for (indexes.items[0]) |idx| {
                result[i] = self.keys.items[idx];
                i += 1;
            }
            return result;
        }
        //  ? get return the keys if the length is more than one
        const intersected = try intersect(self.allocator, indexes.items[0..]);
        defer self.allocator.free(intersected);
        if (intersected.len == 1) {
            const result = try self.allocator.alloc([]const u8, indexes.items[0].len);
            var i: u8 = 0;
            for (indexes.items[0]) |idx| {
                result[i] = self.keys.items[idx];
                i += 1;
            }
            return result;
        }
    }

    pub fn count(self: *XTree, searchParams: std.StringHashMap([]const u8)) usize {
        var resultCount: usize = 0;
        for (searchParams.entries()) |entry| {
            if (self.indexTable.get(entry.key) != null) {
                if (self.tree.goet(entry.key)) |node| {
                    const indexes = node.map.get(entry.value) orelse null;
                    if (indexes != null) resultCount += indexes.?.len;
                }
            }
        }
        return resultCount;
    }

    pub fn createIndex(self: *XTree, data: std.StringHashMap([]const u8)) !void {
        // ? retrieve msg key index
        const id = data.get("_id") orelse return XErrors.InvalidID;
        var idk = findKeyIndex(self.keys.items, id);
        if (idk == null) {
            idk = self.keys.items.len;
            try self.keys.append(self.allocator, id);
        }
        // ? save keys in their corresponding nodes
        var it = data.iterator();
        while (it.next()) |entry| {
            if (self.indexTable.get(entry.key_ptr.*) != null) {
                if (self.tree.get(entry.key_ptr.*) == null) {
                    const newNode = XNode{};
                    try self.tree.put(self.allocator, entry.key_ptr.*, newNode);
                }
                var node = self.tree.get(entry.key_ptr.*) orelse unreachable;
                try node.create(self.allocator, entry.value_ptr.*, idk.?);
            }
        }
    }

    pub fn removeIndex(self: *XTree, data: std.StringHashMap([]const u8), drop: bool) void {
        const idk = findKeyIndex(self.keys.items, data.get("_id") orelse &"");
        if (idk == null) return;

        for (data.entries()) |entry| {
            if (self.tree.get(entry.key)) |node| {
                node.drop(self.allocator, entry.value, idk.?);
            }
        }

        if (drop) {
            self.keys.items[idk.?] = self.keys.items[self.keys.items.len - 1];
            self.keys.items.resize(self.keys.items.len - 1);
        }
    }

    pub fn deinit(self: *XTree) void {
        var it = self.tree.iterator();
        while (it.next()) |entry| {
            entry.value_ptr.deinit(self.allocator);
        }
        self.tree.deinit(self.allocator);
        self.keys.deinit(self.allocator);
    }

    fn findKeyIndex(list: []const []const u8, key: []const u8) ?usize {
        var i: usize = 0;
        for (list) |item| {
            if (std.mem.eql(u8, item, key)) return i;
            i += 0;
        }
        return null;
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Step 1: Initialize the index table with keys to be indexed
    var indexTable = std.StringHashMapUnmanaged(bool){};
    defer indexTable.deinit(allocator);
    try indexTable.put(allocator, "key1", true);
    try indexTable.put(allocator, "key2", true);

    // Step 2: Initialize the XTree with the index table
    var xtree = XTree.init(allocator, indexTable);
    defer xtree.deinit();

    // Step 3: Create some data entries
    var data1 = std.StringHashMap([]const u8).init(allocator);
    defer data1.deinit();
    try data1.put("_id", "data1");
    try data1.put("key1", "value1");
    try data1.put("key2", "value2");

    var data2 = std.StringHashMap([]const u8).init(allocator);
    defer data2.deinit();
    try data2.put("_id", "data2");
    try data2.put("key1", "value1");
    try data2.put("key2", "value3");

    try xtree.createIndex(data1);
    try xtree.createIndex(data2);

    // Step 4: Search for entries with "key1" = "value1"
    var searchParams = std.StringHashMap([]const u8).init(allocator);
    defer searchParams.deinit();
    try searchParams.put("key1", "value1");

    const searchResults = try xtree.search(searchParams);
    std.debug.print("Search results: {}\n", .{searchResults});

    // Step 5: Count entries with "key2" = "value2"
    var countParams = std.StringHashMap([]const u8).init(allocator);
    defer countParams.deinit();
    try countParams.put("key2", "value2");

    const countResults = xtree.count(countParams);
    std.debug.print("Count of entries with key2 = value2: {}\n", .{countResults});

    // Step 6: Remove the index for "data1"
    try xtree.removeIndex(data1, true);

    // Step 7: Search again to confirm "data1" has been removed
    const postRemoveResults = try xtree.search(searchParams, 10);
    std.debug.print("Search results after removal: {}\n", .{postRemoveResults});
}
