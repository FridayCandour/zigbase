const schemaF = @import("./primitives/schema.zig");

pub const ExabaseOptions = struct {
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
    schemas: []SchemaF.schema,

    /// Exabase DBMS
    /// ---
    /// log each query?
    logging: bool,

    /// Exabase DBMS
    /// ---
    /// Exabase signing keys
    EXABASE_KEYS: struct { privateKey: []const u8, publicKey: []const u8 },
};





 
 ///Interface for schema metadata mappings 
pub const  SchemaOptions  = struct {
   ///Table name.
  tableName: []const u8,
   ///Exabase RCT
   ///---
 
   ///Enables Regularity Cache Tank for this table?.
 
   ///***
   ///synopsis
   ///***
   ///Exabase RCT is a log file level cache, which makes log files retrieve cheap
 
   ///this is integrated because Exabase is not does not cache in any form by default and Exabase only implement RCT cach only
  RCT: bool,

   ///Indicates properties and  relationship definitions for the schema
  columns: {
    [x in keyof Partial<Model>]: SchemaColumnOptions;
  };
   ///Exabase migrations
   ///---
   ///Indicates a migration function for transforming available items to the changes made in the columns
   ///this allows for start-up migration of existing items on Exabase db instance.
 
   ///And again the function is only called during start-up so the db instance need to be restarted.
 
   ///***
   ///synopsis
   ///***
   ///This function should return true if the item it receives is already valid as this is not handled automatically to avoid an extra abstraction layer over migrations
 
   ///the function should be removed when no longer needed to avoid Exabase start-up time.
  migrationFN?(data: Record<string, string>): Record<string, string> | true;
}

 ///Indicates the relationship

pub const SchemaRelation = Record<string, SchemaRelationOptions>;
 ///Indicates the relationship name

pub const SchemaRelationOptions = {
   ///Indicates with which schema this relation is connected to.
 
   ///the tableName of that schema
  target: []const u8,
   ///Type of relation. Can be one of the value of the RelationTypes class.
  RelationType: "MANY" | "ONE";
};

 ///Interface for schema column type mappings 
export interface SchemaColumnOptions {
   ///Column type. Must be one of the value from the ColumnTypes class.
  type: ColumnType;
   ///Column type's length. For example type = "string" and length = 100
  length?: number;
   ///For example, 4 specifies a number of four digits.
  width?: number;
   ///Indicates if column's value can be set to NULL.
  nullable?: bool,
   ///Exabase DBMS
   ///---
   ///Default value.
  default?: any;
   ///Indicates if column's value is unique
  unique?: bool,
   ///Indicates with which schema this relation is connected to.
 
   ///the tableName of that schema
  target?: []const u8,
   ///Type of relation. Can be one of the value of the RelationTypes class.
  RelationType?: "MANY" | "ONE";
}
 ///All together

pub const ColumnType =
  | BooleanConstructor
  | DateConstructor
  | NumberConstructor
  | Date
  | JSON
  | typeof Schema
  | StringConstructor;

pub const columnValidationType = {
  type?: ColumnType;
  width?: number;
  length?: number;
  nullable?: bool,
  default?: any;
  unique?: bool,
};

pub const qType =
  | "select"
  | "insert"
  | "delete"
  | "update"
  | "search"
  | "take"
  | "unique"
  | "skip"
  | "order"
  | "reference"
  | "count"
  | "populate";

pub const QueryType = Partial<Record<qType, any>>;

pub const Msg = { _id: string };
pub const Msgs = Msg[];

export interface fTable {
  [x: string]: { [x: string]: string[] | string };
}

export interface iTable {
  [x: string]: { [x: string]: string };
}

pub const LOG_file_type = Record<
  string,
  { last_id: string | null; size: number }
>;
 ///Document type

pub const ExaDoc<Model> = Model & {
   ///Document id
  _id: []const u8,
};

pub const connectOptions = {
  decorate(decorations: Record<string, (ctx: any) => void>): void;
};

pub const Xtree_flag = "i" | "u" | "d" | "n";

pub const wTrainType = [(value: unknown) => void, Msg, Xtree_flag];
