const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable(.{
        .name = "zigbase",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = mode,
    });

    const msgpack = b.dependency("zig-msgpack", .{
        .target = target,
        .optimize = optimize,
    });

    b.default_step.dependOn(&exe.step);
    // add module
    exe.addModule("msgpack", msgpack.module("msgpack"));

    const run_cmd = exe.run();

    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
