pub const ColumnType = enum(bool) {
    Boolean = false,
    Date = false,
    Number = false,
    Date = false,
    JSON = false,
    Schema = false,
    String = false,
    pub fn which(self: ColumnType) bool {
        // return self == Suit.clubs;
    }
};
