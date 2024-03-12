// //? this is okay because it's reusable
// export class Query<Model> {
//   private _Manager: Manager;
//   premature: boolean = true;
//   constructor(Manager: Manager) {
//     this._Manager = Manager;
//     if (Manager) {
//       this.premature = false;
//     }
//   }

//   /**
//    * Exabase query
//    * find items on the database,
//    * field can be _id string or unique props object
//    * @param field
//    * @param options
//    * @returns
//    */
//   findMany(
//     field?: Partial<Model> | string,
//     options?: {
//       populate?: string[] | boolean;
//       take?: number;
//       skip?: number;
//     }
//   ) {
//     // ? creating query payload
//     const query: QueryType = {
//       select: typeof field === "string" ? field : "*",
//     };
//     // ? inputing relationship payload
//     if (typeof field === "object") {
//       query.select = undefined;
//       let key: string = "",
//         value: any;
//       for (const k in field) {
//         key = k;
//         value = field[k];
//         break;
//       }
//       const fieldT = (this._Manager._schema.columns as any)[key as string];
//       if (fieldT && fieldT.unique) {
//         query["unique"] = {
//           [key]: value,
//         };
//       } else {
//         throw new ExabaseError(
//           `column field ${key} is not unique, please try searching instead`
//         );
//       }
//     }
//     // ? populate options
//     if (typeof options === "object") {
//       query.populate = {};
//       query.skip = options.skip;
//       query.take = options.take;
//       const fields = this._Manager._schema._foreign_field!;
//       if (options.populate === true) {
//         for (const lab in fields) {
//           query.populate[lab] = fields[lab];
//         }
//       } else {
//         if (Array.isArray(options.populate)) {
//           for (let i = 0; i < options.populate.length; i++) {
//             const lab = options.populate[0];
//             const relaName = fields[lab];
//             if (relaName) {
//               query.populate[lab] = fields[lab];
//             } else {
//               throw new ExabaseError(
//                 "can't POPULATE missing realtionship " + lab
//               );
//             }
//           }
//         }
//       }
//     }
//     return this._Manager._run(query) as Promise<ExaDoc<Model>[]>;
//   }
//   /**
//    * Exabase query
//    * find items on the database,
//    * field can be _id string or unique props object
//    * @param field
//    * @param options
//    * @returns
//    */
//   findOne(
//     field: Partial<Model> | string,
//     options?: {
//       populate?: string[] | boolean;
//     }
//   ) {
//     // ? creating query payload
//     const query: QueryType = {
//       select: typeof field === "string" ? field : undefined,
//     };
//     // ? inputing relationship payload
//     if (typeof field === "object") {
//       let key: string = "",
//         value: any;
//       for (const k in field) {
//         key = k;
//         value = field[k];
//         break;
//       }
//       const fieldT = (this._Manager._schema.columns as any)[key as string];
//       if (fieldT && fieldT.unique) {
//         query["unique"] = {
//           [key]: value,
//         };
//       } else {
//         throw new ExabaseError(
//           `column field ${key} is not unique, please try searching instead`
//         );
//       }
//     }
//     // ? populate options
//     if (typeof options === "object") {
//       query.populate = {};
//       const fields = this._Manager._schema._foreign_field!;
//       if (options.populate === true) {
//         for (const lab in fields) {
//           query.populate[lab] = fields[lab];
//         }
//       } else {
//         if (Array.isArray(options.populate)) {
//           for (let i = 0; i < options.populate.length; i++) {
//             const lab = options.populate[0];
//             const relaName = fields[lab];
//             if (relaName) {
//               query.populate[lab] = fields[lab];
//             } else {
//               throw new ExabaseError(
//                 "can't POPULATE missing realtionship " + lab
//               );
//             }
//           }
//         }
//       }
//     }

//     return this._Manager._run(query) as Promise<ExaDoc<Model>>;
//   }
//   /**
//    * Exabase query
//    * search items on the database,
//    * @param searchQuery
//    * @param options
//    * @returns
//    */
//   search(
//     searchQuery: Partial<Model>,
//     options?: {
//       populate?: string[] | boolean;
//       take?: number;
//       skip?: number;
//     }
//   ) {
//     if (typeof searchQuery !== "object" && !Array.isArray(searchQuery))
//       throw new ExabaseError("invalid search query ", searchQuery);
//     let query: QueryType = { search: searchQuery };
//     // ? populate options
//     if (typeof options === "object") {
//       query.skip = options.skip;
//       query.take = options.take;
//       query.populate = {};
//       const fields = this._Manager._schema._foreign_field!;
//       if (options.populate === true) {
//         for (const lab in fields) {
//           query.populate[lab] = fields[lab];
//         }
//       } else {
//         if (Array.isArray(options.populate)) {
//           for (let i = 0; i < options.populate.length; i++) {
//             const lab = options.populate[0];
//             const relaName = fields[lab];
//             if (relaName) {
//               query.populate[lab] = fields[lab];
//             } else {
//               throw new ExabaseError(
//                 "can't POPULATE missing realtionship " + lab
//               );
//             }
//           }
//         }
//       }
//     }
//     return this._Manager._run(query) as Promise<ExaDoc<Model>[]>;
//   }
//   /**
//    * Exabase query
//    * insert or update items on the database
//    * @param data
//    * @returns
//    */
//   save(data: Partial<ExaDoc<Model>>) {
//     const hasid = typeof data?._id === "string";
//     const query: QueryType = {
//       [hasid ? "update" : "insert"]: this._Manager._validate(data, hasid),
//     };
//     return this._Manager._run(query) as Promise<ExaDoc<Model>>;
//   }
//   /**
//    * Exabase query
//    * delete items on the database,
//    * @param _id
//    * @returns
//    */
//   delete(_id: string) {
//     if (typeof _id !== "string") {
//       throw new ExabaseError(
//         "cannot continue with delete query '",
//         _id,
//         "' is not a valid Exabase _id value"
//       );
//     }
//     const query: QueryType = {
//       delete: _id,
//     };
//     return this._Manager._run(query) as Promise<ExaDoc<Model>>;
//   }
//   /**
//    * Exabase query
//    * count items on the database
//    * @returns
//    */
//   count(pops?: Partial<Model>) {
//     const query: QueryType = {
//       count: pops || true,
//     };
//     return this._Manager._run(query) as Promise<number>;
//   }
//   /**
//    * Exabase query
//    * connect relationship in the table on the database
//    * @param options
//    * @returns
//    */
//   addRelation(options: {
//     _id: string;
//     foreign_id: string;
//     relationship: string;
//   }) {
//     const rela = this._Manager._schema.relationship![options.relationship];

//     if (!rela) {
//       throw new ExabaseError(
//         "No relationship definition called ",
//         options.relationship,
//         " on ",
//         this._Manager._schema.tableName,
//         " schema"
//       );
//     }

//     if (typeof options.foreign_id !== "string") {
//       throw new ExabaseError("foreign_id field is invalid.");
//     }
//     const query: QueryType = {
//       reference: {
//         _id: options._id,
//         _new: true,
//         type: rela.RelationType,
//         foreign_id: options.foreign_id,
//         relationship: options.relationship,
//         foreign_table: rela.target,
//       },
//     };
//     return this._Manager._run(query) as Promise<void>;
//   }
//   /**
//    * Exabase query
//    * disconnect relationship in the table on the database
//    * @param options
//    * @returns
//    */
//   removeRelation(options: {
//     _id: string;
//     foreign_id: string;
//     relationship: string;
//   }) {
//     const rela = this._Manager._schema.relationship![options.relationship];
//     if (!rela) {
//       throw new ExabaseError(
//         "No relationship definition called ",
//         options.relationship,
//         " on ",
//         this._Manager._schema.tableName,
//         " schema"
//       );
//     }
//     const query: QueryType = {
//       reference: {
//         _id: options._id,
//         _new: false,
//         type: rela.RelationType,
//         foreign_id: options.foreign_id,
//         relationship: options.relationship,
//         foreign_table: rela.target,
//       },
//     };
//     return this._Manager._run(query) as Promise<void>;
//   }
//   /**
//    * Exabase query
//    * insert or update many items on the database
//    * @param data
//    * @param type
//    */
//   saveBatch(data: Partial<Model>[]) {
//     if (Array.isArray(data)) {
//       const q = this._prepare_for(data, false);
//       return this._Manager._runMany(q) as Promise<ExaDoc<Model[]>>;
//     } else {
//       throw new ExabaseError(
//         `Invalid inputs for .saveBatch method, data should be array.`
//       );
//     }
//   }
//   deleteBatch(data: Partial<Model>[]) {
//     if (Array.isArray(data)) {
//       const q = this._prepare_for(data, true);
//       return this._Manager._runMany(q) as Promise<ExaDoc<Model[]>>;
//     } else {
//       throw new ExabaseError(
//         `Invalid inputs for .deleteBatch method, data should be array.`
//       );
//     }
//   }
//   private _prepare_for(data: Partial<Model>[], del: boolean) {
//     const query: QueryType[] = [];
//     for (let i = 0; i < data.length; i++) {
//       const item = data[i];
//       if (del) {
//         if (typeof (item as any)._id === "string") {
//           query.push({
//             delete: (item as any)._id,
//           });
//         } else {
//           throw new ExabaseError(
//             "cannot continue with delete query '",
//             (item as any)._id,
//             "' is not a valid Exabase _id value"
//           );
//         }
//       } else {
//         const hasid = (item as any)?._id && true;
//         query.push({
//           [hasid ? "update" : "insert"]: this._Manager._validate(item, hasid),
//         });
//       }
//     }
//     return query;
//   }
// }
