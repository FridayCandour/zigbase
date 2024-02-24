class XNode {
  constructor(keys?: { value: any; indexes: number[] }[]) {
    this.keys = keys || [];
  }
  keys: { value: any; indexes: number[] }[] = [];
  insert(value: any, index: number) {
    let low = 0;
    let high = this.keys.length - 1;
    for (; low <= high; ) {
      const mid = Math.floor((low + high) / 2);
      const current = this.keys[mid].value;
      if (current === value) {
        this.keys[mid].indexes.push(index);
        return;
      }
      if (current < value) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    this.keys.splice(low, 0, { value, indexes: [index] });
  }
  disert(value: unknown, index: number) {
    let left = 0;
    let right = this.keys.length - 1;
    for (; left <= right; ) {
      const mid = Math.floor((left + right) / 2);
      const current = this.keys[mid].value;
      if (current === value) {
        this.keys[mid].indexes = this.keys[mid].indexes.filter(
          (a) => a !== index
        );
        return;
      } else if (current! < value!) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
  }
  upsert(value: unknown, index: number) {
    this.disert(value, index);
    this.insert(value, index);
  }
  search(value: unknown): number[] {
    let left = 0;
    let right = this.keys.length - 1;
    for (; left <= right; ) {
      const mid = Math.floor((left + right) / 2);
      const current = this.keys[mid].value;
      if (
        current === value ||
        (typeof current === "string" && current.includes(value as string))
      ) {
        return this.keys[mid].indexes;
      } else if (current! < value!) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return [];
  }
}

export class XTree {
  base: string[] = [];
  mutatingBase: boolean = false;
  persitKey: string;
  tree: Record<string, XNode> = {};

  constructor(init: { persitKey: string }) {
    this.persitKey = init.persitKey;
    const [base, tree] = XTree.restore(init.persitKey);
    if (base) {
      this.base = base;
      this.tree = tree;
    }
  }
  restart() {
    this.base = [];
    this.tree = {} as Record<string, XNode>;
  }
  search(search: any, take: number = Infinity, skip: number = 0) {
    const results: string[] = [];
    for (const key in search) {
      if (this.tree[key]) {
        const indexes = this.tree[key].search(search[key as keyof any]);
        if (skip && results.length >= skip) {
          results.splice(0, skip);
          skip = 0;
        }
        results.push(...(indexes || []).map((idx: number) => this.base[idx]));
        if (results.length >= take) break;
      }
    }
    if (results.length >= take) return results.slice(0, take);

    return results;
  }

  searchBase(_id: string) {
    let left = 0;
    let right = this.base.length - 1;
    for (; left <= right; ) {
      const mid = Math.floor((left + right) / 2);
      const current = this.base[mid];
      if (current === _id) {
        return mid;
      } else if (current! < _id!) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return;
  }

  count(search: any) {
    let resultsCount: number = 0;
    for (const key in search) {
      if (this.tree[key]) {
        resultsCount += this.tree[key].search(search[key as keyof any]).length;
      }
    }
    return resultsCount;
  }

  confirmLength(size: number) {
    return this.base.length === size;
  }

  manage(trx: any, flag: string) {
    switch (flag) {
      case "i":
        return this.insert(trx);
      case "u":
        return this.upsert(trx);
      case "d":
      case "n":
        return;
      default:
        console.error("boohoo", { trx });
        return;
    }
  }
  async insert(data: any, bulk = false) {
    if (!data["_id"]) throw new Error("bad insert");
    if (!this.mutatingBase) {
      this.mutatingBase = true;
    } else {
      this.insert(data, bulk);
      return;
    }
    // ? save keys in their corresponding nodes
    if (typeof data === "object" && !Array.isArray(data)) {
      for (const key in data) {
        if ("_wal_ignore_flag-_id".includes(key)) continue;
        if (!this.tree[key]) {
          this.tree[key] = new XNode();
        }
        this.tree[key].insert(data[key as keyof any], this.base.length);
      }
      this.base.push(data["_id"]);
      this.mutatingBase = false;
    }
    if (!bulk) await this.persit();
  }
  async disert(data: any, bulk = false) {
    if (!data["_id"]) throw new Error("bad insert");
    if (!this.mutatingBase) {
    } else {
      this.disert(data, bulk);
      return;
    }
    const index = this.searchBase(data["_id"]);
    if (index === undefined) return;
    if (typeof data === "object" && !Array.isArray(data)) {
      for (const key in data) {
        if (key === "_id" || !this.tree[key]) continue;
        this.tree[key].disert(data[key as keyof any], index);
      }
      this.mutatingBase = true;
      this.base.splice(index, 1);
      this.mutatingBase = false;
    }
    if (!bulk) await this.persit();
  }
  async upsert(data: any, bulk = false) {
    if (!data["_id"]) throw new Error("bad insert");
    if (!this.mutatingBase) {
    } else {
      this.upsert(data, bulk);
      return;
    }
    const index = this.searchBase(data["_id"]);
    if (index === undefined) return;
    if (typeof data === "object" && !Array.isArray(data)) {
      for (const key in data) {
        if (key === "_id") continue;
        if (!this.tree[key]) {
          this.tree[key] = new XNode();
        }
        this.tree[key].upsert(data[key as keyof any], index);
      }
    }
    this.mutatingBase = true;
    if (!bulk) await this.persit();
    this.mutatingBase = false;
  }

  private persit() {
    const obj: Record<string, any> = {};
    const keys = Object.keys(this.tree);
    for (let index = 0; index < keys.length; index++) {
      obj[keys[index]] = this.tree[keys[index]].keys;
    }
    return SynFileWritWithWaitList.write(
      this.persitKey,
      Utils.packr.encode({
        base: this.base,
        tree: obj,
      })
    );
  }
  static restore(persitKey: string) {
    const data = loadLogSync(persitKey);
    const tree: Record<string, any> = {};
    if (data.tree) {
      for (const key in data.tree) {
        tree[key] = new XNode(data.tree[key]);
      }
    }
    return [data.base, tree];
  }
}
function loadLogSync(persitKey: string) {
  throw new Error("Function not implemented.");
}
