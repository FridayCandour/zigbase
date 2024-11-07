const std = @import("std");
const fs = std.fs;
const info = std.debug.print;

/// caller owns returned slice
pub fn intersect(allocator: std.mem.Allocator, arrays: [][]const u32) ![]const u32 {
    if (arrays.len == 0) return &[_]u32{};
    //   //? Put the smallest array in the beginning
    var i: u8 = 1;
    for (arrays) |v| {
        if (v.len < arrays[0].len) {
            const tmp = arrays[0];
            arrays[0] = v;
            arrays[i] = tmp;
        }
        info("{any} \n", .{v});
        i += 1;
    }
    //   //? if the smallest array is empty, return an empty array
    if (arrays[0].len == 0) return &[_]u32{};
    //   //? Create a map associating each element to its current count
    var Map: std.AutoHashMapUnmanaged(u32, u8) = .empty;
    defer Map.deinit(allocator);
    for (arrays[0]) |value| {
        Map.put(allocator, value, 1) catch unreachable;
    }
    var i_2: u8 = 0;
    for (arrays) |value| {
        if (i_2 == 0) {
            i_2 = 1;
            continue;
        }
        var found: u8 = 0;
        for (value) |e| {
            const count: u8 = Map.get(e) orelse 0;
            if (count == i_2) {
                try Map.put(allocator, e, count + 1);
                found += 1;
            }
        }
        //     //? Stop early if an array has no element in common with the smallest
        if (found == 0) return &[_]u32{};
        i_2 += 1;
    }
    //   //? Output only the elements that have been seen as many times as there are arrays
    var intersected = std.ArrayListUnmanaged(u32){};
    for (arrays[0]) |e| {
        const count: u8 = Map.get(e) orelse 0;
        if (count == arrays.len) {
            try intersected.append(allocator, count);
        }
    }
    return intersected.toOwnedSlice(allocator);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();
    var array = std.ArrayListUnmanaged([]const u32){};
    defer array.deinit(allocator);
    try array.append(allocator, &[_]u32{ 1, 2, 3 });
    try array.append(allocator, &[_]u32{ 2, 3, 4 });
    const intersected = try intersect(allocator, array.items[0..]);
    defer allocator.free(intersected);
    info("Intersection: {any}\n", .{intersected});
}
