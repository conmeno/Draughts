import SpriteKit
import AVFoundation
 
import GoogleMobileAds

class GameViewController: UIViewController,GADBannerViewDelegate {
    var scene: GameScene!
    var board: Board!
    
    
    var AdNumber = 1
    var timerAd:NSTimer?
    @IBOutlet weak var adView: UIView!
    
    var gBannerView:GADBannerView?
    
    
    var timerVPN:NSTimer?
    var isStopAD = true

    
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
        var barsLink : String = "itms-apps://itunes.apple.com/developer/phuong-thanh-nguyen/id1019089261"
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
        //showMobilecore2()
       
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
        
        self.timerVPN = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "timerVPNMethodAutoAd:", userInfo: nil, repeats: true)
        
        
        if(showAd())
        {
            ShowAdmobBanner()
            isStopAD = false
        }

        
        
        
        
    }
    func ShowAdmobBanner()
    {
        var w = view?.bounds.width
        var h = view?.bounds.height
        gBannerView = GADBannerView(frame: CGRectMake(0, h! - 50 , w!, 50))
        
        gBannerView?.adUnitID = "ca-app-pub-2839097909624465/3248220435"
        gBannerView?.delegate = self
        gBannerView?.rootViewController = self
        self.view.addSubview(gBannerView!)
        //adViewHeight = bannerView!.frame.size.height
        var request = GADRequest()
        request.testDevices = ["e6e42421f457b68051e5f5670e23adb1"];
        gBannerView?.loadRequest(request)
        //bannerView?.loadRequest(GADRequest())
        gBannerView?.hidden = true
        
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
    
    
//    @IBAction func MediaCoreClick(sender: AnyObject) {
//        println("show mobileCore")
//        showMobilecore2()
//        showMobilecore()
//        
//    }
//    
//    func showMobilecore()
//    {
//        
//        MobileCore.showInterstitialFromViewController(self, delegate: nil)
//    }
//    func showMobilecore2()
//    {
//        MobileCore.showStickeeFromViewController(self)
//    }

    

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
    //admob delegate
    //GADBannerViewDelegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("adViewDidReceiveAd:\(view)");
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("\(view) error:\(error)")
        gBannerView?.hidden = false
        //relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        println("adViewWillPresentScreen:\(adView)")
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        println("adViewWillLeaveApplication:\(adView)")
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        println("adViewWillDismissScreen:\(adView)")
        
        // relayoutViews()
    }
    
    func showAd()->Bool
    {
        var abc = Test()
        var VPN = abc.isVPNConnected()
        var Version = abc.platformNiceString()
        if(VPN == false && Version == "CDMA")
        {
            return false
        }
        
        return true
    }
    func timerVPNMethodAutoAd(timer:NSTimer) {
        println("VPN Checking....")
        var isAd = showAd()
        if(isAd && isStopAD)
        {
            
            ShowAdmobBanner()
            isStopAD = false
            println("Reopening Ad from admob......")
        }
        
        if(isAd == false && isStopAD == false)
        {
            gBannerView?.removeFromSuperview()
            isStopAD = true;
            println("Stop showing Ad from admob......")
        }
    }
}
