//
//  StoreViewController.m
//  epub
//
//  Created by zhiyu on 13-6-8.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "StoreViewController.h"
#import "ResourceHelper.h"
#import "SVHTTPRequest.h"
#import "StoreTableVeiwCell.h" 
#import "StoreNothingCell.h"
#import "WxxIapStore.h"
#import "BookData.h"
#import "LeafNotification.h"
#import "BlackView.h"
#import "WxxAlertView.h"
#import "StoreHeadView.h"
#import "EvRoundProgressView.h"
#import "ClassData.h"
#import "HYCircleLoadingView.h"
#import "AppData.h"
#import "SDImageView+SDWebCache.h"
#import "StoreLoadTableViewCell.h"
#import "StoreClassTableView.h"
#import "CycleScrollView.h"
#import "BookInfoViewController.h"
#import "BookFeedBackViewController.h"
#import "UMFeedbackViewController.h"
//#import "StoreBookInfoView.h" //暂时无用
@interface StoreViewController ()
@property (nonatomic,strong)NSMutableArray *bookArrDic;
@property (nonatomic,strong)EvRoundProgressView *refreshBtn;
@property (nonatomic,assign)float angle;
@property (nonatomic,assign)BOOL ynRefresh;

@property (nonatomic,strong)NSIndexPath *selectedCellIndexPath;//选中行
@property (nonatomic,assign)float selectCellHeight; //选中行的高度
@property (nonatomic,assign)NSString* classId; //当前分类ID
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,assign)BOOL ynLoaded;//是否加载完毕
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@end

@implementation StoreViewController
@synthesize bookArrDic;
-(void)dealloc{
    [bookArrDic release];
    if (_tableView) {
        [_tableView release];
    }
    if (_selectedCellIndexPath) {
        _selectedCellIndexPath = nil;
    }
    if (_refreshControl) {
        [_refreshControl release];
    }
    [super dealloc];
}
-(void)setClassId:(NSString *)classId{
    _classId = classId;
}
- (id)initWithClassId:(NSString*)classId
{
    self = [super init];
    if (self) {
        self.ynLoaded = NO;
        self.classId = classId;
        self.selectedCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}
-(void)showMyself{
    NSLog(@"123123123123");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,0,UIBounds.size.width,CGRectGetHeight(self.view.frame)-116) ] autorelease];
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    self.tableView.backgroundColor =   [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:self.tableView];
    
    //查看本地是否有数据，没数据去服务端获取
    self.bookArrDic = [[PenSoundDao sharedPenSoundDao]selectBookList:noDown limit:20 classId:self.classId];
    if ([self.bookArrDic count] <= 0) {
        [[WxxLoadView sharedInstance]showself];
//        [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"loadStoreInfo", nil)];
        [self getHttpList];
    }else{
        self.ynLoaded = YES;
        [self getBookListByUpdate]; //更新有修改的书籍
    }
    
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
    
    
    
    
    [self initRefreshView];
}

-(void)intiRefreshBtn:(NSString*)img{
    
    
    
    float refreshBtnWidth = 50;
    self.refreshBtn = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(UIBounds.size.width-refreshBtnWidth-24, self.view.frame.size.height-116-refreshBtnWidth-18, refreshBtnWidth, refreshBtnWidth) arrow:3];
    self.refreshBtn.layer.cornerRadius = refreshBtnWidth/2;
    self.refreshBtn.backgroundColor = WXXCOLOR(230, 72, 57, 1);
    //    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:headView.bounds].CGPath;
    self.refreshBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.refreshBtn.layer.shadowRadius = 2;
    self.refreshBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.refreshBtn.layer.shadowOpacity = 0.6;
    [self.view addSubview:self.refreshBtn];
//    self.refreshBtn.layer.masksToBounds = YES;
    [self.refreshBtn receiveObject:^(id object) {
        //刷新
        [[WxxLoadView sharedInstance]showself];
        NSLog(@"刷新");
        [self loadBOOOK];
        self.ynLoaded = NO;
        [self startAnimation];
    }];
    [self.refreshBtn release];
    
    UIImageView *imgvvv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, refreshBtnWidth, refreshBtnWidth)];
    [imgvvv setImageWithURL:[NSURL URLWithString:img] refreshCache:NO];
    imgvvv.layer.cornerRadius = refreshBtnWidth/2;
    imgvvv.layer.masksToBounds = YES;
    imgvvv.alpha = 0.1;
    [self.refreshBtn addSubview:imgvvv];
    [self.refreshBtn sendSubviewToBack:imgvvv];
    [imgvvv release];
}

-(void)initRefreshView{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.tintColor = WXXCOLOR(230, 87, 72, 0.87);
        //refresh.attributedTitle = [[[NSAttributedString alloc] initWithString:NSLocalizedString(@"PulltoRefresh", nil)] autorelease];
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
        [self.tableView addSubview:self.refreshControl];
        [refresh release];
    }else{
        
    }
    
}
-(void)refreshView:(UIRefreshControl *)refresh
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        if (refresh.refreshing) {
           // refresh.attributedTitle = [[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Refreshing", nil)] autorelease];
            [[WxxLoadView sharedInstance]showself];
            [self performSelector:@selector(getHttpList) withObject:nil afterDelay:2];
        }
    }
}


- (void)startAnimation
{
    if (!self.ynLoaded) {
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
        
        [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.refreshBtn.transform = endAngle;
        } completion:^(BOOL finished) {
            self.angle += 10;
            [self startAnimation];
        }];
    }else{
        CGAffineTransform endAngle = CGAffineTransformMakeRotation((self.angle+90) * (M_PI / 180.0f));
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.refreshBtn.transform = endAngle;
        } completion:^(BOOL finished) {
            self.angle += 10;
        }];
    }
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


//- (IBAction)showSuccessNotification:(id)sender {
//    [LeafNotification showInController:self withText:@"我是一个粉刷匠" type:LeafNotificationTypeSuccess];
//}
//-(void)viewDidAppear:(BOOL)animated{
////    NSLog(@"adfasdf");
//}
-(void)viewWillAppear:(BOOL)animated{
    if (animated == NO) {
        //        CGRect rect = self.tableView.frame;
        //        rect.origin.y = rect.origin.y - 50;
        //        self.tableView.frame = rect;
        //        UIEdgeInsets contentInset = self.tableView.contentInset;
        //        self.tableView.contentInset = UIEdgeInsetsMake(50, contentInset.left, contentInset.bottom, contentInset.right);
//        [self.tableView setContentOffset:CGPointMake(0, -50) animated:YES];
//        //刷新
//        [_ptr customPullToLoadNewShowAnimation];
    }
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    }
}
-(void)loadBOOOK{
    [self.refreshControl beginRefreshing];
    [self performSelector:@selector(getHttpList) withObject:nil afterDelay:2];
    [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
//    //刷新
//    [_ptr customPullToLoadNewShowAnimation];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[StoreBookInfoView sharedInstance]hidden];
//    [[WxxAlertView sharedInstance]hidden];
}

//更新有修改的书籍信息， 最多的是价格修改
-(void)getBookListByUpdate{
    
    NSString *lastupdate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastupdate"];
    if (!lastupdate) {
        [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
        return;
    }
    
    NSString *maxBookId = [[PenSoundDao sharedPenSoundDao]selectMaxBook_id:self.classId];
    if (!maxBookId) {
        maxBookId = @"0";
    }
    
    //三个参数： 分类id, 本地最大book_id(获取更新的信息只能比最大id小， 大的则是新的数据), 最后更新时间（获取比最后时间大的更新数据）
    [SVHTTPRequest GET:[WXXHTTPUTIL getBookListByUpdate]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.classId,@"class_id",
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
                    //刷新
//                    [self reloadData];
                }
                
            }];
}

-(void)getHttpList{
    //查询当前本地最大记录，去服务端取更大记录
    NSString *maxBookId = [[PenSoundDao sharedPenSoundDao]selectMaxBook_id:self.classId];
    if (!maxBookId || maxBookId == nil) {
        maxBookId = @"0";
    }
//    maxBookId = @"0";
    [[WxxLoadView sharedInstance]showself];
    [SVHTTPRequest GET:[WXXHTTPUTIL getBookList]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.classId,@"class_id",//根据分类查询书籍
                        maxBookId,@"book_id",
//                        100,@"limit_num",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                self.ynLoaded = YES;
                [[WxxLoadView sharedInstance]hideSelf];
                if (response) {
                    if ([response count]<=0) {
                        [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"loadNilBook", nil)];
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:NSLocalizedString(@"loadNilBook", nil)];
                    }else{
//                        [[WxxAlertView sharedInstance]hidden];
                    }
                    for (int i=0; i<[response count]; i++) {
                        BookData *bookData =[BookData initWithDictionary:[response objectAtIndex:i]];
                        [bookData saveSelfToDB];
                    }
                }else{
                    [[WxxPopView sharedInstance] showPopText:NSLocalizedString(@"loadNilBook", nil)];
                }
                [[WxxLoadView sharedInstance]hideSelf];
//                [self performSelector:@selector(hideLoad) withObject:nil afterDelay:0.5];
                [self reloadData];
            }];
}
//-(void)hideLoad{
//[[WxxLoadView sharedInstance]hideSelf];
//}

-(void)reloadData{
    //重新设置现在book表的最大书本数目
    [[PenSoundDao sharedPenSoundDao]setMaxNum:self.classId];
    
    //查询书籍列表
    self.bookArrDic = [[PenSoundDao sharedPenSoundDao]selectBookList:noDown limit:20 classId:self.classId];;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        [self.refreshControl endRefreshing];
    }
 
    [self.tableView reloadData];
//    [self scrollTableToFoot:YES];
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
    if ([self.bookArrDic count] == 0 && self.ynLoaded) {
        return 1; // a single cell to report no data
    }
    if (self.ynLoaded) {
        return [self.bookArrDic count]+1;
    }
    return [self.bookArrDic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.bookArrDic count]) {
        return 75;
    }
    if(self.selectedCellIndexPath != nil
       && [self.selectedCellIndexPath compare:indexPath] == NSOrderedSame){
        
        return self.selectCellHeight;
    }
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.bookArrDic count] == 0 && self.ynLoaded) {
        static NSString *CellIdentifier = @"nothing_cell";
        
        StoreNothingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[StoreNothingCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text= @"好像没有搜到任何书籍";
        //whatever else to configure your one cell you're going to return
        return cell;
    }
    
    
    
    if (indexPath.row >= [self.bookArrDic count] && self.ynLoaded) {
        
//        NSLog(@"加号%d",indexPath.row);
        static NSString *CellIdentifier = @"load_cell";
        
        StoreLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        int iii = (int)[PenSoundDao sharedPenSoundDao].limitMaxNum - (int)indexPath.row;
        if (cell == nil) {
            cell = [[[StoreLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier] autorelease];
            
            [cell receiveObject:^(id object) {
//                int iii = (int)[PenSoundDao sharedPenSoundDao].limitMaxNum - (int)indexPath.row;
                int ynload = [object intValue];
                if (ynload == 0) { //大于0说明还有数据没加载完
                    //查询书籍列表
//                    self.bookArrDic = [[PenSoundDao sharedPenSoundDao]selectBookList:noDown limit:20];;
                    self.bookArrDic = [[PenSoundDao sharedPenSoundDao]selectBookList:noDown limit:20 classId:self.classId];;
//                    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
////                        [self.refreshControl endRefreshing];
//                    }
//                    [self endSearch];
                    [self.tableView reloadData];
                }else{
                    [self loadBOOOK];
                }
                
            }];
        }
        
        if (iii<=0) {
            [cell setBtnTextToLoaded];
        }else{
            [cell setBtnTextTonext];
        }
        return cell;
    }else{
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
        
        [cell setCellInfo:bookData row:[NSString stringWithFormat:@"%d",[PenSoundDao sharedPenSoundDao].limitMaxNum - (int)indexPath.row]];
        
        //如果滑出的行是前面点击行，把介绍显示完全
        if (self.selectedCellIndexPath.row == indexPath.row) {
            //刷新点击行
            
            [cell highCell];
        }
        return cell;
    }

    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)nativeFeedback{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFeedback" object:nil];
}

 


@end
