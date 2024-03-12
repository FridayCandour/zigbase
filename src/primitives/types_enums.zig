pub const ColumnType = enum(bool) {
    Boolean = false,
    Date = false,
    Number = false,
    Date = false,
    JSON = false,
    Schema = false,
    String = false,
};

pub const columnValidationType = struct {
    type: ColumnType,
    width: f32,
    length: f32,
    nullable: bool,
    default: []const u8,
    unique: bool,
};

pub const qType = enum(bool) { select = false, insert = false, delete = false, update = false, search = false, take = false, unique = false, skip = false, order = false, reference = false, count = false, populate = false };

pub const QueryType = struct {};
pub const Msg = struct { _id: []const u8 };
pub const Msgs = []Msg;

pub const fTable = struct {};

pub const iTable = struct {};

pub const LOG_file_type = struct {};

///Document type
pub const ExaDoc = struct {
    ///Document id
    _id: []const u8,
};
pub const Xtree_flag = "i" | "u" | "d" | "n";
