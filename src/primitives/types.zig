const std = @import("std");

const schema = @import("./structs.zig");

pub const ExabaseOptions = struct {
    /// Exabase DBMS
    /// ---
    /// name
    name: []const u8,

    /// Exabase DBMS
    /// ---
    /// Data schemas
    schemas: []const schema,

    /// Exabase DBMS
    /// ---
    /// log each query?
    logging: bool,
};

pub const ColumnType = enum {
    Boolean,
    Number,
    Date,
    JSON,
    Schema,
    String,
};

pub const Column = struct {
    name: []const u8,
    type: ColumnType,
    required: ?bool = false,
    unique: ?bool = false,
};
///Interface for schema metadata mappings
pub const SchemaOptions = struct {
    ///Table name.
    tableName: []const u8,
    ///Indicates properties and  relationship definitions for the schema
    columns: []const Column,
    ///Allocator
    allocator: std.mem.Allocator,
};
pub const ManagerOptionType = struct {
    name: []const u8,
};
pub const write_flag = enum {
    insert,
    update,
    delete,
};
