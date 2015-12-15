//
//  StoreViewController.m
//  epub
//
//  Created by zhiyu on 13-6-8.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "ReStoreViewController.h"
#import "ResourceHelper.h"
#import "SVHTTPRequest.h"
#import "ReStoreTableVeiwCell.h"
#import "WxxIapStore.h"
#import "BigClassData.h"
#import "BookData.h"
#import "BlackView.h"
#import "WxxAlertView.h"
#import "UMFeedbackViewController.h"
#import "StoreClassTableViewCell.h"
#import "HYCircleLoadingView.h"
//#import "StoreBookInfoView.h" //暂时无用
@interface ReStoreViewController ()
@property (nonatomic,strong)NSMutableArray *bookArrDic;
@property(nonatomic, assign) int restoreNum;
@property (nonatomic, strong) HYCircleLoadingView *loadingView;
@property (nonatomic,strong)NSIndexPath *selectedCellIndexPath;//选中行
@property (nonatomic,assign)float selectCellHeight; //选中行的高度
@end

@implementation ReStoreViewController
@synthesize bookArrDic;
@synthesize restoreNum;
-(void)dealloc{
    [bookArrDic release];
    if (_selectedCellIndexPath) {
        _selectedCellIndexPath = nil;
    }
    [_loadingView release];
    _loadingView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
       self.selectedCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        self.navigationItem.title = @"已恢复购买";
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [[WxxLoadView sharedInstance]showself];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.loadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
//        UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:self.loadingView];
//        self.navigationItem.leftBarButtonItem = loadingItem;
//        [self.loadingView startAnimation];
    }
    return self;
}

-(void)restore{
    [[WxxIapStore sharedWxxIapStore]receiveObject:^(id object) {
        if (!object) {
            showAlert(@"提示", @"网络错误，请稍后在恢复");
//            [self.loadingView stopAnimation];
            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setHidesBackButton:NO animated:YES];
            return;
        }
        if ([object isKindOfClass:[NSArray class]]) {
            self.restoreNum = (int)[object count];
            for (int i =0 ; i<[object count]; i++) {
                SKPaymentTransaction *skPay = object[i];
                
                [self getRestoreBookInfo:skPay.payment.productIdentifier];
                
                
            }
        }else if ([object isEqualToString:@"1"]) {
            showAlert(@"提示", @"您没有可以恢复的书籍");
//            [self.loadingView stopAnimation];
            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setHidesBackButton:NO animated:YES];
            
            return;
        }
       
        
    }];
    //去苹果服务端获取买过的商品productid
    [[WxxIapStore sharedWxxIapStore] restore];
}
//根据恢复购买的productid去服务端获取对应的书籍的信息
-(void)getRestoreBookInfo:(NSString *)productid{
    if ([productid isEqualToString:@"error"]) {
        showAlert(@"提示", @"恢复错误");
        return;
    }
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    //截取productid的最后一位（为bookid）
    NSString *bookid = [productid substringFromIndex:[bundleid length]+1];
    if ([bookid intValue]==6) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"restore"];//不在显示恢复按钮
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];//去广告
//        [self.loadingView stopAnimation];
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        showAlert(@"提示", @"已清楚广告");
    }else{
        
        
        BigClassData *bookData = [[PenSoundDao sharedPenSoundDao] selectBigClass4Sonid:bookid];
        bookData.bclass_buy = @"1";
        [bookData updateSelf];
        if (!self.bookArrDic) {
            self.bookArrDic = [[[NSMutableArray alloc]init]autorelease];
        }
        [self.bookArrDic addObject:bookData];
        
    }
    
    self.restoreNum--;
    if (self.restoreNum<=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashStoreClass" object:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"restore"];
        [[WxxLoadView sharedInstance]hideSelf];
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self restore];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[StoreBookInfoView sharedInstance]hidden];
//    [[WxxAlertView sharedInstance]hidden];
}

-(void)setBookArr:(NSMutableArray *)bookArrDicar{
    self.bookArrDic = bookArrDicar;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [self.bookArrDic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedCellIndexPath != nil
       && [self.selectedCellIndexPath compare:indexPath] == NSOrderedSame){
        
        return self.selectCellHeight;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    StoreClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[StoreClassTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
//        //复用之前先去除前面cell存在的  progressview
//        for (UIView *oneView in cell.contentView.subviews ) {
//            if ([oneView isKindOfClass:[EVCircularProgressView class]]) {
//                    [oneView removeFromSuperview];
//            }
//        }
    }
    BigClassData *bookData =[self.bookArrDic objectAtIndex:indexPath.row];
    [cell setInfo:bookData];
    
//    //如果滑出的行是前面点击行，把介绍显示完全
//    if (self.selectedCellIndexPath.row == indexPath.row) {
//        //刷新点击行
//
//        [cell highCell];
//    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    //隐藏上一个点击行
//    if (self.selectedCellIndexPath && self.selectedCellIndexPath.row >= 0) {
//        ReStoreTableVeiwCell *cellPrev = (ReStoreTableVeiwCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
//        [cellPrev lowCell];
//    }
//    if (self.selectedCellIndexPath.row == indexPath.row) {
//        self.selectedCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
//    }else{
//        self.selectedCellIndexPath = indexPath;
//        //刷新点击行
//        ReStoreTableVeiwCell *cell = (ReStoreTableVeiwCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        self.selectCellHeight = cell.highHeight;
//        [cell highCell];
//    }
//    
//    [self.tableView beginUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated: YES];
//    [self.tableView endUpdates];
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
        if (booktype == BTchuanyue) {
            return 50;
        }
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (YNSHOWGOOLEAD) {
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
        bannerView_.adUnitID = admobId;
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        //广告未显示出来的背景
//        [bannerView_ setBackgroundColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"adbannerView"]]];
        return bannerView_;
        
    }else{
        UIView *footV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 50)] autorelease];
        return footV;
    }
}


@end
