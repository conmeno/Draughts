let NumColumns = 8
let NumRows = 8

class Board {
    private var board = Array2D<Checker>(columns: NumColumns, rows: NumRows)
    var currentType: CheckerType = .White
    
    func initBoard() -> Set<Checker> {
        var set = Set<Checker>()
        
        for row in 0 ..< NumRows {
            for column in 0 ..< NumColumns {
                if (row + column) % 2 == 0 && (row < 3 || row > 4) {
                    let checker = Checker(column: column, row: row, type: row < 3 ? .White : .Black)
                    board[column, row] = checker
                    set.addElement(checker)
                }
            }
        }
        
        return set
    }
    
    func checkerAtColumn(column: Int, row: Int) -> Checker? {
        return board[column, row]
    }
    
    func performMove(move: Move) {
        let checker = move.checker
        let toColumn = move.toColumn
        let toRow = move.toRow
        
        board[toColumn, toRow] = checker
        board[checker.column, checker.row] = nil
        
        checker.row = toRow
        checker.column = toColumn
        
        currentType.changeType()
    }
    
    func deleteChecker(checker: Checker) {
        board[checker.column, checker.row] = nil
    }
    
    func eat() -> Bool {
        for row in 0 ..< NumRows {
            for column in 0 ..< NumColumns {
                if let checker = board[column, row] {
                    if checker.type == currentType {
                        if !eatMoves(checker).isEmpty() {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func eatMoves(checker: Checker) -> Set<Move> {
        var set = Set<Move>()
        
        let fromColumn = checker.column
        let fromRow = checker.row
        
        for(var horzDelta = -1; horzDelta < 2; ++horzDelta) {
            if horzDelta == 0 { continue }
            
            for(var vertDelta = -1; vertDelta < 2; ++vertDelta) {
                if vertDelta == 0 { continue }
                
                let doubleMove = (fromColumn + 2 * horzDelta) >= 0 && (fromColumn + 2 * horzDelta) < NumColumns && (fromRow + 2 * vertDelta) >= 0 && (fromRow + 2 * vertDelta) < NumRows
                
                if doubleMove
                    && board[fromColumn + horzDelta, fromRow + vertDelta] != nil
                    && board[fromColumn + horzDelta, fromRow + vertDelta]!.type != checker.type
                    && board[fromColumn + 2 * horzDelta, fromRow + 2 * vertDelta] == nil {
                    set.addElement(Move(checker: checker, toColumn: fromColumn + 2 * horzDelta, toRow: fromRow + 2 * vertDelta))
                }
            }
        }
        
        return set
    }
    
    func simpleMoves(checker: Checker) -> Set<Move> {
        var set = Set<Move>()
        
        let fromColumn = checker.column
        let fromRow = checker.row
        
        let delta = checker.type == .White ? 1 : -1
        
        for(var horzDelta = -1; horzDelta < 2; ++horzDelta) {
            if horzDelta == 0 { continue }
            
            let move = (fromColumn + horzDelta) >= 0 && (fromColumn + horzDelta) < NumColumns && (fromRow + delta) >= 0 && (fromRow + delta) < NumRows
            
            if move && board[fromColumn + horzDelta, fromRow + delta] == nil {
                set.addElement(Move(checker: checker, toColumn: fromColumn + horzDelta, toRow: fromRow + delta))
            }
        }
        
        return set
    }
    
    func validMove(checker: Checker) -> Set<Move> {
        return eat() ? eatMoves(checker) : simpleMoves(checker)
    }
}