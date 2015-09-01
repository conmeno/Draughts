import SpriteKit
import AVFoundation
 
import GoogleMobileAds

class GameViewController: UIViewController {
    var scene: GameScene!
    var board: Board!
    
    
    var AdNumber = 1
    var timerAd:NSTimer?
    @IBOutlet weak var adView: UIView!
    
    
    @IBOutlet weak var admobBanner: GADBannerView!
    
    @IBAction func settingClick(sender: AnyObject) {
        adView.hidden = false
    }
    
    @IBAction func CloseClick(sender: AnyObject) {
         adView.hidden = true
    }
    
    
    @IBAction func ThanksClick(sender: AnyObject) {
        
        showAds()
    }
    
    
    @IBAction func moreGameClick(sender: AnyObject) {
        var barsLink : String = "itms-apps://itunes.apple.com/ca/artist/phuong-nguyen/id1004963752"
        UIApplication.sharedApplication().openURL(NSURL(string: barsLink)!)

    }
    func showAds()
    {
        Chartboost.showInterstitial("Level " + String(AdNumber))
        AdNumber++
        println(AdNumber)
    }

    @IBAction func AutoClick(sender: AnyObject) {
        adView.backgroundColor = UIColor.blueColor()
        
        
        self.timerAd = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerMethodAutoAd:", userInfo: nil, repeats: true)
    }
    
    
    
    
    func timerMethodAutoAd(timer:NSTimer) {
        println("auto play")
        adView.backgroundColor = UIColor.redColor()
        showAds()
        showMobilecore2()
       
    }

    
    @IBAction func newGameClick(sender: AnyObject) {
       
        SetupNewGame()
    }
    func SetupNewGame()
    {
        adView.hidden = true
//        self.originalContentView
        let skView = view as SKView
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
        //self.canDisplayBannerAds = true
        SetupNewGame()
        showAds()
        
        
        
        admobBanner.adUnitID = "ca-app-pub-9535461294868148/4740972913"
        admobBanner.rootViewController = self
        self.view.addSubview(admobBanner!)
        var request:GADRequest = GADRequest()
        request.testDevices = ["e8cf8abb8e5a1ce756672f571a9194b2","a9da473d5b9a9baca034c10155b648b2"]
        admobBanner.loadRequest(request)
        //end admob
        
        
        
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
    
    
    @IBAction func MediaCoreClick(sender: AnyObject) {
        println("show mobileCore")
        showMobilecore2()
        showMobilecore()
        
    }
    
    func showMobilecore()
    {
        
        MobileCore.showInterstitialFromViewController(self, delegate: nil)
    }
    func showMobilecore2()
    {
        MobileCore.showStickeeFromViewController(self)
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

//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
}
