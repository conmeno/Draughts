import SpriteKit

enum CheckerType: Int, CustomStringConvertible {
    case White = 0, Black
    var description: String {
        return rawValue == 0 ? "White" : "Black"
    }
    
    mutating func changeType() {
        self = CheckerType(rawValue: self.rawValue ^ 1)!
    }
}

enum CheckerRank: Int, CustomStringConvertible {
    case Pawn = 0, King
    var description: String {
        return rawValue == 0 ? "Pawn" : "King"
    }
}

class Checker {
    var column: Int
    var row: Int
    let type: CheckerType
    var rank: CheckerRank
    var sprite: SKSpriteNode?
    var spriteName: String {
        return "\(type)\(rank)"
    }
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    init(column: Int, row: Int, type: CheckerType) {
        self.column = column
        self.row = row
        self.type = type
        rank = .Pawn
    }
    
    func changeRank() {
        rank = CheckerRank(rawValue: rank.rawValue ^ 1)!
    }
}

extension Checker: Hashable {
    var hashValue: Int {
        return row * NumColumns + column
    }
}

func ==(lhs: Checker, rhs: Checker) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}