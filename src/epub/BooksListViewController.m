#import "BooksListViewController.h"
#import "PenSoundDao.h"
#import "BookData.h"
#import "SetConfig.h"
#import "AppData.h"
#import "WxxIapStore.h"
#import "WxxAlertView.h"
#import "BookTableViewCell.h"
#import "BookReadViewController.h"
#import "BookView.h" 
#import "BookButton.h"
#import <QuartzCore/QuartzCore.h>
#define dbvheight 60

#define barquanxuan @"全选"
#define barbianji @"编辑"
#define barshangchuan @"上传"
#define barquxiao @"取消"

@interface BooksListViewController(){
BOOL _isNeedOpen;
}
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)UIView *deleteBottomView;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation BooksListViewController

@synthesize booksArr, selectedIndexPath;


- (void)dealloc
{
    [bannerView_ release];
    self.booksArr = nil;
    [super dealloc];
}
-(void)editList:(id)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    return request;
}
-(void)loadBooks{
    self.booksArr = [[PenSoundDao sharedPenSoundDao]selectMyBookList:yesDown];
    [self.tableView reloadData];
}
-(void)showMyself{
    NSLog(@"123123123123");
} 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLayoutSubviews{
    if(self.selectedIndexPath!=nil)
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                initWithTitle:barbianji
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(rightBarItemClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STHeitiSC-Light" size:16], NSFontAttributeName,nil]
                           forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:barshangchuan
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(leftBarItemClick)];
    [leftBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STHeitiSC-Light" size:16], NSFontAttributeName,nil]
                           forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    //    [self initQQAd];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.booksArr = [[[NSMutableArray alloc] init] autorelease];
    //    self.tableView.separatorColor = [UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1];
    self.navigationItem.title = NSLocalizedString(@"books", nil);
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,0,UIBounds.size.width,CGRectGetHeight(self.view.frame)-116) ] autorelease];
    self.tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 15)] autorelease];
    
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
    
    _isNeedOpen = YES;
}

-(void)showDeleteBottomView{
    
    if (!self.deleteBottomView) {
        self.deleteBottomView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, dbvheight)] autorelease];
        self.deleteBottomView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        [self.view addSubview:self.deleteBottomView];
        

        UIButton *delBtn = [[UIButton alloc]init];
        delBtn.backgroundColor = [UIColor colorWithRed:198/255.0 green:65/255.0 blue:45/255.0 alpha:1];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        delBtn.layer.cornerRadius = 3;
        delBtn.layer.masksToBounds = YES;
        [self.deleteBottomView addSubview:delBtn];
        [delBtn release];
        [delBtn addTarget:self action:@selector(delSelectedBookArr) forControlEvents:UIControlEventTouchUpInside];
        delBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.deleteBottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[delBtn]-10-|" options:0 metrics:@{@"height":@(40)} views:NSDictionaryOfVariableBindings(delBtn)]];
        [self.deleteBottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[delBtn]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delBtn)]];
//        [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[fontbtn(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(fontbtn)]];
//        [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chapterListButton(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(chapterListButton)]];
//        [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backBtn(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(backBtn)]];
    }
    if (CGRectGetMinY(self.deleteBottomView.frame)>=self.view.frame.size.height) {
        [UIView animateWithDuration:0.5 animations:^{
            self.deleteBottomView.frame = CGRectMake(0, self.view.frame.size.height-dbvheight, self.view.frame.size.width, dbvheight);
        }completion:^(BOOL finished){
            
        }];
    }
}
-(void)hideDeleteView{
    
    if (CGRectGetMinY(self.deleteBottomView.frame)<self.view.frame.size.height) {
        [UIView animateWithDuration:0.5 animations:^{
            self.deleteBottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, dbvheight);
        }completion:^(BOOL finished){
            [self.deleteBottomView removeFromSuperview];
            self.deleteBottomView = nil;
        }];
    }
}

-(void)delSelectedBookArr{
    [[PenSoundDao sharedPenSoundDao]deleteSelectedBookArr];
    self.booksArr = [[PenSoundDao sharedPenSoundDao]selectMyBookList:yesDown];
    [self leftBarItemClick]; //删除后需要退出删除界面
    [self.tableView reloadData];
}

- (void)openBooks
{
    if (_isNeedOpen) {
        NSLog(@"open books");
        
        BookReadViewController *bookReadViewController = [[BookReadViewController alloc] init];
        
        
        bookReadViewController.modalTransitionStyle = UIModalTransitionStyleOpenBooks;
        
        [self presentViewController:bookReadViewController animated:YES completion:^{
            NSLog(@"complete");
        }];
        
        _isNeedOpen = NO;
    }
    else
    {
        
        NSLog(@"close books");
    
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        _isNeedOpen = YES;
    }
    
}



-(void)leftBarItemClick{

    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:barshangchuan]) {
        self.blType = blShangchuan;
            //上传
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startHttpServer" object:nil];
        
    }else{
        self.blType = blQuxiao;
        //取消删除界面
        [self hideDeleteView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabs" object:nil];
        self.navigationItem.rightBarButtonItem.title = barbianji;
        self.navigationItem.leftBarButtonItem.title = barshangchuan;
        self.booksArr = [[PenSoundDao sharedPenSoundDao]selectMyBookList:yesDown];
        [self.tableView reloadData];
    }
    
}

-(void)rightBarItemClick{
    
    //如果按钮是"编辑"文字点击，跳到删除界面
    NSLog(@"%@",self.navigationItem.rightBarButtonItem.title);
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:barbianji]) {
        self.blType = blBianji;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabs" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDeleteBottomView) name:@"showDeleteBottomView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDeleteView) name:@"hideDeleteView" object:nil];

        
        self.navigationItem.rightBarButtonItem.title = barquanxuan;
        self.navigationItem.leftBarButtonItem.title = barquxiao;
        [self.tableView reloadData];
    }else{
        
        //如果按钮是"全选"文字点击，全部选择书本
        
        //***************代码不可以改变顺序＊＊＊＊＊／／
        self.blType = blQuanxuan;

        [self.tableView reloadData];
        
        [self showDeleteBottomView];
    }
        
    
 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self loadBooks];
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
    if (!YNSHOWGOOLEAD || [[AppData sharedAppData] getAdmoveIsOpen] == 0 || locked) {
//        if (booktype == BTjingdu) {
//            [self loadBaiduAdview];
//        }else{
        
//        }
        if (bannerView_) {
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect rect = self.tableView.frame;
                rect.origin.y = 0;
                rect.size.height = UIBounds.size.height-116;
                self.tableView.frame = rect;
            }completion:^(BOOL finished){
                
            }];
            bannerView_.hidden = YES;//如果有广告就隐藏
            
        }
    }else{
//        [self loadAdmob];
    }
    

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    //    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
    //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    //    }else{
    //        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return bookHeight +20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i =    ceil(self.booksArr.count/3.0);
    // Return the number of rows in the section.
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell receiveObject:^(id object) {
            BookButton *bookv = object;
            _bookView = bookv;
            BookReadViewController *bookReadViewController = [[BookReadViewController alloc] init];
            bookReadViewController.modalTransitionStyle = UIModalTransitionStyleOpenBooks;
            [self presentViewController:bookReadViewController animated:YES completion:^{
                NSLog(@"complete");
            }];
        }];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int row1 = (int)(indexPath.row)*3;
    int row2 = (int)(indexPath.row)*3+1;
    int row3 = (int)(indexPath.row)*3+2;
    if (row1<self.booksArr.count) {
        BookData *bookdata1 = [self.booksArr objectAtIndex:row1];
        [cell setBookData1:bookdata1];
    }else{
        [cell setBookData1:nil];
    }
    if (row2<self.booksArr.count) {
        BookData *bookdata2 = [self.booksArr objectAtIndex:row2];
        [cell setBookData2:bookdata2];
    }else{
        [cell setBookData2:nil];
    }
    if (row3<self.booksArr.count) {
        BookData *bookdata3 = [self.booksArr objectAtIndex:row3];
        [cell setBookData3:bookdata3];
    }else{
        [cell setBookData3:nil];
    }
    if (self.blType == blBianji || self.blType == blQuxiao) {
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:barquanxuan]) {
            [cell showDelBtn];
        }else{
            [cell hideDelBtn];
        }
    }else if (self.blType == blQuanxuan){
        
        //设置全部书籍选中
        [cell setBookSelected];
    }
    //    [cell setCellInfo:bookData];
    //    int row = [self.booksArr count] -  indexPath.row - 1;//倒序显示
    //    BookData *bookData = [self.booksArr objectAtIndex:row];
    
    //    cell.textLabel.text = bookData.bbook_name;
    
    //    cell.textLabel.text = @"asdf";//[[[[[data objectAtIndex:[indexPath section]] objectForKey:@"data"] objectAtIndex:[indexPath row]] objectForKey:@"title"] stringByDeletingPathExtension];
    return cell;
}

-(void)loadAdmob{
    if (!bannerView_) {
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
        // Specify the ad unit ID.
        NSString*admobid = [[AppData sharedAppData] getAdmobId];
        if (!admobid) {
            admobid = admobId;
        }
        bannerView_.adUnitID = admobid;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        bannerView_.delegate = self;
        
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
}
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view addSubview:bannerView_];
        CGRect rect = self.tableView.frame;
        rect.origin.y = CGRectGetMaxY(bannerView_.frame);
        rect.size.height = UIBounds.size.height-116 - 50;
        self.tableView.frame = rect;
    }completion:^(BOOL finished){
        
    }];
    
    NSLog(@"广告出来了");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"广告错误");
}


 //-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
////  if (booktype == BTchuanyue) { //是否显示 上传书籍功能（注：上传书籍功能只提供给某些特定到应用，比如： 小说阅读，静读时光阅读器等， 可根据后期需求添加修改）
////    return 50;
////  }
////    return 0;
//    if (booktype == BTHanhan) {
//        //服务端是否开启广告
//        if ([[AppData sharedAppData] getAdmoveIsOpen] == 0) {
//            return 0;
//        }
//        BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
//        if (!YNSHOWGOOLEAD) {
//            return 0;
//        }
//        if (locked) {
//            return 0;
//        }else{
//
//            return 50;
//        }
//    }
//    return 0;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    if (booktype == BTHanhan) {
//        BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ynshowad"] boolValue];
//        if (!YNSHOWGOOLEAD || [[AppData sharedAppData] getAdmoveIsOpen] == 0 || locked) {
//
//            UIView *footV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 50)] autorelease];
//            return footV;
//
//        }else{
//            //             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];
//            // Create a view of the standard size at the top of the screen.
//            // Available AdSize constants are explained in GADAdSize.h.
//            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//            bannerView_.frame = CGRectMake(0, 0, UIBounds.size.width, 50);
//            // Specify the ad unit ID.
//            NSString*admobid = [[AppData sharedAppData] getAdmobId];
//            if (!admobid) {
//                admobid = admobId;
//            }
//            bannerView_.adUnitID = admobid;
//
//            // Let the runtime know which UIViewController to restore after taking
//            // the user wherever the ad goes and add it to the view hierarchy.
//            bannerView_.rootViewController = self;
//
//
//            // Initiate a generic request to load it with an ad.
//            [bannerView_ loadRequest:[GADRequest request]];
//            //广告未显示出来的背景
//            //        [bannerView_ setBackgroundColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"adbannerView"]]];
//            return bannerView_;
//        }
//    }else{
//        //上传书籍
//
//        UIView *footV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 50)] autorelease];
//        footV.backgroundColor = [UIColor whiteColor];
//
//        UIImage *btnPng =[ResourceHelper loadImageByTheme:@"btn_plus"];
//        WxxButton *addBtn = [[WxxButton alloc] initWithPoint:CGPointMake((CGRectGetWidth(footV.frame)-btnPng.size.width)/2,(CGRectGetHeight(footV.frame)-btnPng.size.height)/2) imagePng:btnPng selectImgPng:btnPng str:@""];
//        [addBtn receiveObject:^(id object) {
//            [self initHttpServer];
//        }];
//        [footV addSubview:addBtn];
//        return footV;
//    }
//
//
//}

//本地http服务，上传书籍使用
-(void)initHttpServer{
    HttpServerViewController *httpServerViewController = [[HttpServerViewController alloc] init];
    [self presentViewController:httpServerViewController animated:YES completion:nil];
    [httpServerViewController release];
    [httpServerViewController startServer];
}


//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NSLocalizedString(@"delete", nil);
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
//    NSLog(@"删除啦");
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        int row = [self.booksArr count] -  indexPath.row - 1;//倒序显示
//        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        BookData *bookData = [self.booksArr objectAtIndex:row];
//        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:bookData.bbook_file];
//
//        bookData.bbook_down = @"0"; //设置为未下载
//        [bookData updateSelf];
////        [[PenSoundDao sharedPenSoundDao]delBook4Id:bookData.bbook_id];//删除书本数据库信息
//
////        NSString *path = [[[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"path"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if([fileManager fileExistsAtPath:writableDBPath]){
//            [fileManager removeItemAtPath:writableDBPath error:nil];
//        }
//
//
//        NSArray *cachepaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *cacheDirectory = [cachepaths objectAtIndex:0];
//        NSString *strPath=[NSString stringWithFormat:@"%@/%@/",cacheDirectory,writableDBPath];
//
//        if ([fileManager fileExistsAtPath:strPath]) {
////            NSLog(@"exist");
//            NSError *error;
//            [fileManager removeItemAtPath:strPath error:&error];
//        }
//
//        [self loadBooks];
//    }
//}

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    self.selectedIndexPath = indexPath;
////    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
////
////    int row = [self.booksArr count] -  indexPath.row - 1;//倒序显示
////    BookData *bookData = [self.booksArr objectAtIndex:row];
//////    [bookData updateSelf];//更新时间，下次排序靠前
////
//////    /var/mobile/Containers/Data/Application/7AC236C8-04DF-4671-9BE0-F1173B1A1A3D/Documents/1411486819.file
//////     /var/mobile/Containers/Data/Application/F02922CA-40EB-4307-82A3-147DC2F1CFC1/Documents/1411486812.file
//////     NSString *writableDBPath = [NSString stringWithFormat:@"epubbook/%@",bookData.bbook_file];
//////    NSLog(@"%@",writableDBPath);
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBooks" object:bookData];
//}



// 请求⼲⼴广告条数据成功后调⽤用
- (void)bannerViewDidReceived{
    NSLog(@"111111");
}
// 请求⼲⼴广告条数据失败后调⽤用
- (void)bannerViewFailToReceived:(int)errCode{
    NSLog(@"%s",__FUNCTION__);
} // 应⽤用进⼊入后台时调⽤用
- (void)bannerViewWillLeaveApplication{
    NSLog(@"3333");
}
// 广告条曝光回调
- (void)bannerViewWillExposure{
    NSLog(@"4444");
}
// 广告条点击回调
- (void)bannerViewClicked{
    NSLog(@"5555");
}
// banner条被⽤用户关闭时调⽤用
- (void)bannerViewWillClose{
    NSLog(@"666");
}
@end

