import SpriteKit
import AVFoundation
import iAd

class GameViewController: UIViewController {
    var scene: GameScene!
    var board: Board!
    
    
    
    @IBOutlet weak var adView: UIView!
    
    
    
    @IBAction func settingClick(sender: AnyObject) {
        adView.hidden = false
    }
    
    @IBAction func CloseClick(sender: AnyObject) {
         adView.hidden = true
    }
    
    
    @IBAction func moreGameClick(sender: AnyObject) {
        var barsLink : String = "itms-apps://itunes.apple.com/ca/artist/phuong-thanh-nguyen/id1019089261"
        UIApplication.sharedApplication().openURL(NSURL(string: barsLink)!)

    }
    
    
    @IBAction func newGameClick(sender: AnyObject) {
        
       
        SetupNewGame()
    }
    func SetupNewGame()
    {
        adView.hidden = true
        let skView = self.originalContentView as SKView
        skView.multipleTouchEnabled = false
        //skView.showsFPS = true
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
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("2", withExtension: "mp3")
        let player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player.volume = 0.1
        player.numberOfLoops = -1
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        SetupNewGame()
        
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
