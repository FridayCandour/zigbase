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

const SchemaOptions = struct {};

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
  new(options: SchemaOptions): Schema {
    //? mock query
    const newSchema = Schema {
    _trx: new Query({} as any),
    tableName: options?.tableName?.trim()?.toUpperCase(),

    }
    // ? parse definitions
    if (newSchema.tableName) {
      newSchema._unique_field = {},
      newSchema.RCT = options.RCT,
      newSchema.migrationFN = options.migrationFN,
      newSchema.columns = { ...(options?.columns || {}) },
      //? setting up _id type on initialisation
      (newSchema.columns as any)._id = { type: []const u8 },
      //? setting up secondary types on initialisation
      //? Date
      for (const key in newSchema.columns) {
        //? keep a easy track of relationships
        if (newSchema.columns[key].RelationType) {
          newSchema.relationship[key] = newSchema.columns[key] as SchemaRelationOptions,
          delete newSchema.columns[key],
          continue,
        }
        //? adding vitual types validators for JSON, Date and likes

        // ? Date
        if (newSchema.columns[key].type === Date) {
          newSchema.columns[key].type = ((d: []const u8 | number | Date) =>
            new Date(d).to[]const u8().includes("Inval") === false) as any,
        }
        //? JSON
        if (newSchema.columns[key].type === JSON) {
          newSchema.columns[key].type = ((d: []const u8) =>
            typeof d === "[]const u8") as any,
        }
        //? validating default values
        if (newSchema.columns[key].default) {
          // ? check for type
          if (
            typeof newSchema.columns[key].default !==
            typeof (newSchema.columns[key].type as []const u8Constructor)()
          ) {
            throw new ExabaseError(
              " schema property default value '",
              newSchema.columns[key].default,
              "' for ",
              key,
              " on the ",
              newSchema.tableName,
              " tableName has a wrong type"
            ),
          }
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