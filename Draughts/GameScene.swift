import SpriteKit

let Duration: NSTimeInterval = 0.3

class GameScene: SKScene {
    let TileSide: CGFloat = 36.0
    var checkersLayer = SKNode()
    var board: Board!
    var selectionSprite = SKSpriteNode()
    var validTiles = SKNode()
    var moveFrom: Checker?
    var moveHandler: ((Move) -> ())?
    var deleteHandler: ((Checker) -> ())?
    var validMoves: Set<Move>?
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    let eatSound = SKAction.playSoundFileNamed("eat.wav", waitForCompletion: false)

    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
let background1 = SKSpriteNode(imageNamed: "b3")
        
        let background = SKSpriteNode(imageNamed: "Background")
        
        let layerPosition = CGPoint(x: -TileSide * CGFloat(NumColumns) / 2, y: -TileSide * CGFloat(NumRows) / 2)
        checkersLayer.position = layerPosition
        validTiles.position = layerPosition
        addChild(background1)
        addChild(background)
        addChild(validTiles)
        addChild(checkersLayer)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(checkersLayer)
        
        let (success, column, row) = convertPoint(location)
        
        if success {
            if let checker = board.checkerAtColumn(column, row: row) {
                if checker.type == board.currentType {
                    showSelectionIndicatorForCookie(checker)
                    moveFrom = checker
                    validMoves = board.validMove(checker)
                    showValidMoves(validMoves!)
                }
            } else if let checker = moveFrom {
                tryMoveToColumn(column, row: row)
                hideSelectionIndicator()
                hideValidMove()
                moveFrom = nil
                validMoves = nil
            }
        }
    }
    
    func showValidMoves(moves: Set<Move>) {
        validTiles.removeAllChildren()
            for obj in moves {
                let sprite = SKSpriteNode(imageNamed: "ValidTile")
                sprite.position = pointForColumn(obj.toColumn, row: obj.toRow)
                validTiles.addChild(sprite)
                validTiles.alpha = 1.0
            }
    }
    
    func hideValidMove() {
        if !validTiles.children.isEmpty {
            validTiles.removeAllChildren()
            validTiles.runAction(SKAction.fadeOutWithDuration(Duration))
        }
    }
    
    func animateMove(move: Move, completion: () -> ()) {
        let sprite = move.checker.sprite!
        sprite.zPosition = 1
        
        let move = SKAction.moveTo(pointForColumn(move.toColumn, row: move.toRow), duration: Duration)
        move.timingMode = .EaseOut
        
        sprite.runAction(move, completion: completion)
    }
    
    func tryMoveToColumn(column: Int, row: Int) {
        if let checker = moveFrom {
            let move = Move(checker: checker, toColumn: column, toRow: row)
            if validMoves!.containsElement(move) {
                let delta = abs(column - checker.column)
                if delta == 2 {
                    deleteHandler?(board.checkerAtColumn((column + checker.column) / 2, row: (row + checker.row) / 2)!)
                    runAction(eatSound)
                } else {
                    runAction(moveSound)
                }
                moveHandler?(move)
            }
        }
    }
    
    func deleteChecker(checker: Checker) {
        checker.sprite!.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.1), SKAction.removeFromParent()]))
    }
    
    func showSelectionIndicatorForCookie(checker: Checker) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        if let sprite = checker.sprite {
            let texture = SKTexture(imageNamed: checker.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(Duration), SKAction.removeFromParent()]))
    }
    
    func addSpritesForCheckers(checkers: Set<Checker>) {
        for obj in checkers {
            let sprite = SKSpriteNode(imageNamed: obj.spriteName)
            sprite.texture!.filteringMode = .Nearest
            sprite.position = pointForColumn(obj.column, row: obj.row)
            checkersLayer.addChild(sprite)
            obj.sprite = sprite
        }
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns) * TileSide && point.y >= 0 && point.y < CGFloat(NumRows) * TileSide {
            return (true, Int(point.x / TileSide), Int(point.y / TileSide))
        } else {
            return (false, 0, 0)
        }
    }

    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: TileSide * CGFloat(column) + TileSide / 2, y: TileSide * CGFloat(row) + TileSide / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
