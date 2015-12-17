#import <UIKit/UIKit.h>
#import "BookViewController.h"
#import "GoogleMobileAds/GADBannerView.h"
#import "HttpServerViewController.h"
#import "RootViewController.h"
@interface BooksListViewController : RootViewController<GADBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    GADBannerView *bannerView_;
}

//@property (nonatomic,retain) HttpServerViewController *httpServerViewController;
@property(nonatomic,retain) NSMutableArray *booksArr;
@property(nonatomic,retain) NSIndexPath *selectedIndexPath;
@property(nonatomic,assign) BooksListSelectType blType;
-(void)loadBooks;

@end