//
//  MobileCore.h
//  TestReports
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @enum MCLogType
 @abstract used in framework initialization.
 @discussion 'DEBUG' logs everything just like NSLog, 'PRODUCTION' supresses logging.
 */
typedef enum {
    DEBUG_LOG_LEVEL,
    PRODUCTION_LOG_LEVEL,
} MCLogType;

/*!
 @enum AdUnits
 @abstract used in framework initialization to specify ad units used in current app
 */
typedef enum {
    AD_UNIT_ALL_UNITS,
    AD_UNIT_INTERSTITIAL,
    AD_UNIT_DIRECT_TO_APP_STORE,
    AD_UNIT_STICKEEZ
} MCAdUnits;

/*!
 @enum MCAdUnitEventType
 @abstract event received from ad units when their state is changed
 @discussion can be used to customize app logic based on ads state
 */
typedef enum {
    AD_UNIT_READY,
    AD_UNIT_NOT_READY,
    AD_UNIT_DISMISSED
} MCAdUnitEventType;

/*!
 @enum MCInterstitialResponseType
 @abstract events received from Interstitial ad unit
 @discussion can be used to receive events from ad units or their states
 */
typedef enum {
    INTERSTITIAL_NOT_READY,
    INTERSTITIAL_ALREADY_SHOWING,
    INTERSTITIAL_QUIT,
    INTERSTITIAL_NO_CONNECTION,
    INTERSTITIAL_SHOW_ERROR
} MCInterstitialResponseType;

/*!
 @enum MCStickeezPosition
 @abstract supported standard positions for Stickeez ad unit
 */
typedef enum {
    BOTTOM_LEFT,
    BOTTOM_RIGHT,
    TOP_LEFT,
    TOP_RIGHT,
    MIDDLE_LEFT,
    MIDDLE_RIGHT
} MCStickeezPosition;


/*!
 @protocol MCAdUnitEventDelegate
 @abstract used to get ad units events (see MCAdUnitEventType enum)
 @discussion uses MCAdUnitEventType enum to pass different ad unit events to the app.
 */

@protocol MCAdUnitEventDelegate <NSObject>

- (void)didReceiveEvent:(MCAdUnitEventType)event fromAdUnit:(MCAdUnits)adUnit;

@end


/*!
 @protocol MobileCoreDelegate
 @abstract used to get callbacks from framework
 @discussion uses MCInterstitialResponseType enum to pass different types of events to the app.
 */
@protocol MobileCoreDelegate <NSObject>

- (void)handleMobileCoreDelegateResponse:(MCInterstitialResponseType)type;

@end


@interface MobileCore : NSObject

/*!
 @property delegate
 @abstract a reference to MobileCoreDelegate
 */
@property (nonatomic, weak) id <MobileCoreDelegate> delegate;


/*!
 @property adUnitEventsDelegate
 @abstract a reference to MCAdUnitEventDelegate
 */
@property (nonatomic, weak, readwrite) id <MCAdUnitEventDelegate> adUnitEventsDelegate;


/*!
 @method initWithToken:logLevel:adUnits
 @abstract framework initialization.
 @param token is a unique developer key.
 @param logLevel represents logging mode (see 'MCLogType' enum).
 @param 'adUnits' contains ad units you need to use (currently possible values are 'AD_UNIT_ALL_UNITS', 'AD_UNIT_INTERSTITIAL', 'AD_UNIT_DIRECT_TO_APP_STORE', 'AD_UNIT_STICKEEZ', see AdUnits enum)
 */
+ (void)initWithToken:(NSString *)token logLevel:(MCLogType)logLevel adUnits:(NSArray*)adUnits;


/*!
 @method sharedInstance
 @abstract singleton initialization method
 @result returns shared instance of framework api
 */
+ (MobileCore *)sharedInstance;


/*!
@method isInterstitialReady
@abstract checks if interstitial ad unit has loaded its data and is ready to show ads
@result returns true if interstitial is ready, otherwise returns false
*/
+ (BOOL)isInterstitialReady;


/*!
 @method isDirectToAppStoreReady
 @abstract checks if DirectToAppStore ad unit has loaded its data and is ready to redirect to the AppStore
 @result returns true if DirectToAppStore is ready, otherwise returns false
 */
+ (BOOL)isDirectToAppStoreReady;


/*!
 @method setDelegateForAdUnitEvent:
 @abstract assigns a delegate class to respond to MobileCore ad units events (see MCAdUnitEventType enum)
 */
+ (void)setDelegateForAdUnitEvents:(id<MCAdUnitEventDelegate>)delegate;


/*!
 @method notifyAdUnit:withEvent:
 @abstract if there is a delegate for MCAdUnitEventDelegate events, a specified event will be passed to current delegate
 */
+ (void)notifyAdUnit:(MCAdUnits)adUnit withEvent:(MCAdUnitEventType)eventType;


/*!
 @method showInterstitialFromViewController:delegate:
 @abstract shows interstitial ad unit if it's ready.
 @param viewController is used by interstital ad unit class as a parent element in views hierarchy.
 @param delegate is a class supposed to handle events from interstitial ad units.
 @discussion delegate is a class supposed to handle events from interstitial ad units.
 */
+ (void)showInterstitialFromViewController:(UIViewController*)viewController delegate:(id<MobileCoreDelegate>)delegate;


/*!
 @method goToAppStoreFromViewController
 @abstract opens AppStore app
 @param viewController is reserved for future use
 */
+ (void)goToAppStoreFromViewController:(UIViewController*)viewController;


/*!
 @method setStickeezPosition:
 @abstract sets one of standard positions to stickeez ad unit
 @param position see MCStickeezPosition enum for supported values
 */
+ (void)setStickeezPosition:(MCStickeezPosition)position;


/*!
 @method setStickeezPositionBelowView:inViewController:
 @abstract sets position of stickeez ad unit relative to particular view
 @param view to be used as an anchor for stickeez ad unit
 @param viewController is a container of view
 */
+ (void)setStickeezPositionBelowView:(UIView*)view inViewController:(UIViewController*)viewController;


/*!
 @method showStickeeFromViewController:
 @abstract show stickee inside particular view controller
 */
+ (void)showStickeeFromViewController:(UIViewController*)viewController;


/*!
 @method hideStickee
 @abstract hide current stickee
 */
+ (void)hideStickee;


/*!
 @method isStickeeReady
 @abstract check if stickee ready to be shown
 */
+ (BOOL)isStickeeReady;


/*!
 @method isStickeeShowing
 @abstract check if stickee is currently visible and has an appropriate state
 */
+ (BOOL)isStickeeShowing;


/*!
 @method isStickeeShowingOffers
 @abstract check if stickee is currently showing some offers
 */
+ (BOOL)isStickeeShowingOffers;


/*!
 @property token
 @abstract unique developer key
 @discussion used for ads stats
 */
@property (nonatomic, strong) NSString *token;

@end
