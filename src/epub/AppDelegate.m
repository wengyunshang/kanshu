#import "AppDelegate.h"
#import "AppData.h"
#import <QuartzCore/QuartzCore.h>
#import "BookViewController.h"
#import "ResourceHelper.h"
#import "MessageHelper.h"
#import "ResourceHelper.h"
#import "iRate.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "InAppPurchaseManager.h"
#import "MobClick.h"
#import "WxxAdView.h"
#import "UMessage.h"
#import "WxxAlertView.h"
#import "WxxBookSelect.h"
#import "BookFeedBackViewController.h"
#import "UMFeedbackViewController.h"
#import "BookLogoView.h"
#import "SVHTTPRequest.h"
#import "BigClassData.h"
#import "AFKReviewTroller.h"
#import "ClassData.h"
#import "BookData.h"
#import "StoreClassViewController.h"
#import "Reachability.h"
#import "BookDeleteView.h"
#if __QQAPI_ENABLE__
#import "TencentOpenAPI/QQApiInterface.h"
#import "QQAPIDemoEntry.h"
#endif
#import "EvRoundProgressView.h"
//第三方平台的SDK头文件，根据需要的平台导入。
//以下分别对应微信、新浪微博、腾讯微博、人人、易信
//#import "WXApi.h"
//以下是腾讯QQ和QQ空间
//开启QQ和Facebook网页授权需要
//ipad
#import "IpadBookListViewController.h"

@implementation AppDelegate
@synthesize leftVC;
@synthesize window, detailViewController,leftViewController,rightViewController,mainView,bookdata,slideWidth,selectedChapter;
@synthesize chaptersListViewController,booksListViewController,storeViewController,settingViewController;
@synthesize bookViewController;
@synthesize httpServerViewController;
#pragma mark -
#pragma mark Application lifecycle
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/**************************广告***********************/
-(BOOL)setNetStatus{
    return YES;
//
//    self.status = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    BOOL ynnet = NO;
//    switch ([self.status currentReachabilityStatus]) {
//        case NotReachable:
//            // 没有网络连接
////            self.netstatus.text = @"没有网络连接";
//            ynnet = NO;
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
////            self.netstatus.text = @"使用3G网络";
//            ynnet = YES;
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
////            self.netstatus.text = @"使用WiFi网络";
//            ynnet = YES;
//            break;
//        default:
//            ynnet = NO;
//            break;
//    }
//    return ynnet;
}
/*
 *判断是否通过wifi
 */
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
/*
 *判断是否通过3G
 */
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


-(void)fonename{
    
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    
    NSArray *fontNames;
    
    NSInteger indFamily, indFont;
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
//            NSLog(@"    Font name: %@",[fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
}

-(void)initUmeng{
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:SEND_INTERVAL   channelId:@"Web"];
}

// Returns the interstitial ad unit ID. In a real-world app each intersitial
// placement would have a distinct unit ID.
- (NSString *)interstitialAdUnitID {
    NSLog(@"%@",admobPageId);
    return admobPageId;
}
#pragma mark GADRequest generation


-(GADInterstitial*)getGad{
    return splashInterstitial_;
}
-(void)initAdmobPage{
    
    GADRequest *request = [GADRequest request];
    
    splashInterstitial_ = [[GADInterstitial alloc] initWithAdUnitID:self.interstitialAdUnitID];
    splashInterstitial_.delegate = self;
    [splashInterstitial_ loadRequest:request];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [NSThread sleepForTimeInterval:1];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
     [AFKReviewTroller load];
    //前提条件
//    _epubParser=[[EPUBParser alloc] init];
    [MobClick checkUpdate];
    [self initUmeng]; 
    [self initUmengPush:launchOptions];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.selectedChapter = -1;
 
    
    //************************设置图片路径*****************************//
    [ResourceHelper setUserDefaults:@"default" forKey:@"theme"];
     //************************下载分类信息，包涵图片和文件的前缀************************//
    /*
     *
     *           必须保持本步骤正确，否则后续图片和文件下载都会出错
     *
     */
    //**************************注册本地电子书**************************//
    [WxxBookSelect installBook];
    //存在网络
    if ([self setNetStatus]) {
    
        [_status release];
        _status = nil;
        //更新分类
        [self getClassINfo];
    }
    [self getBigClassId];
    
    //********检查新书*************//
//    [self getNewbookList];
    
    [self getAppinfo];
    
    /**
     *
     *
     */
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    
    if (false) {
    } else {
        self.slideWidth = UIBounds.size.width;
     
        self.mainView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        self.mainView.backgroundColor = [UIColor whiteColor];
        self.mainView.layer.masksToBounds = YES;
        self.mainView.layer.cornerRadius = 2;
        UIViewController *temVC = [[[UIViewController alloc]init] autorelease];
        self.window.rootViewController = temVC;
        NSLog(@"%f---%f---%f---%f",self.mainView.frame.size.width,self.mainView.frame.size.height,self.mainView.frame.origin.x,self.mainView.frame.origin.y);
        [self.window.rootViewController.view addSubview:mainView];
        
        [self iphoneInit];
    }
    
    //HTTP SERVER
    
    
//    [self.window addSubview:[WxxAdView sharedInstance]];    //广告view注册
    [[WxxAdView sharedInstance]sendDeveceInfo2Server];
//    [self.window addSubview:[WxxAlertView sharedInstance]]; //alertView注册
//    [self.window addSubview:[StoreBookInfoView sharedInstance]]; //书本详情页
    [self.window.rootViewController.view addSubview:[BookLogoView sharedInstance]];
//    [self.window addSubview:[WxxLoginView sharedInstance]];
    [self.window.rootViewController.view addSubview:[WxxLoadView sharedInstance]];
    [self.window.rootViewController.view addSubview:[WxxPopView sharedInstance]];
    //在没有网络的情况下也可以进入，但是如果不存在分类就要提示了，不让进去.
    if ([[ClassData sharedClassData]ynHaveClass]) {
        [[BookLogoView sharedInstance]performSelectorHideSelf];
    }else{//如果本地没有分类，需要继续下载，否则链接全部失效
        [self getClassINfo];
    }
//    [[WxxPopView sharedInstance] showPopText:@"你已成功删除一本书"];
//    [[WxxLoadView sharedInstance]showself];
//
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height)];
//    v.backgroundColor = [UIColor grayColor];
//    [self.window addSubview:v];
//    
//    EvRoundProgressView *eve = [[EvRoundProgressView alloc]initWithlogoFrame:<#(CGRect)#>];
//    [v addSubview:eve];
    [self.window makeKeyAndVisible];
    
     
//    [self showDeleteView];
    return YES;
}

-(void)showDeleteView{
    
    BookDeleteView *delView = [[BookDeleteView alloc]initWithFrame:CGRectMake(0, UIBounds.size.height-50, UIBounds.size.width, 50)];
    [self.window.rootViewController.view addSubview:delView];
}

-(void)getBigClassId{

    //获取分类信息
    [SVHTTPRequest GET:[WXXHTTPUTIL getBigClassList]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        bigClassValue,@"father_id",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                if (errors) {
                    return;
                }
                if (response) {
                    
                    for (int i=0; i<[response count]; i++) {
                        BigClassData *classData =[BigClassData initWithDictionary:[response objectAtIndex:i]];
                        [classData saveSelfToDB];
                    }
                    
                }else{
                    
                }
            }];
}


-(void)getClassINfo{
    
    //获取分类信息
    [SVHTTPRequest GET:[WXXHTTPUTIL getClassList]
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                if (errors) {
                    return;
                }
                if (response) {
//                    NSLog(@"%@",response);
                    if ([response count]<=0) {
                        [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"loadNilBook", nil)];
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:NSLocalizedString(@"loadNilBook", nil)];
                    }else{
//                        [[WxxAlertView sharedInstance]hidden];
                    }
                    for (int i=0; i<[response count]; i++) {
                        ClassData *classData =[ClassData initWithDictionary:[response objectAtIndex:i]];
                        [classData saveSelfToDB];
                    }
                    //分类下载完毕，把logo界面隐藏掉,进入主界面，
                    [[BookLogoView sharedInstance]hideSelf];
                }else{
                    //分类下载错误的情况下： 如果本地存在分类，也隐藏logo,
                    if ([[ClassData sharedClassData]ynHaveClass]) {
                        [[BookLogoView sharedInstance]hideSelf];
                    }else{//如果本地没有分类，需要继续下载，否则链接全部失效
//                        [self getClassINfo];
                    }
                }
            }];
}
//根据 saiyuappid 获取app 信息
-(void)getAppinfo{
    [SVHTTPRequest GET:[WXXHTTPUTIL getAppBaseInfo]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        saiyuappid,@"id",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                if (errors) {
                    return;
                }
                if (response) {
                    [[AppData sharedAppData]setWithDictionary:response];
                }
            }];
}

//检查是否有新书
-(void)getNewbookList{
//    //查询当前本地最大记录，去服务端取更大记录
//    NSString *maxBookId = [[PenSoundDao sharedPenSoundDao]selectMaxBook_id];
//    if (!maxBookId) {
//        maxBookId = @"0";
//    }
//    [SVHTTPRequest GET:[WXXHTTPUTIL getBookList]
//            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
//                        bookClass,@"class_id",//根据分类查询书籍
//                        maxBookId,@"book_id",nil]
//            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
//                
//                if (response) {
//                   
//                    for (int i=0; i<[response count]; i++) {
//                        BookData *bookData =[BookData initWithDictionary:[response objectAtIndex:i]];
//                        [bookData saveSelfToDB];
//                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashNew" object:nil];
//                }else{ 
//                }
//            }];
}


-(void)iphoneInit{

    //中间
    BookViewController *_bookViewController = [[BookViewController alloc] init];
    self.bookViewController = _bookViewController;
    [_bookViewController release];
    
    UINavigationController *_detailViewController = [[UINavigationController alloc] initWithRootViewController:bookViewController];
    self.detailViewController = _detailViewController;
    [_detailViewController release];
    
    detailViewController.navigationBar.hidden = YES;
    //detailViewController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//设置bar的风格，控制字体颜色
//    [detailViewController.view.layer setShadowColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] CGColor]];
//    [detailViewController.view.layer setShadowOffset:CGSizeMake(0, 0)];
//    [detailViewController.view.layer setShadowOpacity:1.0];
//    [detailViewController.view.layer setShadowRadius:3.0];
//    detailViewController.view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:detailViewController.view.bounds] CGPath];
    
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *items = [NSMutableArray array];
    
    self.booksListViewController = [[[BooksListViewController alloc] init] autorelease];
    self.settingViewController = [[[SettingsViewController alloc]init] autorelease];
//    self.webStoreVC = [[WebStoreViewController alloc] init];
//    [self.webStoreVC loadUrl:@"http://m.qisuu.com/"];
    self.storeClassVC = [[[StoreClassViewController alloc]init] autorelease];
    UINavigationController *_storeViewController = [[UINavigationController alloc] initWithRootViewController:self.storeClassVC];
    UINavigationController *_setViewController = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
    UINavigationController *_booksListViewController = [[UINavigationController alloc] initWithRootViewController:self.booksListViewController];
//    UIImage *backgroundImage = [ResourceHelper loadImageByTheme:@"navigationBarback"];
//    [_storeViewController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    UIImage *backgroundImage2 = [ResourceHelper loadImageByTheme:@"navigationbarBackMybook"];
//    [_booksListViewController.navigationBar setBackgroundImage:backgroundImage2 forBarMetrics:UIBarMetricsDefault];
//    UIImage *backgroundImage3 = [ResourceHelper loadImageByTheme:@"navigationbarBackSet"];
//    [_setViewController.navigationBar setBackgroundImage:backgroundImage3 forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:_booksListViewController];
    [controllers addObject:_storeViewController];
//    [controllers addObject:communityViewController];
    [controllers addObject:_setViewController];
    
    [_storeViewController release];
    [_setViewController release];
    [_booksListViewController release];
//    [booksListViewController release];
//    [settingViewController release];
//    [storeViewController release];
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    
    
    
   
    [item setObject:@"我的书架" forKey:@"text"];
    [item setObject:@"booktab" forKey:@"imageNormal"];
    [item setObject:@"booktab" forKey:@"imageSelected"];
    [item setObject:WXXCOLOR(255, 255, 255, 1) forKey:@"selectColor"];
    [items addObject:item];
    [item release];
    
    item = [[NSMutableDictionary alloc] init];
    [item setObject:@"精品书店" forKey:@"text"];
    [item setObject:@"store" forKey:@"imageNormal"];
    [item setObject:@"store" forKey:@"imageSelected"];
    [item setObject:WXXCOLOR(255, 255, 255, 1) forKey:@"selectColor"];
    [items addObject:item];
    [item release];
    
//    item = [[NSMutableDictionary alloc] init];
//    [item setObject:@"社区" forKey:@"text"];
//    [item setObject:@"commtab" forKey:@"imageNormal"];
//    [item setObject:@"commtab" forKey:@"imageSelected"];
//    [item setObject:WXXCOLOR(255, 255, 255, 1) forKey:@"selectColor"];
//    [items addObject:item];
//    [item release];
    
    item = [[NSMutableDictionary alloc] init];
    [item setObject:@"设置" forKey:@"text"];
    [item setObject:@"settab" forKey:@"imageNormal"];
    [item setObject:WXXCOLOR(255, 255, 255, 1) forKey:@"selectColor"];
    [item setObject:@"settab" forKey:@"imageSelected"];
    [items addObject:item];
    [item release];
    
    self.leftViewController = [[[ZYTabViewController alloc] initWithControllers:controllers tabItems:items bg:[UIColor whiteColor]] autorelease];
    
    CGRect f = leftViewController.view.frame;
    leftViewController.view.frame = CGRectMake(f.origin.x, f.origin.y, slideWidth, f.size.height);
    [leftViewController build];
    [leftViewController selectTab:0];
    
    self.leftVC = [[[UINavigationController alloc] initWithRootViewController:leftViewController] autorelease];
    
    self.leftVC.navigationBar.hidden = YES;
    //阴影
    //    UIView *shadow =[[UIView alloc] initWithFrame:CGRectMake(0, leftViewController.view.bounds.size.height-44, leftViewController.view.bounds.size.width, 10)];
    //    shadow.backgroundColor = [UIColor whiteColor];
    //    [leftViewController.view addSubview:shadow];
    //    [shadow release];
    
    self.rightViewController = [[[SettingsViewController alloc] init] autorelease];
    f = rightViewController.view.frame;
    rightViewController.view.frame = CGRectMake(f.size.width-slideWidth, f.origin.y, slideWidth, f.size.height);
    
    [mainView addSubview:leftVC.view];
    [mainView addSubview:rightViewController.view];
    [mainView addSubview:detailViewController.view];
    
//    self.leftViewController.view.layer.cornerRadius = 3;
//    self.leftViewController.view.layer.masksToBounds = YES;
//    self.rightViewController.view.layer.cornerRadius = 3;
//    self.rightViewController.view.layer.masksToBounds = YES;
//    self.detailViewController.view.layer.cornerRadius = 3;
//    [leftViewController.view.layer setShadowPath:[UIBezierPath bezierPathWithRect:leftViewController.view.bounds].CGPath];
//    [rightViewController.view.layer setShadowPath:[UIBezierPath bezierPathWithRect:rightViewController.view.bounds].CGPath];
//    [detailViewController.view.layer setShadowPath:[UIBezierPath bezierPathWithRect:detailViewController.view.bounds].CGPath];
    
//    CGAffineTransform newTransform =  CGAffineTransformScale(leftViewController.view.transform, 0.8, 0.8);
//    [leftViewController.view setTransform:newTransform];
//    
//    CGAffineTransform newTransform1 =  CGAffineTransformScale(rightViewController.view.transform, 0.8, 0.8);
//    [rightViewController.view setTransform:newTransform1];
    
    //    [iRate sharedInstance].appStoreID = APP_ID;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChapters:) name:@"showChapters" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBooks:) name:@"showBooks" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:@"showSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFeedback:) name:@"showFeedback" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashStoreClass) name:@"reflashStoreClass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFeedBackViewController:) name:@"showFeedBackViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startHttpServer) name:@"startHttpServer" object:nil];
    
    if([[[mainView subviews] objectAtIndex:0] isEqual:self.leftVC.view]){
        [mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    f = detailViewController.view.frame;
    detailViewController.view.frame = CGRectMake(f.origin.x+slideWidth, f.origin.y, f.size.width, f.size.height);
    
    
    
    
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}



-(void)startHttpServer{
    [MobClick event:@"uploadbefor"];
    if (!self.httpServerViewController) {
        self.httpServerViewController = [[[HttpServerViewController alloc] init] autorelease];
//        [self.window.rootViewController.view addSubview:httpServerViewController.view];
        [self.window.rootViewController.view insertSubview:self.httpServerViewController.view belowSubview:[WxxPopView sharedInstance]];
        httpServerViewController.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    }
    
    [httpServerViewController startServer];
}

-(void)reflashStoreClass{
    [self.storeClassVC getDataList];
}

-(void)showFeedBackViewController:(NSNotification *)notification{
    BookData *bookdatalocal = [notification object];
    BookFeedBackViewController *about = [[BookFeedBackViewController alloc]init];
    [about setBookData:bookdatalocal];
//    UINavigationController *bookfeddbacknv = [[UINavigationController alloc] initWithRootViewController:about];
    

    [self.leftVC pushViewController:about animated:YES];
    [about release];
//    [bookfeddbacknv release];
}

- (void)showFeedback:(NSNotification *)notification{
    [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.translucent = NO;
    [self.leftVC presentViewController:navigationController animated:YES completion:^{
        
    }];
    [feedbackViewController release];
    [navigationController release];
}



-(void)loadBook{
    if(self.bookdata!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBook" object:self.bookdata];
    }
}



-(void)loadChapter{
    if(self.selectedChapter!=-1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadChapter" object:[NSString stringWithFormat:@"%d",selectedChapter]];
    }
}

-(void)showChapters:(NSNotification *)notification{
//    NSLog(@"show chapters");
    id chapter = [notification object];
    if(chapter!=nil){
        self.selectedChapter = ((NSIndexPath *)chapter).row;
    }else{
        self.selectedChapter = -1;
    }
    
    if([[[mainView subviews] objectAtIndex:0] isEqual:self.leftVC.view]){
        [mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    CGRect f = detailViewController.view.frame;
        
    
    if (chapter == nil) {
        if(f.origin.x == 0){
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(loadChapter)];
            [UIView setAnimationDuration:0.5];
            detailViewController.view.frame = CGRectMake(f.origin.x+slideWidth, f.origin.y, f.size.width, f.size.height);
//            CGAffineTransform newTransform =  CGAffineTransformScale(leftViewController.view.transform, 1.25, 1.25);
//            [leftViewController.view setTransform:newTransform];
            [UIView commitAnimations];
        }else{
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(loadChapter)];
            [UIView setAnimationDuration:0.5];
            detailViewController.view.frame = CGRectMake(f.origin.x-slideWidth, f.origin.y, f.size.width, f.size.height);
//            CGAffineTransform newTransform =  CGAffineTransformScale(leftViewController.view.transform, 0.8, 0.8);
//            [leftViewController.view setTransform:newTransform];
             [UIView commitAnimations];
        }
    }else{
        [self loadChapter];
    }
    
   
    
//    [chaptersListViewController loadChapters];
    [booksListViewController loadBooks];
}

-(void)showBooks:(NSNotification *)notification{
    BookData *bookd = (BookData *)[notification object];
    if(bookd!=nil){
        self.bookdata = bookd;
    }else{
        self.bookdata = nil;
    }
    
    if([[[mainView subviews] objectAtIndex:0] isEqual:self.leftVC.view]){
        [mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    CGRect f = detailViewController.view.frame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadBook)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    if(f.origin.x == 0){
        detailViewController.view.frame = CGRectMake(f.origin.x+slideWidth, f.origin.y, f.size.width, f.size.height);
//        CGAffineTransform newTransform =  CGAffineTransformScale(leftViewController.view.transform, 1.25, 1.25);
//        [leftViewController.view setTransform:newTransform];
    }else{
        detailViewController.view.frame = CGRectMake(f.origin.x-slideWidth, f.origin.y, f.size.width, f.size.height);
//        CGAffineTransform newTransform =  CGAffineTransformScale(leftViewController.view.transform, 0.8, 0.8);
//        [leftViewController.view setTransform:newTransform];
    }
    [UIView commitAnimations];
    
}

-(void)showSettings:(NSNotification *)notification{
    if([[[mainView subviews] objectAtIndex:0] isEqual:self.rightViewController.view]){
        [mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    CGRect f = detailViewController.view.frame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    if(f.origin.x == 0){
        detailViewController.view.frame = CGRectMake(f.origin.x-slideWidth, f.origin.y, f.size.width, f.size.height);
//        CGAffineTransform newTransform =  CGAffineTransformScale(rightViewController.view.transform, 1.25, 1.25);
//        [rightViewController.view setTransform:newTransform];
        
    }else{
        detailViewController.view.frame = CGRectMake(f.origin.x+slideWidth, f.origin.y, f.size.width, f.size.height);
//        CGAffineTransform newTransform =  CGAffineTransformScale(rightViewController.view.transform, 0.8, 0.8);
//        [rightViewController.view setTransform:newTransform];
        
    }
    [UIView commitAnimations];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
    }
}



- (void)versionFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"check version err:%@",request.error);
    [request cancel];
    [request release];
}
//获取本地就数据的更新信息（可能价格修改）
-(void)updateBookList{
    NSString *lastupdate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastupdate"];
    if (!lastupdate) {
        [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
        return;
    }
    //和当前时间对比，返回分
    int i = [WXXHTTPUTIL intervalSinceNow:lastupdate];
    //最后更新时间和现在差24小时就更新（每天更新一次），这样做是为了避免客户端过多的请求服务端
    if(i/60 > 24){
        NSString *maxBookId = [[PenSoundDao sharedPenSoundDao]selectMaxBook_id:bookClass];
        if (!maxBookId) {
            maxBookId = @"0";
        }
        //三个参数： 分类id, 本地最大book_id(获取更新的信息只能比最大id小， 大的则是新的数据), 最后更新时间（获取比最后时间大的更新数据）
        [SVHTTPRequest GET:[WXXHTTPUTIL getBookListByUpdate]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        bookClass,@"class_id",
                        lastupdate,@"last_update",
                        maxBookId,@"book_id",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                if (response) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
                    
                    if ([response count]>0) {
                        for (int i=0; i<[response count]; i++) {
                            BookData *bookData =[BookData initWithDictionary:[response objectAtIndex:i]];
                            [bookData updateBookDataByServer];
                        }
                    }
                }
            }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
//    NSLog(@"check version");
    if (self.viewStatus == logoView) {
        if ([self setNetStatus]) {
            
            [_status release];
            _status = nil;
            //更新分类
            [self getClassINfo];
            
            //********检查新书*************//
            [self getNewbookList];
            
        }else{
            
            //在没有网络的情况下也可以进入，但是如果不存在分类就要提示了，不让进去.
            if ([[ClassData sharedClassData]ynHaveClass]) {
                [[BookLogoView sharedInstance]hideSelf];
            }else{//如果本地没有分类，需要继续下载，否则链接全部失效
                self.viewStatus = logoView;
                showAlert(@"噹",@"我发现你还没链接网络啊, 客官。");
            }
        }
    }
    //刷新书籍信息
    [self updateBookList];
    //[[[InAppPurchaseManager alloc] init] loadStore];
//    [self checkEdition];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
    NSLog(@"后台换气");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSLog(@"-----%@",pushToken);
     [UMessage registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
     [UMessage didReceiveRemoteNotification:userInfo];
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
//    return UIInterfaceOrientationIsLandscape( interfaceOrientation ); // 横屏
    
   return UIInterfaceOrientationIsPortrait( interfaceOrientation ); // 竖屏
    
}

- (void)dealloc {
    splashInterstitial_.delegate = nil;
    [splashInterstitial_ release];
    [leftVC release];
    [window release];
    [rightViewController release];
    rightViewController = nil;
    [detailViewController release];
    [settingViewController release];
    self.httpServerViewController = nil;
    if (bookdata) {
    [bookdata release];
    }
 
    [super dealloc];
}



- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
   
    NSString *filePath = [url relativePath];
    if([[filePath pathExtension] isEqualToString:@"epub"]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, [filePath lastPathComponent]];
        
        if ([fileManager copyItemAtPath:filePath toPath:toPath error:nil] == NO){
            //            NSLog(@"no");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBook" object:toPath];
    }
    
    
#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAPIDemoEntry class]];
#endif
    
   
    return YES;
}

-(void)initUmengPush:(NSDictionary *)launchOptions{
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    
    //register remoteNotification types
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
    //register remoteNotification types （iOS 8.0及其以上版本）
    //    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    //    action1.identifier = @"action1_identifier";
    //    action1.title=@"Accept";
    //    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //
    //    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    //    action2.identifier = @"action2_identifier";
    //    action2.title=@"Reject";
    //    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    //    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    //    action2.destructive = YES;
    //
    //    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    //    categorys.identifier = @"category1";//这组动作的唯一标示
    //    [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    //
    //    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
    //                                                                                 categories:[NSSet setWithObject:categorys]];
    //    [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    
    
    //for log（optional）
    [UMessage setLogEnabled:YES];
}

  

@end

