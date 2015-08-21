struct Move {
    let checker: Checker
    let toColumn: Int
    let toRow: Int

    init(checker: Checker, toColumn: Int, toRow: Int) {
        self.checker = checker
        self.toColumn = toColumn
        self.toRow = toRow
    }
}

extension Move: Hashable {
    var hashValue: Int {
        return checker.hashValue ^ (toRow * NumColumns + toColumn)
    }
}

func ==(lhs: Move, rhs: Move) -> Bool {
    return lhs.checker == rhs.checker && lhs.toColumn == rhs.toColumn && lhs.toRow == rhs.toRow
}