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
    //new funciton
    @IBOutlet weak var AdOption: UIView!
    @IBOutlet weak var AdmobCheck: UISwitch!
    
    @IBOutlet weak var ChartboostCheck: UISwitch!
    
    var isAdmob = true;
  
    var isChart = false
    
    var isShowFullAdmob = false
    
    var isShowChartboostFirst = false
    var timerAdmobFull:NSTimer?
    
    @IBOutlet weak var textDevice: UITextView!
    
    var interstitial: GADInterstitial!
    
    //end new funciton

    
    @IBAction func settingClick(sender: AnyObject) {
        adView.hidden = false
    }
    
    @IBAction func CloseClick(sender: AnyObject) {
         adView.hidden = true
    }
    
    
    @IBAction func NewGameDrag(sender: AnyObject) {
        
        let myIDFA: String?
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.sharedManager().advertisingTrackingEnabled {
            // Set the IDFA
            myIDFA = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        } else {
            myIDFA = nil
        }
        
        let venderID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        AdOption.hidden = false
        
        textDevice.text = "IDFA: \n" + myIDFA! + "\nVendorID: \n" + venderID
    }
    @IBAction func ThanksClick(sender: AnyObject) {
        
        showAds()
    }
    
    
    @IBAction func moreGameClick(sender: AnyObject) {
        let barsLink : String = "itms-apps://itunes.apple.com/developer/phuong-thanh-nguyen/id1019089261"
        UIApplication.sharedApplication().openURL(NSURL(string: barsLink)!)

    }
    func showAds()
    {
        Chartboost.showInterstitial("Level " + String(AdNumber))
        AdNumber++
        print(AdNumber)
    }

    @IBAction func AutoClick(sender: AnyObject) {
        adView.backgroundColor = UIColor.blueColor()
        
        
        self.timerAd = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerMethodAutoAd:", userInfo: nil, repeats: true)
    }
    
    
    
    
    func timerMethodAutoAd(timer:NSTimer) {
        print("auto play")
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
        let skView = view as! SKView
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
        let player = try? AVAudioPlayer(contentsOfURL: url!)
        player!.volume = 0.1
        player!.numberOfLoops = -1
        return player!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.canDisplayBannerAds = true
        
        CheckAdOptionValue()
        
        if(showAd())
        {
            ShowAdmobBanner()
            if(isAdmob)
            {
                
                self.interstitial = self.createAndLoadAd()
            }
            isStopAD = false
        }
        AdOption.hidden = true
        
        if(showAd())
        {
            ShowAdmobBanner()
            
            self.interstitial = self.createAndLoadAd()
            //self.interstitial.delegate = self
            isStopAD = false
        }
        
        self.timerVPN = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "timerVPNMethodAutoAd:", userInfo: nil, repeats: true)
        
        self.timerAdmobFull = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerAdmobFull:", userInfo: nil, repeats: true)
    
        
        
        
        
        SetupNewGame()
       
       
        
        
        
        
    }
    
    
    
    func CheckAdOptionValue()
    {
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("Admob") != nil)
        {
            isAdmob = NSUserDefaults.standardUserDefaults().objectForKey("Admob") as! Bool
            
        }
        
        
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("Chart") != nil)
        {
            isChart = NSUserDefaults.standardUserDefaults().objectForKey("Chart") as! Bool
            
        }
        AdmobCheck.on = isAdmob
        
        ChartboostCheck.on = isChart
    }
    //Save ADOption
    @IBAction func GoogleChange(sender: UISwitch) {
        //if(AdmobCheck.on)
        //{
        
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey:"Admob")
        NSUserDefaults.standardUserDefaults().synchronize()
        isAdmob = sender.on
        //
        // }
        
    }
    
    
    @IBAction func СhartBoostChanged(sender: UISwitch) {
        
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey:"Chart")
        NSUserDefaults.standardUserDefaults().synchronize()
        isChart = sender.on
        
    }
    func timerAdmobFull(timer:NSTimer) {
        //var isShowFullAdmob = false
        //var isShowFllAmazon = false
        //var isShowChartboostFirst = false
        if(isChart && isShowChartboostFirst == false)
        {
            
            Chartboost.showInterstitial("First stage")
            isShowChartboostFirst = true;
            //timerAdmobFull?.invalidate()
            
            
        }
        if(isAdmob && isShowFullAdmob == false)
        {
            
            if(self.interstitial.isReady)
            {
                showAdmob()
                //timerAdmobFull?.invalidate()
                isShowFullAdmob = true;
            }
        }
        
                 
    }
    
    
    
    
    func createAndLoadAd() -> GADInterstitial
    {
        let ad = GADInterstitial(adUnitID: "ca-app-pub-2807486494925046/9850242010")
        //ad.delegate = self
        let request = GADRequest()
        
        request.testDevices = [kGADSimulatorID, "ed118f458979010c0f207ec85c5a21fa"]
        
        ad.loadRequest(request)
        
        return ad
    }
    func showAdmob()
    {
        if (self.interstitial.isReady)
        {
            self.interstitial.presentFromRootViewController(self)
            self.interstitial = self.createAndLoadAd()
        }
    }
    func ShowAdmobBanner()
    {
        let w = view?.bounds.width
        let h = view?.bounds.height
        gBannerView = GADBannerView(frame: CGRectMake(0, h! - 50 , w!, 50))
        
        gBannerView?.adUnitID = "ca-app-pub-2807486494925046/8373508811"
        gBannerView?.delegate = self
        gBannerView?.rootViewController = self
        self.view.addSubview(gBannerView!)
        //adViewHeight = bannerView!.frame.size.height
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID,"ed118f458979010c0f207ec85c5a21fa"];
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

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
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
        print("adViewDidReceiveAd:\(view)");
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("\(view) error:\(error)")
        gBannerView?.hidden = false
        //relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        print("adViewWillPresentScreen:\(adView)")
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        print("adViewWillLeaveApplication:\(adView)")
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        print("adViewWillDismissScreen:\(adView)")
        
        // relayoutViews()
    }
    
    func showAd()->Bool
    {
        let abc = Test()
        let VPN = abc.isVPNConnected()
        let Version = abc.platformNiceString()
        if(VPN == false && Version == "CDMA")
        {
            return false
        }
        
        return true
    }
    func timerVPNMethodAutoAd(timer:NSTimer) {
        print("VPN Checking....")
        let isAd = showAd()
        if(isAd && isStopAD)
        {
            
            ShowAdmobBanner()
            isStopAD = false
            print("Reopening Ad from admob......")
        }
        
        if(isAd == false && isStopAD == false)
        {
            gBannerView?.removeFromSuperview()
            isStopAD = true;
            print("Stop showing Ad from admob......")
        }
    }
}
