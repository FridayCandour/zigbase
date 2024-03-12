const info = std.debug.print;
const std = @import("std");
const os = std.os;
const fs = @import("./primitives/fs-methods.zig");

const ExabaseOptions = struct {
    /// Exabase DBMS
    /// ---
    /// RCT Memory cache percentage
    EXABASE_MEMORY_PERCENT: f32,

    /// Exabase DBMS
    /// ---
    /// name
    name: []const u8,

    /// a url that points to another node this node can hydrate from if out of date
    bearer: []const u8,

    /// type of ring
    mode: []const u8,

    /// Exabase DBMS
    /// ---
    /// Data schemas
    schemas: []Schema,

    /// Exabase DBMS
    /// ---
    /// log each query?
    logging: bool,

    /// Exabase DBMS
    /// ---
    /// Exabase signing keys
    EXABASE_KEYS: struct { privateKey: []const u8, publicKey: []const u8 },
};

const Schema = struct {};
