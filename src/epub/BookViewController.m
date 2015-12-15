#import "BookViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"
#import "EPubBookLoader.h"
#import "BlackView.h"
#import "MessageHelper.h"
#import "WxxButton.h"
#import "Constants.h"
#import "WxxAlertView.h"
#import "WxxAdView.h"
#import "SetConfig.h"
#import "BookData.h"
#import "SVHTTPRequest.h"
#import "WxxLabel.h"
#import "AppData.h"
#import "KWPopoverView.h"
#import "AppDelegate.h" 


#define toolbarHeight 50
#define textFontDefault 20


#define textSizeRule @"TextSizeRule"
#define bodyFont @"bodyFont"
#define bodyColor @"bodyColor"
#define bodyFontOrg @"bodyFontOrg"
#define selectTypeKey @"selectType"
@interface BookViewController()
//@property (nonatomic,strong)UIView *statusBarView;
@property (nonatomic,strong)WxxLabel *titleLb;
@property (nonatomic,strong)UIImageView *logoView;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)BookData *bookdata;
@property (nonatomic,retain)NSString *setTextSizeRule;
@property (nonatomic,retain)UIView *backView;
//@property (nonatomic,assign)BOOL ynhaveAdmob; //广告是否加载完成
@property (nonatomic,assign)BOOL ynClickAdmob;//是否点击了广告

@property (nonatomic,assign)BOOL ynShowTool;//是否有工具栏显示

- (void) gotoNextSpine;
- (void) gotoPrevSpine;
- (void) gotoNextPage;
- (void) gotoPrevPage;
- (int)  getGlobalPageCount;
- (void) gotoPageInCurrentSpine: (int)pageIndex;
- (void) updatePagination;
- (void) toLastReadPage;
- (void) recordLastReadPage;

@end
#define webOrgX 8
@implementation BookViewController
@synthesize jietuImgV;
//@synthesize historyListViewController;
@synthesize httpServerViewController;
@synthesize bookLoader;
@synthesize backView;
@synthesize headerbar;
@synthesize toolbar;
@synthesize webView;

@synthesize decTextSizeButton;
@synthesize incTextSizeButton;
@synthesize uploadButton;
@synthesize pageSlider;
@synthesize currentPageLabel;
@synthesize currentPageLabel2;
@synthesize epubLoaded;
@synthesize paginating;
@synthesize enablePaging;
@synthesize searching;
@synthesize currentSpineIndex;
@synthesize currentPageInSpineIndex;
@synthesize pagesInCurrentSpineCount;
@synthesize currentTextSize;
@synthesize totalPagesCount;
@synthesize hud;
@synthesize isClearWebViewContent;
@synthesize chaptersListView;
#pragma mark -
-(id)init{
    self = [super init];
    if(self!=nil){
        self.enablePaging = NO;
        self.isClearWebViewContent = NO;
    }
    self.ynClickAdmob = NO;
    self.ynShowTool = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBook:) name:@"loadBook" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChapter:) name:@"loadChapter" object:nil];

    return self;
}


//***************admob************************//
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
//    UIAlertView *alert = [[[UIAlertView alloc]
//                           initWithTitle:@"GADRequestError"
//                           message:[error localizedDescription]
//                           delegate:nil cancelButtonTitle:@"Drat"
//                           otherButtonTitles:nil] autorelease];[alert show];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
    if (!locked && !self.ynClickAdmob) {
        
//        self.ynhaveAdmob = YES;
    }

//    [interstitial presentFromRootViewController:self];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{

//    self.ynhaveAdmob = NO;
    [_interstitial release];
    _interstitial.delegate = nil;
    _interstitial = nil;
    [self showInterstitial:nil];
}
- (IBAction)showInterstitial:(id)sender {
    
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    GADRequest *request = [GADRequest request];
//    self.ynhaveAdmob = NO;
    self.interstitial.delegate = self;
    self.interstitial = [[[GADInterstitial alloc] initWithAdUnitID:appDelegate.interstitialAdUnitID] autorelease];
    [self.interstitial loadRequest:request];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    self.ynClickAdmob = YES;
    NSLog(@"%@",@"离开");
}
//***************admob************************//



- (void) loadChapter:(NSNotification *)notification{
    [self hideToolbar];
    self.ynShowTool = NO;
    NSString *chapter = (NSString *)[notification object];
    [self loadSpine:[chapter intValue] atPageIndex:0];
    [self recordLastReadPage];
    [self toLastReadPage];
}

- (void) loadBook:(NSNotification *)notification{

    
    self.ynClickAdmob = NO;//每次新打开书就把点击设置为NO
    [currentPageLabel setText:@"0/0"];
//    if (booktype == BTjingdu) {
//        [self loadbaiduAd];
//    }else{
        [self showInterstitial:nil];
//    }
    self.bookdata = [notification object];
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    
    self.isClearWebViewContent = YES;
    [webView loadHTMLString:NSLocalizedString(@"loading data", nil) baseURL:nil];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = NSLocalizedString(@"loading page", nil);
    [hud show:NO];
    
    [self hideToolbar];
    [NSThread detachNewThreadSelector:@selector(start:) toTarget:self withObject:self.bookdata.bbook_file];
   
}

-(void)start:(NSString *)path{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
//    if ([path length]<=0) {
//        NSLog(@"adfasd");
//    }
//    NSLog(@"--%@--",path);
    
    [hud hide:NO];
    
    self.bookLoader = [[[EPubBookLoader alloc] initWithPath:path] autorelease];
    
    if(bookLoader.error == 1){
        [webView loadHTMLString:NSLocalizedString(@"parse_error", nil) baseURL:nil];
        
        //报错按钮
        int errwidth = 120;
        int errheight = 35;
        WxxButton *btn = [[WxxButton alloc]initWithFrame:CGRectMake((UIBounds.size.width-errwidth)/2, 150, errwidth, errheight)];
//        item_bg_selected@2x
        [btn setBackgroundColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]]];
        [btn setTitle:@"提交错误报告" forState:UIControlStateNormal];
        [btn setTitle:@"提交完成" forState:UIControlStateSelected];
        [self.webView addSubview:btn];
        [btn release];
        
        [btn receiveObject:^(id object) {
            NSLog(@"提交报告");
            [btn removeFromSuperview];
            [webView loadHTMLString:@"提交中..." baseURL:nil];
            //提交
            [self sendErrorToServer];
        }];
        
    }else{
        epubLoaded = YES;
        
        //record history
        NSMutableArray *items = [FileHelper getDataFromFile:@"history"];
        if(items.count < 100){
            NSArray *array = [path componentsSeparatedByString:@"/"];
            
            for(NSDictionary *item in items){
//                NSLog(@"%@",[item objectForKey:@"name"]);
                if([[item objectForKey:@"name"] isEqualToString:[array objectAtIndex:(array.count-1)]]){
                    [FileHelper deleteData:item ofFile:@"history"];
                }
            }
            NSMutableDictionary *book = [[NSMutableDictionary alloc] init];
            [book setObject:[array objectAtIndex:(array.count-1)] forKey:@"name"];
            [book setObject:path forKey:@"path"];
            
            [FileHelper prependData:book toFile:@"history"];
            [book release];
        }
        
        //set last read page parameters
        [self toLastReadPage];
        if(currentSpineIndex > bookLoader.spineArray.count-1){
            currentSpineIndex = 0;
        }
        [self performSelectorOnMainThread:@selector(updatePagination) withObject:nil waitUntilDone:NO];
        [pool release];
    }
}


-(void)sendErrorToServer{

    [SVHTTPRequest GET:[WXXHTTPUTIL sendErrortoServer]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.bookdata.bbook_id,@"book_id",
                        self.bookdata.bbook_name,@"book_name",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                if (response) {
                    
                    
                }
                [webView loadHTMLString:@"提交完毕" baseURL:nil];
            }];
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [bookLoader.spineArray count]){
		[[bookLoader.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[bookLoader.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
		[currentPageLabel setText:[NSString stringWithFormat:@"0/%d", totalPagesCount]];
	} else {
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
		paginating = NO;
//		NSLog(@"Pagination Ended!");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookDidLoaded" object:nil];
	}
}

- (int) getGlobalPageCount{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [(Chapter*)[bookLoader.spineArray objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = NSLocalizedString(@"loading page", nil);
    [hud show:NO];
    [hud release];
    
    
	webView.hidden = YES;
	jietuImgV.hidden = YES;
    
    
    // get the model which is a html file for the webView
    NSString * htmlPath = [[bookLoader.spineArray objectAtIndex:spineIndex] spinePath];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSRange range = [htmlCont rangeOfString:@"</head>"];//获取$file/的位置
    NSMutableAttributedString *ss = [[NSMutableAttributedString alloc]initWithString:htmlCont];
    //注入css,避免有些epub没有加载css文件， 而导致分页不成功
    [ss insertAttributedString:[[NSMutableAttributedString alloc]initWithString:@"<link href=\"../Styles/main.css\" rel=\"stylesheet\" type=\"text/css\" />"] atIndex:range.location];
    

    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
   [webView loadHTMLString:[ss string] baseURL:baseURL];
    
    self.titleLb.text = [[bookLoader.spineArray objectAtIndex:spineIndex] title];
	self.isClearWebViewContent = NO;
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    [ss release];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{
    
    
   
    
    //不分页条件下，上一个章节最后一页
    if(pageIndex == -1){
        pageIndex = pagesInCurrentSpineCount-1;
        currentPageInSpineIndex = pageIndex;
    }
    
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;	
	}
	
	float pageOffset = pageIndex*webView.bounds.size.width;

	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
    
    if(!enablePaging){
            [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",currentPageInSpineIndex+1, pagesInCurrentSpineCount]];
            [pageSlider setValue:(float)100*(float)(currentPageInSpineIndex+1)/(float)pagesInCurrentSpineCount animated:YES];	
    }else{
        if(!paginating){
            [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
            [pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];	
        }
    }
    
   
	webView.hidden = NO;
    
    [self recordLastReadPage];
}

-(void)jieTuImgvMoveTo:(int)lORr{
    //**************************webview从右向左滑出************//
    
    int orgX = 320;
    
    if (lORr==1) {
        orgX = 0;
    }
    CGRect rect = jietuImgV.frame;
    rect.origin.x = orgX;
    jietuImgV.frame = rect;
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect rect = jietuImgV.frame;
                         rect.origin.x = 320;
                         jietuImgV.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    //*****************************************************//
}
-(void)webviewMoveTo:(int)lORr{
    
    //********复位截图view  ***********
    
    CGRect jieturect = jietuImgV.frame;
    jieturect.origin.x = 0;
    jietuImgV.frame = jieturect;
    
    //**************************webview从右向左滑出************//
    int orgX = 320;
    if (lORr==1) {
        orgX = -320;
    }
    CGRect rect = self.backView.frame;
    rect.origin.x = orgX;
    self.backView.frame = rect;
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect rect = self.backView.frame;
                         rect.origin.x = 0;
                         self.backView.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    //*****************************************************//
}

-(void)jietu{
    if (self.ynShowToolBar) {
        return;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.backView.frame.size.width, self.backView.frame.size.height), NO, 0.0);
    
    //UIGraphicsBeginImageContext(CGSizeMake(320, 480));
    
    //获取图像
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0,
                                                                                   CGRectGetMinY(self.backView.frame)*2,
                                                                                   self.backView.frame.size.width*2,
                                                                                   CGRectGetHeight(self.backView.frame)*2));
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (!self.jietuImgV) {
        UIImageView *imgVVaa = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.backView.frame), CGRectGetWidth(self.backView.frame), CGRectGetHeight(self.backView.frame))];
        self.jietuImgV = imgVVaa;
        [self.view insertSubview:self.jietuImgV atIndex:1];
        [imgVVaa release];
    }
    self.jietuImgV.hidden = NO;
    self.jietuImgV.image = result;
    
    //        self.setView.view.hidden = NO;
//    [BlackView orgXAnimation:self.graphView orgx:320 dur:0.5];
}

- (void) gotoNextSpine {
	if(!paginating){
		if(currentSpineIndex+1<[bookLoader.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}else{
            [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"readover", nil)];
//            [[WxxAlertView sharedInstance]showWithTextWithTime:NSLocalizedString(@"readover", nil)];
        }
	}
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
    if (!YNSHOWGOOLEAD || [[AppData sharedAppData] getAdmoveIsOpen] == 0 || locked) {
    }else{
        if (pagesInCurrentSpineCount > 10) {
            
            if ([self.interstitial isReady]) {
//                if (booktype == BTjingdu) {
//                    [self showbaiduAd];
//                }else{
                    [self.interstitial presentFromRootViewController:self];
//                }
            }

//            [self showInterstitial:nil];
        }
    }
    //允许显示广告在调用
    if (YNSHOWADVIEW || [[AppData sharedAppData] getSiayuAdIsOpen] == 1) {
        //本章页数小于15的暂时显示广告， 增加体验
        if (pagesInCurrentSpineCount > 10) {

            [[WxxAdView sharedInstance]showWxxAdView];
        }
    }
}

- (void) gotoPrevSpine {
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}	
	}
}

- (void) gotoNextPage {
    if(!self.ynShowTool){
        
        if(!paginating){
            if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
                [self jietu];
                [self gotoPageInCurrentSpine:++currentPageInSpineIndex];
                [self.view sendSubviewToBack:self.jietuImgV];
                [self webviewMoveTo:0];
            } else {
                [self gotoNextSpine];
            }
        }
    }else{
        [self hideAllTool];
        
    }
   
}

- (void) gotoPrevPage {
    
    if(self.toolbar.frame.origin.y == self.view.frame.size.height){
        if (!paginating) {
            if(currentPageInSpineIndex-1>=0){
                [self jietu];
                [self gotoPageInCurrentSpine:--currentPageInSpineIndex];
                [self.view bringSubviewToFront:self.jietuImgV];
                
                //            [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:3];
                [self jieTuImgvMoveTo:1];
            } else {
                if(enablePaging){
                    if(currentSpineIndex!=0){
                        int targetPage = [(Chapter*)[bookLoader.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
                        [self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
                    }
                }else{
                    //不分页条件下，上一个章节最后一页，-1标示
                    if(currentSpineIndex-1>=0)
                        [self loadSpine:--currentSpineIndex atPageIndex:-1];
                }
            }
        }
    }else{
        [self hideAllTool];
        
    }
   
}


- (void) increaseTextSizeClicked{
//    NSLog(@"加大");
	if(!paginating){
		if(currentTextSize+5<=35){
			currentTextSize+=5;
            [self setHtmlTextFont:currentTextSize];
			[self updatePagination];
			if(currentTextSize == 35){
				[incTextSizeButton setEnabled:NO];
			}
			[decTextSizeButton setEnabled:YES];
		}
	}
}


- (void) decreaseTextSizeClicked{
//    NSLog(@"减小");
	if(!paginating){
		if(currentTextSize-5>=15){
			currentTextSize-=5;
            [self setHtmlTextFont:currentTextSize];
			[self updatePagination];
			if(currentTextSize<=15){
				[decTextSizeButton setEnabled:NO];
			}
			[incTextSizeButton setEnabled:YES];
		}
	}
}

- (void) doneClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void) slidingStarted:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFade;
    [currentPageLabel2.layer addAnimation:transition forKey:nil];
    currentPageLabel2.frame = CGRectMake((self.view.frame.size.width-currentPageLabel2.frame.size.width)/2, currentPageLabel2.frame.origin.y, currentPageLabel2.frame.size.width, currentPageLabel2.frame.size.height);
    
    
    int targetPage = 0;
    NSString *text1;
    
    if(enablePaging){
        targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
        if (targetPage==0) {
            targetPage++;
        }
        text1 = [NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount];
        
    }else{
        targetPage = ((pageSlider.value/(float)100)*(float)pagesInCurrentSpineCount);
        if (targetPage==0) {
            targetPage++;
        }
        text1 = [NSString stringWithFormat:@"%d/%d", targetPage, pagesInCurrentSpineCount];
    }
	
    [currentPageLabel setText:text1];
}

- (void) slidingChanged:(id)sender{
    int targetPage = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
    NSString *text2;
    
    if(enablePaging){
        targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
        if (targetPage==0) {
            targetPage++;
        }
        
        text2 = [NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount];
        
        int pageSum = 0;
        for(chapterIndex=0; chapterIndex<[bookLoader.spineArray count]; chapterIndex++){
            pageSum+=[(Chapter*)[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount];
            if(pageSum>=targetPage){
                pageIndex = [(Chapter*)[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
                break;
            }
        }
        
    }else{
        targetPage = ((pageSlider.value/(float)100)*(float)pagesInCurrentSpineCount);
        if (targetPage==0) {
            targetPage++;
        }
        text2 = [NSString stringWithFormat:@"%d/%d", targetPage, pagesInCurrentSpineCount];
        
        pageIndex = targetPage-1;
    }
    
    currentPageInSpineIndex = pageIndex;
    currentPageLabel.text = text2;
    currentPageLabel2.text = text2;
}

- (void) slidingEnded:(id)sender{
    int targetPage = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
    NSString *text3;
    
    if(enablePaging){
        targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
        if (targetPage==0) {
            targetPage++;
        }
        
        text3 = [NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount];
        
        int pageSum = 0;
        for(chapterIndex=0; chapterIndex<[bookLoader.spineArray count]; chapterIndex++){
            pageSum+=[(Chapter*)[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount];
            if(pageSum>=targetPage){
                pageIndex = [(Chapter*)[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
                break;
            }
        }
        
    }else{
        targetPage = ((pageSlider.value/(float)100)*(float)pagesInCurrentSpineCount);
        if (targetPage==0) {
            targetPage++;
        }
        text3 = [NSString stringWithFormat:@"%d/%d", targetPage, pagesInCurrentSpineCount];
        
        pageIndex = targetPage-1;
    }
    
    currentPageInSpineIndex = pageIndex;
    currentPageLabel.text = text3;
    currentPageLabel2.text = text3;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [currentPageLabel2.layer addAnimation:transition forKey:nil];
    currentPageLabel2.frame = CGRectMake(self.view.frame.size.width, currentPageLabel2.frame.origin.y, currentPageLabel2.frame.size.width, currentPageLabel2.frame.size.height);
    
	[self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
    [self hideAllTool];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void) startUpload:(id)sender{
//    [httpServerViewController startServer];
}

- (void) showChapterIndex:(id)sender{
    self.jietuImgV.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChapters" object:nil];
//    [self.chaptersListView showChapter];
}

- (void) showSettings:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSettings" object:nil];  
}



- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
    if(self.isClearWebViewContent)
        return;
    [NSThread sleepForTimeInterval:0.5f];
    [hud hide:NO];
    
//    NSString *cssPath = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath]stringByAppendingString:@"wxx.css"]];
//    NSURL *baseURL = [NSURL fileURLWithPath:cssPath];
//    
//    
//    NSString *theJS = [[NSString alloc] initWithFormat:@"javascript:(function() {wxx.rel='stylesheet'; wxx.href='%@'; wxx.type='text/css'; the_css.media='screen';} )();",baseURL];
//    [cssPath release];
//                       
//    [webView stringByEvaluatingJavaScriptFromString:theJS];
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
//    
//    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8 " baseURL:baseURL];
//  
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"file.css" ofType:nil]]
    
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'font-size:20px;margin:0px;padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;');", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = @"addCSSRule('p', 'text-align: justify;');";
    NSString *insertRule3 = @"addCSSRule('img', 'max-width:100%; max-height:100%;border:none;');";
    
   
        if (!self.setTextSizeRule) { //避免多次设置，节省性能啦。
            [self setTextSizeRuleValue];
        }
    
	NSString *setHighlightColorRule = @"addCSSRule('highlight', 'background-color: yellow;');";
    
    
	[webView stringByEvaluatingJavaScriptFromString:SHEET];
	[webView stringByEvaluatingJavaScriptFromString:ADDCSSRULE];
    
//	[webView stringByEvaluatingJavaScriptFromString:style];
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	[webView stringByEvaluatingJavaScriptFromString:insertRule3];
    [self.webView stringByEvaluatingJavaScriptFromString:self.setTextSizeRule];
    [webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
    [webView stringByEvaluatingJavaScriptFromString:insertRule1];
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pagesInCurrentSpineCount = (int)((float)totalWidth/webView.bounds.size.width);
    
    if(currentPageInSpineIndex > pagesInCurrentSpineCount-1)
        currentPageInSpineIndex = pagesInCurrentSpineCount -1;
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}

- (void) updatePagination{    
	if(epubLoaded){
        if(!paginating){
//            NSLog(@"Pagination Started!");
//            [currentPageLabel setText:@"0/0"];
            
            if(enablePaging){
                 totalPagesCount=0;
                paginating = YES;
                hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                hud.delegate = self;
                hud.labelText = NSLocalizedString(@"loading page", nil);
                [hud show:YES];
                [[bookLoader.spineArray objectAtIndex:0] setDelegate:self];
                [[bookLoader.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            }
            [webView loadHTMLString:@"" baseURL:nil];
            
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex]; 
            
//            NSLog(@"pages:%d",currentSpineIndex);
        }
	}
}

-(void)toLastReadPage{
//    NSMutableDictionary *last = (NSMutableDictionary *)[ResourceHelper getUserDefaults:self.bookLoader.filePath];
//    if(last!=nil){
//        
//    }
    self.historyData = [[PenSoundDao sharedPenSoundDao]selectHistory:self.bookdata.bbook_id];
    currentSpineIndex       = [_historyData.hcurrentSpineIndex intValue];//[[last objectForKey:@"currentSpineIndex"] intValue];
    currentTextSize         = [_historyData.hcurrentTextSize intValue];//[[last objectForKey:@"currentTextSize"] intValue];
    currentPageInSpineIndex = [_historyData.hcurrentPageInSpineIndex intValue];//[[last objectForKey:@"currentPageInSpineIndex"] intValue];
}

-(void)recordLastReadPage{
//    NSMutableDictionary *last = [[NSMutableDictionary alloc] init];
    NSString *rCurrentSpineIndex = [[NSString alloc] initWithFormat:@"%d",currentSpineIndex];
    NSString *rCurrentPageInSpineIndex = [[NSString alloc] initWithFormat:@"%d",currentPageInSpineIndex];
    NSString *rCurrentTextSize = [[NSString alloc] initWithFormat:@"%d",currentTextSize];
    
//    [last setObject:rCurrentSpineIndex forKey:@"currentSpineIndex"];
//    [last setObject:rCurrentPageInSpineIndex forKey:@"currentPageInSpineIndex"];
//    [last setObject:rCurrentTextSize forKey:@"currentTextSize"];
    
    
    
    HistoryData *hdata = [[HistoryData alloc]init];
    hdata.hbookId = self.bookdata.bbook_id;
    hdata.hcurrentPageInSpineIndex = rCurrentPageInSpineIndex;
    hdata.hcurrentSpineIndex = rCurrentSpineIndex;
    hdata.hcurrentTextSize = rCurrentTextSize;
    [[PenSoundDao sharedPenSoundDao]saveHistory:hdata];
//    [ResourceHelper setUserDefaults:last forKey:self.bookLoader.filePath];
    
    [rCurrentSpineIndex release];
    [rCurrentPageInSpineIndex release];
    [rCurrentTextSize release];
//    [last release];
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self updatePagination];
	return YES;
}





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //主界面
    [self initBackView];
    
    //工具栏
    self.toolbar = [[[ToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    [self.view addSubview:toolbar];
    
    [self.toolbar receiveObject:^(id object) {
        setSelectType type = object;
        switch (type) {
            case setToolChapter:
                [self.chaptersListView showChapter];
                break;
            case setToolLight:
                [self initLightView];
                break;
            case setToolFont:
                [self initBookSetView];
                break;
            case setToolBack:
                [self showChapterIndex:nil];
                break;
            default:
                break;
        }

    }];
    
    int chapterOrgy = 20;
    //目录
    self.chaptersListView = [[ChapterListView alloc]initWithFrame:CGRectMake(3,chapterOrgy,CGRectGetWidth(self.view.frame)-6,CGRectGetHeight(self.view.frame)-chapterOrgy)];
    [chaptersListView release];
    self.chaptersListView.bookViewController = self;
    [self.view addSubview:chaptersListView];

    //隐藏目录
    [self.chaptersListView hideChapter];
    //页数
    UILabel *_pageText = [[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width, (self.view.frame.size.height+80)/2, 100, 30)] autorelease];
    _pageText.layer.cornerRadius = 5;
    _pageText.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:68/255.f green:68/255.f blue:68/255.f alpha:1];
    _pageText.textColor = [UIColor colorWithRed:172/255.f green:134/255.f blue:98/255.f alpha:1];
    _pageText.font = [UIFont systemFontOfSize:24];
    _pageText.textAlignment = NSTextAlignmentCenter;
    self.currentPageLabel2 = _pageText;
    [self.view addSubview:currentPageLabel2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookDidLoaded:) name:@"bookDidLoaded" object:nil];
}

-(void)initBackView{
    self.backView = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.backView atIndex:2];
    
    //右边页码
    self.currentPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-275, 30, 250, 10)];
    [currentPageLabel release];
    currentPageLabel.backgroundColor = [UIColor clearColor];
    currentPageLabel.font = [UIFont systemFontOfSize:10];
    currentPageLabel.textAlignment = NSTextAlignmentRight;
    currentPageLabel.textColor = [UIColor colorWithRed:37/255.f green:37/255.f blue:37/255.f alpha:1];
    [self.backView insertSubview:currentPageLabel atIndex:2];
    //左边标题
    self.logoView=[[[UIImageView alloc] initWithImage:[ResourceHelper loadImageByTheme:NSLocalizedString(@"logo", nil)]] autorelease];
    self.logoView.frame = CGRectMake(23, 32, 15,15);
    [self.backView addSubview:self.logoView];
    self.titleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.logoView.frame)+2, CGRectGetMinY(self.logoView.frame),235, 15) font:fontTTFToSize(10)] autorelease];
    [self.backView insertSubview:self.titleLb atIndex:2];
    
    self.webView = [[[WxxWebView alloc] initWithFrame:CGRectMake(webOrgX, 50, self.view.frame.size.width-webOrgX*2, self.view.frame.size.height - 80)] autorelease];
    self.webView.backgroundColor = [UIColor clearColor];
    [webView release];
    self.leftView = [[[UIView alloc]initWithFrame:CGRectMake(-webOrgX, 0, webOrgX, CGRectGetHeight(self.webView.frame))] autorelease];
    [self.webView addSubview:self.leftView];
    
    webView.opaque = NO;
    [webView setDelegate:self];
    [self.backView insertSubview:webView atIndex:2];
    
//    currentTextSize = 100;
    //设置界面背景色彩,字体颜色
    [self setViewBackGroundColor:[[[NSUserDefaults standardUserDefaults] objectForKey:selectTypeKey] intValue]];
    
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [self.webView addGestureRecognizer:singleFingerOne];
    [singleFingerOne release];
    
    UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
    
	
	//手势  右边
	UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	//左边
	UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	//上啦
    UISwipeGestureRecognizer* upSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeRecognizer)] autorelease];
	[upSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//
	UISwipeGestureRecognizer* downSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeRecognizer)] autorelease];
	[downSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
	[webView addGestureRecognizer:rightSwipeRecognizer];
	[webView addGestureRecognizer:leftSwipeRecognizer];
    [webView addGestureRecognizer:upSwipeRecognizer];
	[webView addGestureRecognizer:downSwipeRecognizer];
}

-(void)upSwipeRecognizer{
    NSLog(@"上拉");
//    [BlackView orgYAnimation:self.navigationController.view orgY:-50 duration:0.5];
    if(self.toolbar.frame.origin.y == self.view.frame.size.height){
        [self showToolbar];
        
    }else{
        [self hideToolbar];
        
    }
    
}
-(void)downSwipeRecognizer{
    NSLog(@"下拉");
//    [BlackView orgYAnimation:self.view orgY:0 duration:0.5];
//    [BlackView orgYAnimation:self.navigationController.view orgY:0 duration:0.5];
    if(self.toolbar.frame.origin.y == self.view.frame.size.height){
        [self showToolbar];
        
    }else{
        [self hideToolbar];
        
    }
}

//设置文本颜色和大小
-(void)setHtmlTextRule:(NSString *)colorStr{
    if (!colorStr) {colorStr = @"#000";}
    [[NSUserDefaults standardUserDefaults]setObject:colorStr forKey:bodyColor];
}
-(void)setHtmlTextFont:(int)textFont{
    if (!textFont) {textFont = textFontDefault;}
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",textFont] forKey:bodyFont];
    [self setTextSizeRuleValue];
}

//设置body的 字体，颜色
-(void)setTextSizeRuleValue{
    NSString *colorStr = [[NSUserDefaults standardUserDefaults]objectForKey:bodyColor];
    NSString *fontorg = [[NSUserDefaults standardUserDefaults]objectForKey:bodyFontOrg];
    currentTextSize = [[[NSUserDefaults standardUserDefaults]objectForKey:bodyFont] intValue];
    if (!colorStr) {colorStr = @"#000";}
    if (!fontorg) {fontorg = @"1.6";}
    if (currentTextSize <= 0) {currentTextSize = textFontDefault;}
    NSString *string = [NSString stringWithFormat:@"addCSSRule('body', 'color:%@;font-weight:normal;font-size:%dpx;-webkit-text-size-adjust: none;line-height:%@em;')",colorStr,currentTextSize,fontorg];
    self.setTextSizeRule = string;
}

-(void)setHtmlBodyCss{
    [self setTextSizeRuleValue];
    //设置html的字体颜色，大小
    [self.webView stringByEvaluatingJavaScriptFromString:self.setTextSizeRule];
}

-(void)setBackViewEvrything:(UIColor *)backColor{
    
    [self setHtmlBodyCss];
    //设置背景色
//    UIImageView *img = [[UIImageView alloc]initWithImage:[ResourceHelper loadImageByTheme:@"background"]];
//    img.frame = CGRectMake(0, 0, img.image.size.width, img.image.size.height);
//    [self.backView insertSubview:img atIndex:1];
    self.backView.backgroundColor = backColor;
}

//根据类型设置背景和字体颜色
-(void)setViewBackGroundColor:(setSelectType)type{
    UIColor *color = [UIColor whiteColor];
    switch (type) {
        case setSelectNull:
            break;
        case setSelectLineOrg1:
            [[NSUserDefaults standardUserDefaults]setObject:@"1.6" forKey:bodyFontOrg];
            [self setHtmlBodyCss];
            break;
        case setSelectLineOrg2:
            [[NSUserDefaults standardUserDefaults]setObject:@"1.9" forKey:bodyFontOrg];
            [self setHtmlBodyCss];
            break;
        case setSelectLineOrg3:
            [[NSUserDefaults standardUserDefaults]setObject:@"2.2" forKey:bodyFontOrg];
            [self setHtmlBodyCss];
            break;
        case setSelectAddFont://字体放大
            [self increaseTextSizeClicked];
            break;
        case setSelectDelFont: //字体缩小
            [self decreaseTextSizeClicked];
            break;
        case setSelectVirescence:
            color = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_green"]];
            [self setHtmlTextRule:@"#000"];  //字体颜色 先
            [self setBackViewEvrything:color]; //背景  后
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",type] forKey:selectTypeKey];
            
            break;
        case setSelectgrayWhite: //白色背景 黑色字
            color = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background"]];
            self.currentPageLabel.textColor = [UIColor blackColor];
            [self setHtmlTextRule:@"#000"];  //字体颜色 先
            [self setBackViewEvrything:color]; //背景  后
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",type] forKey:selectTypeKey];
            break;
        case setSelectWhite:
            color = [UIColor whiteColor];
            self.currentPageLabel.textColor = [UIColor blackColor];
            [self setHtmlTextRule:@"#000"];  //字体颜色 先
            [self setBackViewEvrything:color]; //背景  后
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",type] forKey:selectTypeKey];
            break;
            
        case setSelectSepia:
            color = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_sepia"]];
            self.currentPageLabel.textColor = [UIColor blackColor];
            [self setHtmlTextRule:@"#000"];  //字体颜色  先
            [self setBackViewEvrything:color]; //背景   后
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",type] forKey:selectTypeKey];
            break;
        case setSelectNight: //黑色背景白字
            color = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_night"]];
            self.currentPageLabel.textColor = [UIColor whiteColor];
            [self setHtmlTextRule:@"#a0a064"];//字体颜色  先
            [self setBackViewEvrything:color];//背景   后
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",type] forKey:selectTypeKey];
            break;
        default:
            break;
    }
    
}

-(void)popSetView{
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    //上一章
    if ( point.x < CGRectGetWidth(self.view.frame)/3 ) {
         [self gotoPrevPage];
        
    }else if ( point.x > CGRectGetWidth(self.view.frame)/3*2 ) {
       
        [self gotoNextPage];
    }else{
        
        [self hideAllTool];
//        if(self.toolbar.frame.origin.y == self.view.frame.size.height){
//            [self showToolbar];
//            
//        }else{
//            [self hideToolbar];
//            
//        }
    }
}

-(void)showToolbar{
    
    //显示目录
//    [self.chaptersListView showChapter];
    self.logoView.hidden = NO;
//    self.statusBarView.hidden = NO;
//    [BlackView orgYAnimation:self.statusBarView orgY:0 duration:0.2];
    self.titleLb.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.ynShowToolBar = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [self.toolbar showSelf];
//    self.toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.headerbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}


-(void)hideAllTool{
    if (self.ynShowTool) {
        //隐藏
//        if (self.bookLightView) {
//            [self.bookLightView hideSelf];
//        }
        
        [self hideToolbar];
        self.ynShowTool = NO;
    }else{
        //显示
        [self showToolbar];
        self.ynShowTool = YES;
    }
}


-(void)hideToolbar{
    
    //隐藏目录
    [self.chaptersListView hideChapter];
    self.logoView.hidden = YES;
//    [BlackView orgYAnimation:self.statusBarView orgY:-20 duration:0.5];
    self.titleLb.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.ynShowToolBar = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
//    self.toolbar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, toolbarHeight);
    [self.toolbar hideSelf];
    self.headerbar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    [UIView commitAnimations];
}



-(void)bookDidLoaded:(NSNotification *)notification{
    [hud hide:YES];
}

- (void)viewDidUnload {
	self.toolbar = nil;
	self.webView = nil;
    [self.backView release];
    self.backView = nil;
    self.jietuImgV = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
    self.bookdata = nil;
    self.chaptersListView = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;
    self.logoView = nil;
    self.titleLb = nil;
    self.leftView = nil;
    self.setTextSizeRule = nil;
//    self.statusBarView = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    if (interstitial_) {
        interstitial_.delegate = nil;
        [interstitial_ release];
    }
    [_bookdata release];
    _bookdata = nil;
    self.leftView = nil;
    self.setTextSizeRule = nil;
    self.jietuImgV = nil;
    self.backView = nil;
    self.toolbar = nil;
	self.webView = nil; 
    self.chaptersListView = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;
    self.logoView = nil;
//    self.statusBarView = nil;
    self.titleLb = nil;
    [_titleLb release];
    _titleLb = nil;
//	[bookLoader release];
    self.bookLoader = nil;
    [super dealloc];
}

@end
