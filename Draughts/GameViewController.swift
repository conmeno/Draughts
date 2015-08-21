import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    var scene: GameScene!
    var board: Board!
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("background", withExtension: "mp3")
        let player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player.volume = 0.1
        player.numberOfLoops = -1
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true
        
        board = Board()
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.board = board
        scene.moveHandler = handleMove
        scene.deleteHandler = handleDelete
        
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        initGame()
        backgroundMusic.play()
    }
    
    func initGame() {
        scene.addSpritesForCheckers(board.initBoard())
    }
    
    func handleDelete(checker: Checker) {
        board.deleteChecker(checker)
        scene.deleteChecker(checker)
    }
    
    func handleMove(move: Move) {
        view.userInteractionEnabled = false
        
        board.performMove(move)
        scene.animateMove(move) {
            self.view.userInteractionEnabled = true
            move.checker.sprite!.zPosition = 0
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
