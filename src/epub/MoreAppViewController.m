//
//  MoreAppViewController.m
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
// 

#import "MoreAppViewController.h"
#import "ResourceHelper.h"
#import "SVHTTPRequest.h"
#import "MoreAppTableViewCell.h"
#import "AppData.h"
#import "BlockUI.h"
#import "BlackView.h"
#import "WxxAlertView.h"
@interface MoreAppViewController ()
@property (nonatomic,strong)NSMutableArray *appArrDic;
@end

@implementation MoreAppViewController

@synthesize appArrDic;
-(void)dealloc{

    self.appArrDic = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"moreapps", nil);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appArrDic = [[[NSMutableArray alloc]init] autorelease];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initRefreshView]; //
    
    [self getHttpList]; //更新有修改的书籍
//    [self openAppStore:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[WxxAlertView sharedInstance]hidden];
}
 

-(void)getHttpList{
    [[WxxLoadView sharedInstance]showself];
    [SVHTTPRequest GET:[WXXHTTPUTIL getMoreAppLsit]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        saiyuappid,@"id", nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                [[WxxLoadView sharedInstance]hideSelf];
                if (response) {
                    if ([response count]<=0) {
                                    [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"loadNilBook", nil)];
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:NSLocalizedString(@"loadNilBook", nil)];
                    }else{
//                        [[WxxAlertView sharedInstance]hidden];
                    }
                    for (int i=0; i<[response count]; i++) {
                        AppData *bookData =[AppData initWithDictionary:[response objectAtIndex:i]];
                        [self.appArrDic addObject:bookData];
                    }
                }else{
//                    [[WxxAlertView sharedInstance]hidden];
                }

                [self reloadData];
            }];
}

-(void)reloadData{
    //查询书籍列表 
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        [self.refreshControl endRefreshing];
    }
    [self.tableView reloadData];
}


-(void)initRefreshView{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.tintColor = [UIColor lightGrayColor];
        refresh.attributedTitle = [[[NSAttributedString alloc] initWithString:NSLocalizedString(@"PulltoRefresh", nil)] autorelease];
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
        [refresh release];
    }else{
        
    }
    
}
-(void)refreshView:(UIRefreshControl *)refresh
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        if (refresh.refreshing) {
            refresh.attributedTitle = [[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Refreshing", nil)] autorelease];
            [self performSelector:@selector(getHttpList) withObject:nil afterDelay:2];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if ([self.appArrDic count] == 0) {
//        return 1; // a single cell to report no data
//    }
    return [self.appArrDic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.appArrDic count] == 0) {
//        UITableViewCell *cell= [[[UITableViewCell alloc] init] autorelease];
//        cell.textLabel.text= @"没有搜索到新的App,请明天再来看下吧。";
//        //whatever else to configure your one cell you're going to return
//        return cell;
//    }
    
    static NSString *CellIdentifier = @"cate_cell";
    
    MoreAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[MoreAppTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier] autorelease];
        [cell receiveObject:^(id object) {
            NSLog(@"asdfasdfasdf");
            [self openAppStore:object];
        }];
        //        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView = backView;
        //        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]];
        //        [backView release];
    }else{ 
    }
    int row = (int)[self.appArrDic count] -  (int)indexPath.row - 1;//倒序显示
    AppData *bookData =[self.appArrDic objectAtIndex:row];
    
    [cell setCellInfo:bookData];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)nativeFeedback{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFeedback" object:nil];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
    if (!YNSHOWGOOLEAD) {
        return 0;
    }
    if (locked) {
        return 0;
    }else{
        
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (YNSHOWGOOLEAD) {
        
        //             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];
        // Create a view of the standard size at the top of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
        // Specify the ad unit ID.
        bannerView_.adUnitID = admobId;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
        //广告未显示出来的背景
        [bannerView_ setBackgroundColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"adbannerView"]]];
        return bannerView_;
        
    }else{
        UIView *footV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 50)] autorelease];
        return footV;
    }
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark Actions
- (void)openAppStore:(id)object {
    // Initialize Product View Controller
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    
    // Configure View Controller
    [storeProductViewController setDelegate:self];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : object} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
            
        } else {
           
        }
    }];
    // Present Store Product View Controller
    [self presentViewController:storeProductViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Store Product View Controller Delegate Methods
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
