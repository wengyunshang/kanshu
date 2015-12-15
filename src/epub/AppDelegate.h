#import <UIKit/UIKit.h>
//#import "HTTPServer.h"
#import "ZYTabViewController.h"
#import "SettingsViewController.h"
#import "BookViewController.h"
#import "ChaptersListViewController.h"
#import "BooksListViewController.h"
#import "StoreViewController.h"
#import "StoreClassViewController.h"
#import "GoogleMobileAds/GADInterstitial.h"
#import "BookData.h"
#import "WebStoreViewController.h"
#import "IpadBookListViewController.h"
#import "HttpServerViewController.h"

typedef enum{
    logoView, //界面还处于logo状态， logo未隐藏, 说明是网络还没链接正常
    
}viewStatusType;
@class EPUBParser;
@class Reachability;
@interface AppDelegate : NSObject <UIApplicationDelegate,GADInterstitialDelegate>{
GADInterstitial *splashInterstitial_;
}
@property(nonatomic, readonly) NSString *interstitialAdUnitID;
-(GADInterstitial*)getGad;

@property (strong, nonatomic) EPUBParser *epubParser; //epub解析器，成员变量或全局
@property (nonatomic, assign)viewStatusType viewStatus; //当前界面状态
@property (nonatomic,retain) HttpServerViewController *httpServerViewController;
@property (nonatomic, retain) Reachability *status;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *detailViewController;
@property (nonatomic, retain) UINavigationController *leftVC;
@property (nonatomic, retain) IpadBookListViewController *ipadBLViewController;
@property (nonatomic, retain) BookViewController *bookViewController;
@property (nonatomic, retain) ZYTabViewController *leftViewController;
@property (nonatomic, retain) UIViewController *rightViewController;
@property (nonatomic, retain) ChaptersListViewController *chaptersListViewController;
@property (nonatomic, retain) WebStoreViewController *webStoreVC;
@property (nonatomic, retain) BooksListViewController *booksListViewController;
@property (nonatomic, retain) StoreViewController *storeViewController;
@property (nonatomic, retain) StoreClassViewController *storeClassVC;
@property (nonatomic, retain) SettingsViewController *settingViewController;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) BookData *bookdata;
@property (nonatomic) int selectedChapter;

@property (nonatomic) int slideWidth;

@end
