//
//  SearchResultViewController.m
//  PandaBook
//
//  Created by weng xiangxun on 15/4/11.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SearchResultViewController.h"
#import "StoreTableVeiwCell.h"
#import "BookData.h"
#import "AppData.h"
#import "BookInfoViewController.h"
@interface SearchResultViewController ()
@property (nonatomic,strong)NSMutableArray *bookArrDic;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;  
@end

@implementation SearchResultViewController

@synthesize bookArrDic;
-(void)dealloc{
    [bookArrDic release];
    if (_tableView) {
        [_tableView release];
    }
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"搜索结果";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,0,UIBounds.size.width,CGRectGetHeight(self.view.frame)-116) ] autorelease];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:self.tableView];

    _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 5);
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor], nil];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1.0);
    _gradientLayer.hidden = YES;
    [self.view.layer addSublayer:_gradientLayer];
//    [self loadAdmob];
}

-(void)setDicInfo:(id)respone{
    if (!self.bookArrDic) {
        self.bookArrDic = [[[NSMutableArray alloc]init] autorelease];
    }
    for (int i=0; i<[respone count]; i++) {
        BookData *bookData =[BookData initWithDictionary:[respone objectAtIndex:i]];
        [self.bookArrDic addObject:bookData];
    }
    [self.tableView reloadData];
    [[WxxLoadView sharedInstance]hideSelf];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 3.0) {
        
        _gradientLayer.hidden = YES;
    }else{
        if (_gradientLayer.hidden) {
            _gradientLayer.hidden = NO;
        }
    }
    //    NSLog(@"----%f",scrollView.contentOffset.y);
}


- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.bookArrDic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        static NSString *CellIdentifier = @"cate_cell";
        
        StoreTableVeiwCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[StoreTableVeiwCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
            //        cell.selectedBackgroundView = backView;
            //        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]];
            //        [backView release];
        }else{
            //复用之前先去除前面cell存在的  progressview
            for (UIView *oneView in cell.contentView.subviews ) {
                if ([oneView isKindOfClass:[EVCircularProgressView class]]) {
                    [oneView removeFromSuperview];
                }
            }
        }
        
        int row = (int)[self.bookArrDic count] -  (int)indexPath.row - 1;//倒序显示
        BookData *bookData =[self.bookArrDic objectAtIndex:row];
        
        [cell setCellInfo:bookData row:@""];
    
    
        return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[self.bookArrDic count] -  (int)indexPath.row - 1;//倒序显示
    BookData *bookData =[self.bookArrDic objectAtIndex:row];
    BookInfoViewController *svc = [[BookInfoViewController alloc] init];
    
    [svc setBookdata:bookData];
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
}
//
//-(void)loadAdmob{
//    if (!bannerView_) {
//        
//        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//        bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
//        // Specify the ad unit ID.
//        NSString*admobid = [[AppData sharedAppData] getAdmobId];
//        if (!admobid) {
//            admobid = admobId;
//        }
//        bannerView_.adUnitID = admobid;
//        
//        // Let the runtime know which UIViewController to restore after taking
//        // the user wherever the ad goes and add it to the view hierarchy.
//        bannerView_.rootViewController = self;
//        bannerView_.delegate = self;
//        
//        
//        // Initiate a generic request to load it with an ad.
//        [bannerView_ loadRequest:[GADRequest request]];
//    }
//}
//- (void)adViewDidReceiveAd:(GADBannerView *)view{
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view addSubview:bannerView_];
//        CGRect rect = self.tableView.frame;
//        rect.origin.y = CGRectGetMaxY(bannerView_.frame);
//        rect.size.height = UIBounds.size.height-116 - 50;
//        self.tableView.frame = rect;
//    }completion:^(BOOL finished){
//    }];
//    
//    NSLog(@"广告出来了");
//}
//- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
//    NSLog(@"%@",error);
//    NSLog(@"广告错误");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)nativeFeedback{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFeedback" object:nil];
}

@end
