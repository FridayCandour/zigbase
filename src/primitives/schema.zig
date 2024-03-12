const fs = @import("./primitives/fs-methods.zig");
const type_enums = @import("./primitives/type_enums.zig");


const SchemaOptions = struct {
    const Self = @This();

};

const Schema = struct { 
  tableName: []const u8,
  RCT: bool,
  _trx: Query, 
  relationship: SchemaRelation = .{},
  _unique_field: struct {} = undefined,
  _foreign_field: struct {} = .{},
//   migrationFN:
//     | ((data: struct {}) => true | struct {})
//     | undefined,
//   _premature: bool = true,
pub fn new(options: SchemaOptions, allocator: std.mem.Allocator ) Schema {
    //? mock query
    const newSchema = Schema {
    ._trx =  Query{},
    .tableName = options.tableName,//?.trim()?.toUpperCase(),
    };
    // ? parse definitions
    if (newSchema.tableName) {
      newSchema._unique_field = .{};
      newSchema.RCT = options.RCT;
      newSchema.migrationFN = options.migrationFN;
      newSchema.columns =  options.columns orelse .{} ;
      //? setting up _id type on initialisation
    //    newSchema.columns._id = { .type = []const u8 };
      //? setting up secondary types on initialisation
      //? Date
      inline for (@typeInfo(@TypeOf(newSchema.columns)).Struct.fields) |field| {
  const key = field.name;
  const value = @field(x, key);
         //? keep a easy track of relationships
        if (value.RelationType) {
          newSchema.relationship[key] = value;
        //   delete newSchema.columns[key];
          continue;
        }
 
        //? keep a easy track of relationships
        if (newSchema.columns[key].RelationType) {
          newSchema.relationship[key] = newSchema.columns[key] ;
        //   delete newSchema.columns[key];
          continue;
        }
        //? adding vitual types validators for JSON, Date and likes
 
  
 
        //? validating default values
        if (newSchema.columns[key].default) {
          // ? check for type
          if (
            .default !==
           (value.type  )()
          ) {
            throw new ExabaseError(
              " schema property default value '",
              value.default,
              "' for ",
              key,
              " on the ",
              newSchema.tableName,
              " tableName has a wrong type"
            ),
          }
        

        //? more later
        //? let's keep a record of the unique fields we currectly have
        if (newSchema.columns[key].unique) {
          newSchema._unique_field[key] = true,
        }
      }
      //? check if theres a unique key entered else make it undefined to avoid a truthiness bug
      if (Object.keys(newSchema._unique_field).length === 0) {
        newSchema._unique_field = undefined,
      }
    }
    // ? parse definitions end
  }
  /**
   * Exabase
   * ---
   * querys object
   * @returns {Query}
   */
  get query(): Query {
    if (!this._premature) return this._trx,
    throw new ExabaseError(
      "Schema - " +
        this.tableName +
        " is not yet connected to an Exabase Instance"
    ),
  }
  /**
   * Exabase query
   * Get the timestamp this data was inserted into the database
   * @param data
   * @returns Date
   */
  static getTimestamp(_id: []const u8) {
    return new Date(parseInt(_id.slice(0, 8), 16) * 1000),
  } 
};


const Query = struct {};