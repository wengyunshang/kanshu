//
//  SettingsViewController.m
//  epub
//
//  Created by zhiyu on 13-6-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SettingsViewController.h"
#import "ResourceHelper.h"
#import "BlackView.h"
#import "BlockUI.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#import "WxxIapStore.h"
#import "ClassData.h"
#import "AppData.h"
#import "WxxAlertView.h"
#import "SVHTTPRequest.h"
#import "WxxAlertView.h"
#import "BlockUI.h"
#import "BookData.h"
#import "ReStoreViewController.h"
#import "MoreAppViewController.h"
#import "SDImageView+SDWebCache.h"
#import "UserData.h"
#import "HYCircleLoadingView.h"
#import "AboutViewController.h"
#import "UMFeedbackViewController.h"
#define kAFKReviewTrollerAppID @"AFKReviewTrollerAppID"


@interface SettingsViewController ()
@property (nonatomic, retain) UISwitch *airplaneModeSwitch;
@property (nonatomic, retain) UISwitch *flowSwitch;

@property (nonatomic, retain) UISwitch *pushSwitch;
@end

@implementation SettingsViewController
@synthesize umFeedback = _umFeedback;

//@synthesize httpServerViewController;
@synthesize flowSwitch = _flowSwitch;
@synthesize airplaneModeSwitch = _airplaneModeSwitch;
@synthesize pushSwitch = _pushSwitch;

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
    self.title = @"设置";
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [UMFeedback setLogEnabled:YES];
        _umFeedback = [UMFeedback sharedInstance];
        [_umFeedback setAppkey:UMENG_APPKEY delegate:self];
    }
    return self;
}
-(void)showLoginSuccessUsrInfo{
    //登录成功后，删除登录cell
    [self removeSectionAtIndex:0];
    [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.textLabel.text = [UserData sharedUserData].uuser_name;
            [cell.imageView setImageWithURL:[NSURL URLWithString:[UserData sharedUserData].uuser_logo] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"set_qq"]];

        } whenSelected:^(NSIndexPath *indexPath) {
        }];
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//            cell.textLabel.text = [UserData sharedUserData].uuser_gold;
//            cell.imageView.image = [ResourceHelper loadImageByTheme:@"set_coin"];
////            CGRect rect = cell.imageView.frame;
////            rect.origin.x = rect.origin.x + 20;
////            
////            cell.imageView.frame = rect;
//        } whenSelected:^(NSIndexPath *indexPath) {
//            
//            [[UserData sharedUserData] updateGold:@"60"];
//        }];
    } atIndex:0];
}
-(void)loginView{
    NSLog(@"111");
    //登录
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            if ([[UserData sharedUserData] ynLogin]) {
                cell.textLabel.text = [UserData sharedUserData].uuser_name;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[UserData sharedUserData].uuser_logo] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"set_qq"]];
            }else{
                cell.textLabel.text = NSLocalizedString(@"qqlogin", @"qqlogin");
                cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_qq", nil)];
            }
            
        } whenSelected:^(NSIndexPath *indexPath) {
            if (![[UserData sharedUserData] ynLogin]){
//                [[LoginControl sharedLoginControl]qqlogin];
            }

        }];
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//            cell.textLabel.text = NSLocalizedString(@"sinalogin", @"sinalogin");
//            cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_sina", nil)];
//        } whenSelected:^(NSIndexPath *indexPath) {
//            
//        }];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    
   
    
//    if (booktype == BTjingdu) {
//        [[LoginControl sharedLoginControl] receiveObject:^(id object) {
//            int result = object;
//            if (result==1) {
//                
//                [self showLoginSuccessUsrInfo];
//            }else{
//                [self loginView];
//            }
//        }];
//        if ([[UserData sharedUserData] ynLogin]) {
//            //登录过就直接创建信息
//            [self showLoginSuccessUsrInfo];
//        }else{
//            [self loginView];
//            //初始化qqsession
////
//        }//判断登录结束
//       
//    }//判断平台结束
    
   
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        //		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
        //			staticContentCell.reuseIdentifier = @"UIControlCell";
        //			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        //			cell.textLabel.text =  NSLocalizedString(@"lockedscreen", @"lockedscreen");
        //			cell.imageView.image = [UIImage imageNamed:@"AirplaneMode"];
        //
        //            self.airplaneModeSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero]autorelease];
        //            [self.airplaneModeSwitch  addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        //            BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lockedLight"] boolValue];
        //            if (locked) {
        //                [self.airplaneModeSwitch setOn:YES];
        //            }
        //			cell.accessoryView = self.airplaneModeSwitch;
        //
        //		}];
        //        //        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
        //        //			staticContentCell.reuseIdentifier = @"UIControlCell";
        //        //			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        //
        //        //			cell.textLabel.text = NSLocalizedString(@"getPush", @"getPush");
        //        //			cell.imageView.image = [UIImage imageNamed:@"AirplaneMode"];
        //        //
        //        //            self.pushSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
        //        //            [self.pushSwitch  addTarget:self action:@selector(pushSwitchAction:) forControlEvents:UIControlEventValueChanged];
        //        //			cell.accessoryView = self.pushSwitch;
        //        //            BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"push"] boolValue];
        //        //            if (locked) {
        //        //                [self.pushSwitch setOn:YES];
        //        //            }
        //        //		}];
        //
        //        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
        //			staticContentCell.reuseIdentifier = @"UIControlCell";
        //			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        //			cell.textLabel.text = NSLocalizedString(@"saveflow", @"saveflow");
        //			cell.imageView.image = [UIImage imageNamed:@"AirplaneMode"];
        //
        //            self.flowSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero]autorelease];
        //            [self.flowSwitch  addTarget:self action:@selector(flowSwitchAction:) forControlEvents:UIControlEventValueChanged];
        //            BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
        //            if (locked) {
        //                [self.flowSwitch setOn:YES];
        //            }
        //			cell.accessoryView = self.flowSwitch;
        //
        //		}];
        
        
        //
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.textLabel.text = NSLocalizedString(@"feedback", @"feedback");
            cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_feedback", nil)];
            
        } whenSelected:^(NSIndexPath *indexPath) {
            [self nativeFeedback];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            cell.textLabel.text = NSLocalizedString(@"about", @"about");
            cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_about", nil)];
        } whenSelected:^(NSIndexPath *indexPath) {
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
            [about release];
        }];
        if ([[AppData sharedAppData] getIsmoreApp] == 1) {
            //                            [self removeSectionAtIndex:0];
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                cell.textLabel.text = NSLocalizedString(@"moreapp", @"moreapp");
                cell.imageView.image = [ResourceHelper loadImageByTheme:@"set_more"];
            } whenSelected:^(NSIndexPath *indexPath) {
                MoreAppViewController *about = [[MoreAppViewController alloc]init];
                [self.navigationController pushViewController:about animated:YES];
                [about release];
            }];
        }
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"DetailTextCell";
            
            cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_tick", nil)];
            cell.textLabel.text = NSLocalizedString(@"scoring", @"scoring");//@"给我打分";//NSLocalizedString(@"Wi-Fi", @"Wi-Fi");
            //			cell.detailTextLabel.text = NSLocalizedString(@"iamtheinternet", @"iamtheinternet");
        } whenSelected:^(NSIndexPath *indexPath) {
            NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:kAFKReviewTrollerAppID];
            //
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?at=10l6dK", appId]]];
            
//            [self openAppStore:nil];
        }];
        if (YNSHOWGOOLEAD ) {
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                cell.textLabel.text = NSLocalizedString(@"deliad", @"Remove ADs"); ;
                
                cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_delIad", nil)];
            } whenSelected:^(NSIndexPath *indexPath) {
                [[WxxIapStore sharedWxxIapStore]receiveObject:^(id object) {
                    [[WxxLoadView sharedInstance] hideSelf];
                    if ([object isEqualToString:BUYSECCUSS]) {
                        [[WxxPopView sharedInstance] showPopText:@"恭喜已经去掉广告"];
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:@"恭喜已经去掉广告，享受你的阅读时光吧。"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];
                        bannerView_.hidden = YES;
                    }else{
                        [[WxxPopView sharedInstance] showPopText:@"没有成功购买"];
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:@"没有成功购买"];
                    }
                    
                    //[self.loadingView stopAnimation];
                }];
               // [self.loadingView startAnimation];
                [[WxxLoadView sharedInstance] showself];
                    //购买下载
                    [[WxxIapStore sharedWxxIapStore] buyGood:6]; 
                
            }];
        }
        
            BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"restore"] boolValue];
            if (!locked) {
                
                //佛经有恢复购买选项
                [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                    cell.textLabel.text = @"恢复购买";
                    
                    cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"set_restore", nil)];
                } whenSelected:^(NSIndexPath *indexPath) {
                    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"restore"] boolValue];
                    if (locked) {
                        showAlert(@"提示", @"您已经恢复购买过了");
                        return;
                    }
                    ReStoreViewController *about = [[ReStoreViewController alloc]init];
                    //                [about setBookArr:self.bookArrDic];
                    [self.navigationController pushViewController:about animated:YES];
                    [about release];
                }];
            }
      
        
        
//        if ( booktype == BTjingdu) {
//            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//                cell.textLabel.text = @"上传epub格式书籍";//NSLocalizedString(@"Notifications", @"Notifications");
//                cell.imageView.image = [ResourceHelper loadImageByTheme:NSLocalizedString(@"btn_plus20", nil)];
//            } whenSelected:^(NSIndexPath *indexPath) {
//                //上传书籍
//                //             [httpServerViewController startServer];
//                [self initHttpServer];
//            }];
//        }
        
    }];
    
    
}




//本地http服务，上传书籍使用
-(void)initHttpServer{
    HttpServerViewController *httpServerViewController = [[HttpServerViewController alloc] init];
    [self presentViewController:httpServerViewController animated:YES completion:nil];
    [httpServerViewController release];
    [httpServerViewController startServer];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lockedLight"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"lockedLight"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}
-(void)pushSwitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
    }
}
-(void)flowSwitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"saveflow"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"saveflow"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)nativeFeedback{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFeedback" object:nil];
}

#pragma mark -
#pragma mark Actions
- (void)openAppStore:(id)sender {
    // Initialize Product View Controller
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:kAFKReviewTrollerAppID];
    // Configure View Controller
    [storeProductViewController setDelegate:self];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : appId} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
        } else {
        }
    }];
    [self presentViewController:storeProductViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Store Product View Controller Delegate Methods
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:feedbackViewController] autorelease];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.translucent = NO;
    [self presentModalViewController:navigationController animated:YES];
    [navigationController release];
}

-(void)showMyself{
    NSLog(@"123123123123");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.tableView reloadData];
    if (bannerView_) {
        [bannerView_ release];
        bannerView_ = nil;
    }
    [self initFootView];//底部广告栏
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (IBAction)webFeedback:(id)sender {
    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
    //    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY dictionary:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"a", @"b", @"c", nil] forKey:@"hello"]];
}

- (IBAction)checkNewReplies:(id)sender {
    [UMFeedback checkWithAppkey:UMENG_APPKEY];
}

- (IBAction)editingEnded:(id)sender {
    [sender resignFirstResponder];
}

- (void)dealloc {
    _umFeedback.delegate = nil;
    [super dealloc];
}


-(void)initFootView{
    //        self.tableView setTableFooterView:<#(UIView *)#>
    
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
    if (!YNSHOWGOOLEAD || [[AppData sharedAppData] getAdmoveIsOpen] ==0 || locked ) {
        //不显示广告
        
    }else{
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
        NSString*admobid = [[AppData sharedAppData] getAdmobId];
        if (!admobid) {
            admobid = admobId;
        }
        bannerView_.adUnitID = admobid;
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        //广告未显示出来的背景
        //        [bannerView_ setBackgroundColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"adbannerView"]]];
        [self.tableView setTableFooterView:bannerView_];
    }
}
@end
