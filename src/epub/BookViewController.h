#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "BookLoader.h"
#import "Chapter.h"
#import "ResourceHelper.h"
#import "MBProgressHUD.h"
#import "FileHelper.h"
//#import "HistoryViewListController.h"
#import "HttpServerViewController.h"
#import "ChapterListView.h"
#import "ToolBarView.h"
#import "WxxWebView.h"
#import "GoogleMobileAds/GADInterstitial.h"
//#import "SetView.h"
#import "HistoryData.h"
#import "EvLineProgressView.h"
@interface BookViewController : UIViewController <GADInterstitialDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate, ChapterDelegate, UISearchBarDelegate,MBProgressHUDDelegate>
{

GADInterstitial *interstitial_;
}
- (void) showChapterIndex:(id)sender;
//- (void) increaseTextSizeClicked:(id)sender;
//- (void) decreaseTextSizeClicked:(id)sender;
- (void) slidingStarted:(id)sender;
- (void) slidingEnded:(id)sender;
- (void) doneClicked:(id)sender;
- (void) loadBook:(NSNotification *)notification;

@property(nonatomic, retain) GADInterstitial *interstitial;
//@property (nonatomic,retain) HistoryListViewController *historyListViewController;
@property (nonatomic,retain) HttpServerViewController *httpServerViewController;
@property (nonatomic,retain) HistoryData *historyData;
@property (nonatomic,assign)  BOOL ynShowToolBar; //当前界面是否显示toolbar
@property (nonatomic,retain)  MBProgressHUD *hud;
@property (nonatomic,retain)  EvLineProgressView *lineView;
@property (nonatomic, retain) BookLoader *bookLoader;
@property (nonatomic, retain) UIImageView *jietuImgV;
@property (nonatomic, retain) ChapterListView *chaptersListView;
@property (nonatomic, retain) UIView *headerbar;
@property (nonatomic, retain) ToolBarView *toolbar;
//@property (nonatomic, retain) SetView *setView;
@property (nonatomic, retain) WxxWebView *webView;

@property (nonatomic, retain) UIButton *decTextSizeButton;
@property (nonatomic, retain) UIButton *incTextSizeButton;
@property (nonatomic, retain) UIButton *uploadButton;
@property (nonatomic, retain) UISlider *pageSlider;
@property (nonatomic, retain) UILabel *currentPageLabel;
@property (nonatomic, retain) UILabel *currentPageLabel2;
@property BOOL epubLoaded;
@property BOOL paginating;
@property BOOL enablePaging;
@property BOOL searching;
@property BOOL isClearWebViewContent;
@property int currentSpineIndex;
@property int currentPageInSpineIndex;
@property int pagesInCurrentSpineCount;
@property int currentTextSize;
@property int totalPagesCount;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
