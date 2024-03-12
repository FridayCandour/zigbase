const fs = @import("./primitives/fs-methods.zig");
const type_enums = @import("./primitives/type_enums.zig");
const utils = @import("./primitives/utils.zig");
const std = @import("std");

const SchemaOptions = struct {
    const Self = @This();
};

const Schema = struct {
    tableName: []const u8,
    RCT: bool,
    _trx: type_enums.Query,
    relationship: type_enums.SchemaRelation = .{},
    _unique_field: struct {} = undefined,
    _foreign_field: struct {} = .{},
    pub fn new(options: type_enums.SchemaOptions) Schema {
        //? mock query
        const newSchema = Schema{
            ._trx = type_enums.Query{},
            .tableName = utils.trimAndUpcase(&options.tableName), //?.trim()?.toUpperCase(),
        };
        // ? parse definitions
        if (newSchema.tableName) {
            newSchema._unique_field = .{};
            newSchema.RCT = options.RCT;
            newSchema.migrationFN = options.migrationFN;
            newSchema.columns = options.columns orelse .{};
            //? setting up _id type on initialisation
            //    newSchema.columns._id = { .type = []const u8 };
            //? setting up secondary types on initialisation
            //? Date
            inline for (@typeInfo(@TypeOf(newSchema.columns)).Struct.fields) |field| {
                const key = field.name;
                const value = @field(newSchema.columns, key);
                //? keep a easy track of relationships
                if (value.RelationType) {
                    newSchema.relationship[key] = value;
                    //   delete newSchema.columns[key];
                    continue;
                }

                //? keep a easy track of relationships
                if (newSchema.columns[key].RelationType) {
                    newSchema.relationship[key] = newSchema.columns[key];
                    //   delete newSchema.columns[key];
                    continue;
                }
                //? adding vitual types validators for JSON, Date and likes

                //? validating default values
                if (newSchema.columns[key].default) {
                    // ? check for type
                    if (.default !=
                        (value.type))
                    {
                        //
                    }

                    //? more later
                    //? let's keep a record of the unique fields we currectly have
                    if (newSchema.columns[key].unique) {
                        newSchema._unique_field[key] = true;
                    }
                }
            }
            // ? parse definitions end
        }
        return newSchema;
    }
    /// Exabase
    /// ---
    /// querys object
    /// @returns {Query}
    pub fn query() void {
        // if (._premature) return this._trx,
        // throw new ExabaseError(
        //   "Schema - " +
        //     this.tableName +
        //     " is not yet connected to an Exabase Instance"
        // );
    }

    /// Exabase query
    /// Get the timestamp this data was inserted into the database
    /// @param data
    /// @returns Date
    pub fn getTimestamp() void {
        // return new Date(parseInt(_id.slice(0, 8), 16) /// 1000),
    }
};
