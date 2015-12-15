//
//  BookFeedBackViewController.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/11/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "BookFeedBackViewController.h"
#import "WxxLabel.h"
#import "BlackView.h"
#import "YLLabel.h"
#import "BookData.h"
#import "SDImageView+SDWebCache.h"
#import "FeedBackTableViewCell.h"
#import "EvLineProgressView.h"
#import "WxxImageView.h"
#import "AppDelegate.h"
#import "SVHTTPRequest.h"
#import "ClassData.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "FeedBackData.h"
#import "WxxTextFieldBarView.h"
#import "ResourceHelper.h"

@interface BookFeedBackViewController()
@property (nonatomic,strong)WxxLabel *authorTitleLb;
@property (nonatomic,strong)WxxLabel *authorLb;
@property (nonatomic,strong)YLLabel *bookIntroduction; //介绍
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookLb;
@property (nonatomic,strong)BookData *bookdata;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)NSMutableArray *feedArrDic;
@property (nonatomic,strong)UITableView *feedtableview;
@end
#define textFieldViewHeight 40
@implementation BookFeedBackViewController
{
WxxTextFieldBarView *_textFiledBarView;
}
-(void)dealloc{
    if (interstitial_) {
        interstitial_.delegate = nil;
        [interstitial_ release];
    }
   
    if (_authorTitleLb) {
        [_authorTitleLb  release];
    }
    if (_authorLb) {
        [_authorLb  release];
    }
    if (_feedtableview) {
        [_feedtableview  release];
    }
    if (_feedArrDic) {
        [_feedArrDic  release];
    }
    if (_bookIntroduction) {
        [_bookIntroduction  release];
    }
    if (_bookLb) {
        [_bookLb  release];
    }
    if (_headView) {
        [_headView  release];
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTab" object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
//    if (booktype==BTjinyong) {
//        [self showInterstitial:nil];
//    }
    
    
}

//***************admob************************//
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    UIAlertView *alert = [[[UIAlertView alloc]
                           initWithTitle:@"GADRequestError"
                           message:[error localizedDescription]
                           delegate:nil cancelButtonTitle:@"Drat"
                           otherButtonTitles:nil] autorelease];[alert show];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}
- (IBAction)showInterstitial:(id)sender {
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
 GADRequest *request = [GADRequest request];
    self.interstitial = [[[GADInterstitial alloc] initWithAdUnitID:appDelegate.interstitialAdUnitID] autorelease];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest: request];
}//***************admob************************//

-(void)setBookData:(BookData *)bookData{
    _bookdata = bookData;
    self.feedArrDic = nil;
    
    self.feedtableview = [[[UITableView alloc]initWithFrame:CGRectMake(0,0,UIBounds.size.width,self.view.frame.size.height-textFieldViewHeight) ] autorelease];
    self.feedtableview.dataSource = self;
    
    self.feedtableview.delegate = self;
    self.feedtableview.backgroundColor = [UIColor clearColor];
    //    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:self.feedtableview];
    [self.feedtableview setTableHeaderView:[self headView]];
    
    [self getFeedbackList];
    [self initWxxTextFBarView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [self.feedtableview addGestureRecognizer:singleFingerOne];
    [singleFingerOne release];
}


-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)gestureRecognizer{
    
//    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    [_textFiledBarView hideKeyborder];
}


-(UIView *)headView{
    
    CGRect rect = CGRectMake(0, 0, UIBounds.size.width, self.feedtableview.frame.size.height-textFieldViewHeight);
    UIView *headview = [[[UIView alloc]initWithFrame:rect] autorelease];
    headview.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    
    WxxImageView* bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-90)/2, 20, 90, 120)] autorelease];
    
    [bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
    [bookImgV.layer setBorderWidth:0.3f];
    bookImgV.layer.cornerRadius = 3;
    bookImgV.layer.masksToBounds = YES;
    [headview addSubview:bookImgV];
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookdata.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookdata.bbook_id];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    if (booktype == BTjingdu) {//静读时光采用豆瓣logo

        url = gao7gao8url;
        gao7gao8url = self.bookdata.bbook_doubanlogo;
    }
    bookImgV.url2 = [NSURL URLWithString:url];
    [bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
    
    
    EvLineProgressView* lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bookImgV.frame)+5, UIBounds.size.width-15*2, 1) lineColor:[UIColor lightGrayColor]] autorelease];
    [headview addSubview:lineView];
    [lineView showLine];
    int fontSize = 16;
    int orgX = 16;
//    UIColor *colors = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];;
    self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(orgX, CGRectGetMaxY(lineView.frame)+10, 50, 30) text:@"书名:" font:fontTTFToSize(17)]autorelease];
    self.bookTitleLb.textColor = [UIColor blackColor];
    [headview addSubview:self.bookTitleLb];
    self.bookLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookTitleLb.frame), CGRectGetMinY(self.bookTitleLb.frame), 200, 30) text:self.bookdata.bbook_name font:fontTTFToSize(17)] autorelease];
    self.bookLb.textColor = [UIColor blackColor];
    [headview addSubview:self.bookLb];
    
    self.authorTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame), CGRectGetMaxY(self.bookTitleLb.frame), 50, 30) text:@"作者:" font:fontTTFToSize(fontSize)] autorelease];
    self.authorTitleLb.textColor = [UIColor blackColor];
    [headview addSubview:self.authorTitleLb];
    self.authorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.authorTitleLb.frame), CGRectGetMinY(self.authorTitleLb.frame), 200, 30) text:self.bookdata.bbook_author font:fontTTFToSize(fontSize)] autorelease];
    self.authorLb.textColor = [UIColor blackColor];
    [headview addSubview:self.authorLb];
    
    EvLineProgressView* lineView2 = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(self.authorTitleLb.frame)+10, CGRectGetWidth(lineView.frame), 1) lineColor:[UIColor lightGrayColor]] autorelease];
    [headview addSubview:lineView2];
    [lineView2 showLine];
    
    
    
    self.bookIntroduction = [[[YLLabel alloc]initWithFrame:CGRectMake(orgX,
                                                                      CGRectGetMaxY(lineView2.frame) + 10,
                                                                      UIBounds.size.width-orgX*2, 50)] autorelease];
    self.bookIntroduction.font = fontToSize(fontSize);
    
    [headview addSubview:self.bookIntroduction];
    [self.bookIntroduction setText:self.bookdata.bbook_introduction];
    
    float highHeight = [self.bookIntroduction highHeight:CGRectGetWidth(self.bookIntroduction.frame)] + 8;
    [self.bookIntroduction resetFrame:highHeight-CGRectGetMinY(self.bookIntroduction.frame)];
    
    EvLineProgressView* lineView3= [[[EvLineProgressView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.bookIntroduction.frame)+5, UIBounds.size.width-15*2, 1) lineColor:[UIColor lightGrayColor]] autorelease];
    [headview addSubview:lineView3];
    [lineView3 showLine];
//    if (CGRectGetMaxY(lineView3.frame) > rect.size.height) {
    
//    }
//    if ([self.feedArrDic count] > 0) {
        rect.size.height = CGRectGetMaxY(lineView3.frame);
        headview.frame = rect;
//    }
    
    return headview;
}


-(void)updateView{
    self.feedArrDic = [[PenSoundDao sharedPenSoundDao]selectFeedBackByBookId:self.bookdata.bbook_id];;
    [self getFindUser4IdS];
    
    [self.feedtableview reloadData];
    
    
}
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (self.feedtableview.contentSize.height > self.feedtableview.bounds.size.height) {
        yOffset = self.feedtableview.contentSize.height - self.feedtableview.bounds.size.height;
    }
    
    [self.feedtableview setContentOffset:CGPointMake(0, yOffset) animated:NO];
}


-(void)getFindUser4IdS{
    NSString *userIds = [[PenSoundDao sharedPenSoundDao]selectUserIds:self.bookdata.bbook_id];
    if (userIds) {
        [SVHTTPRequest GET:[WXXHTTPUTIL getFindUser4IdS]
                parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                            userIds,@"user_openIds",//self.bookdata.bbook_id
                            nil]
                completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                    
                    if (response) {
                        NSLog(@"%@",response);
                        //                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
                        //
                        if ([response count]>0) {
                            for (int i=0; i<[response count]; i++) {
                                UserData *userdata =[UserData initWithDictionary:[response objectAtIndex:i]];
                                [userdata saveSelfToDB];
                            }
                        }
                    }
                }];
    }
    
}

//获取评论列表
-(void)getFeedbackList{
    [SVHTTPRequest GET:[WXXHTTPUTIL getFeedBackList4BookId]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.bookdata.bbook_id,@"book_id",//self.bookdata.bbook_id
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                                if (response) {
                                    NSLog(@"%@",response);
                //                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
                //
                                    if ([response count]>0) {
                                        for (int i=0; i<[response count]; i++) {
                                            FeedBackData *feedData =[FeedBackData initWithDictionary:[response objectAtIndex:i]];
                                            [feedData saveSelfToDB];
                                        }
                                   }
                               }
                [self updateView];
            }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.feedArrDic) {
        if ([self.feedArrDic count] <= 0) {
            return 1;
        }
        return [self.feedArrDic count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.feedArrDic) {
        return 0;
    }
    if ([self.feedArrDic count] <= 0) {
        return 44;
    }
    FeedBackData *feedbackData = [self.feedArrDic objectAtIndex:indexPath.row];
    
    int width =    UIBounds.size.width - 70; 
    //计算实际frame大小，并将label的frame变成实际大小 HNsizeWithFont:fontTTFToSize(14) maxSize:size
    CGSize labelsize = [feedbackData.ffeed_text stringTextWidthFont:fontTTFToSize(14) maxWidth:width];
    
    float height = labelsize.height+41+15;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.feedArrDic count] <= 0) {
        static NSString *CellIdentifier = @"nillcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier] autorelease];
        }
         cell.textLabel.text = @"暂无评论";
        cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
         return cell;
    }else{
        static NSString *CellIdentifier = @"cate_cell";
        FeedBackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                 reuseIdentifier:CellIdentifier] autorelease];
        }
        if ([self.feedArrDic count] <= 0) {
           
        }else{
            FeedBackData *feedbackData = [self.feedArrDic objectAtIndex:indexPath.row];
            [cell setFeedInfo:feedbackData];
            
        }
         return cell;
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//输入框工具栏
-(void)initWxxTextFBarView{
    
    if ([[UserData sharedUserData] ynLogin]) {
        _textFiledBarView = [[WxxTextFieldBarView alloc]
                             initWithFrame:CGRectMake(0,
                                                      self.view.frame.size.height,
                                                      UIBounds.size.width,
                                                      textFieldViewHeight) receiveObject:^(WxxTextFieldBarViewType object) {
                             }];
        
        //发送聊天内容，并显示到本地
        [_textFiledBarView receiveObject:^(id object) {
            NSLog(@"%@",object);
            NSString *context = object;
            
            //        [UserData sharedUserData].uuser_openId
            [SVHTTPRequest GET:[WXXHTTPUTIL sendFeedbackOne]
                    parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                self.bookdata.bbook_id,@"book_id",
                                context,@"feed_text",
                                @"0",@"feed_callid",
                                [UserData sharedUserData].uuser_openId,@"user_openId",
                                nil]
                    completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                        
                        if (response) {
                            NSLog(@"%@",response);
                            //                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
                            //
                            if ([response count]>0) {
                                for (int i=0; i<[response count]; i++) {
                                    FeedBackData *feedData =[FeedBackData initWithDictionary:[response objectAtIndex:i]];
                                    [feedData saveSelfToDB];
                                }
                            }
                        }
                        [self updateView];
                        [self scrollToBottom];
                    }];
        }];
        [self.view addSubview:_textFiledBarView];
        [self.view bringSubviewToFront:_textFiledBarView];
        [BlackView orgYAnimation:_textFiledBarView orgY: self.view.frame.size.height- textFieldViewHeight duration:0.4];
        [_textFiledBarView setSelfOrgy:CGRectGetMinY(_textFiledBarView.frame)];
    }else{
        
    }
    
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
////    if ([self.feedArrDic count]<=0) {
////        return 0;
////    }
//    return textFieldViewHeight;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    
//    _textFiledBarView = [[WxxTextFieldBarView alloc]
//                         initWithFrame:CGRectMake(0,
//                                                  0,
//                                                  UIBounds.size.width,
//                                                  textFieldViewHeight) receiveObject:^(WxxTextFieldBarViewType object) {
//                         }];
//    
//    //发送聊天内容，并显示到本地
//    [_textFiledBarView receiveObject:^(id object) {
//        NSLog(@"%@",object);
//        NSString *context = object;
//        
////        [UserData sharedUserData].uuser_openId
//        [SVHTTPRequest GET:[WXXHTTPUTIL sendFeedbackOne]
//                parameters:[NSDictionary dictionaryWithObjectsAndKeys:
//                            self.bookdata.bbook_id,@"book_id",
//                            context,@"feed_text",
//                            @"0",@"feed_callid",
//                           [UserData sharedUserData].uuser_openId,@"user_openId",
//                            nil]
//                completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
//                    
//                    if (response) {
//                        NSLog(@"%@",response);
//                        //                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
//                        //
//                        if ([response count]>0) {
//                            for (int i=0; i<[response count]; i++) {
//                                FeedBackData *feedData =[FeedBackData initWithDictionary:[response objectAtIndex:i]];
//                                [feedData saveSelfToDB];
//                            }
//                        }
//                    }
//                    [self updateView];
//                }];
//    }];
//    [self.view addSubview:_textFiledBarView];
//    [self.view bringSubviewToFront:_textFiledBarView];
//    
//    return _textFiledBarView;
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.leftVC.navigationBar.hidden = YES;
//    [appDelegate.leftVC setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.leftVC.navigationBar.hidden = NO;
//    [appDelegate.leftVC setNavigationBarHidden:NO animated:YES];
    if ([[UserData sharedUserData] ynLogin]) {
       
    }else{
    }
}
#pragma clang diagnostic pop


@end
