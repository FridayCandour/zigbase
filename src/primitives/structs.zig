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
  columns: struct {},
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
  // migrationFN: (data: Record<string, string>): Record<string, string> | true;
}

 ///Indicates the relationship

pub const SchemaRelation =  struct {
  
}; //Record<string, SchemaRelationOptions>;
 ///Indicates the relationship name

pub const SchemaRelationOptions = struct   {
   ///Indicates with which schema this relation is connected to.
   ///the tableName of that schema
  target: []const u8,
   ///Type of relation. Can be one of the value of the RelationTypes class.
  RelationType: []const u8,// "MANY" | "ONE";
};

//  ///Interface for schema column type mappings 
// pub const SchemaColumnOptions = struct {
//    ///Column type. Must be one of the value from the ColumnTypes class.
//   type: ColumnType;
//    ///Column type's length. For example type = "string" and length = 100
//   length?: number;
//    ///For example, 4 specifies a number of four digits.
//   width?: number;
//    ///Indicates if column's value can be set to NULL.
//   nullable?: bool,
//    ///Exabase DBMS
//    ///---
//    ///Default value.
//   default?: any;
//    ///Indicates if column's value is unique
//   unique?: bool,
//    ///Indicates with which schema this relation is connected to.
 
//    ///the tableName of that schema
//   target?: []const u8,
//    ///Type of relation. Can be one of the value of the RelationTypes class.
//   RelationType?: "MANY" | "ONE";
// }
  