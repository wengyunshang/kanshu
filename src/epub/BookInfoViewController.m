//
//  BookInfoViewController.m
//  PandaBook
//
//  Created by weng xiangxun on 15/3/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BookInfoViewController.h"
#import "WxxLabel.h"
#import "WxxImageView.h"
#import "YLLabel.h"
#import "BookData.h"
#import "SDImageView+SDWebCache.h"
#import "ResourceHelper.h"
#import "ClassData.h"

@interface BookInfoViewController ()
@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)BookData *bookdata;
@property (nonatomic,strong)WxxImageView *bookImgV;     //图片
@property (nonatomic,strong)WxxLabel *bookTitleLb;      //书名
@property (nonatomic,strong)WxxLabel *bookIntroduction; //介绍
@property (nonatomic,strong)WxxLabel *bookAuthorLb;     //作者
@property (nonatomic,strong)WxxLabel *bookSize;         //大小
@property (nonatomic,strong)WxxLabel *bookIdLb;         //id
@end

@implementation BookInfoViewController

-(void)dealloc{
    [_backView release];
    [_bookImgV release];
    [_bookAuthorLb release];
    [_bookTitleLb release];
    [_bookSize release];

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    [self initScrollview];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, UIBounds.size.width-10, self.view.frame.size.height-10-45-64-12)];
    _backView.layer.cornerRadius = 3;
    _backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_backView.bounds].CGPath;
    _backView.backgroundColor = WXXCOLOR(255, 255, 255, 0.9);
//    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123123.png"]];
    _backView.layer.shadowOffset = CGSizeMake(0, 1);
    _backView.layer.shadowRadius = 1;
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOpacity = 0.2;
    [self.scrollview addSubview:_backView];
    
    [self initBookInfo];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)setBookdata:(BookData *)bookdata{
    _bookdata = bookdata;
    
    
}

-(void)initBookInfo{
    
    self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80*8/6)] autorelease];
    
    [self.bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
    [self.bookImgV.layer setBorderWidth:0.3f];
    self.bookImgV.layer.cornerRadius = 3;
    self.bookImgV.layer.masksToBounds = YES;
    //        [self.contentView addSubview:self.bookImgV];
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookdata.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookdata.bbook_id];
    NSString *url3 = self.bookdata.bbook_doubanlogo;
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
    if (locked) {
        gao7gao8url = nil;
        url = nil;
    }
    self.bookImgV.url2 = [NSURL URLWithString:url];
    [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url3] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
    
    
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(15, 19, 80, 80*8/6)];
    headView.backgroundColor = [UIColor whiteColor];
    //        self.imgV.layer.masksToBounds = YES;
    [_backView addSubview:headView];
    headView.layer.cornerRadius = 5;
    headView.layer.shadowPath = [UIBezierPath bezierPathWithRect:headView.bounds].CGPath;
    headView.layer.shadowOffset = CGSizeMake(1, 1.0f);
    headView.layer.shadowRadius = 2;
    headView.layer.shadowColor = [UIColor blackColor].CGColor;
    headView.layer.shadowOpacity = 0.6;
    [headView addSubview:self.bookImgV];
    [headView release];
    self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+16,
                                                                  CGRectGetMinY(headView.frame),
                                                                  200, 50) font:fontTTFToSize(20)] autorelease];
    self.bookTitleLb.text = self.bookdata.bbook_name;
    self.bookTitleLb.textColor = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];
    [_backView addSubview:self.bookTitleLb];
    [self.bookTitleLb resetLineFrame];
    
    self.bookAuthorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                   CGRectGetMaxY(self.bookTitleLb.frame)+8,
                                                                   200, 20) font:fontTTFToSize(13)] autorelease];
    self.bookAuthorLb.text = [NSString stringWithFormat:@"作者：%@",self.bookdata.bbook_author];
    self.bookAuthorLb.textColor = [UIColor colorWithRed:233/255.f green:108/255.f blue:43/255.f alpha:1];
    [_backView addSubview:self.bookAuthorLb];
    [self.bookAuthorLb resetLineFrame];
    
    self.bookSize = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                               CGRectGetMaxY(self.bookAuthorLb.frame)+8,
                                                               200, 20) font:fontTTFToSize(13)] autorelease];
    self.bookSize.text = [NSString stringWithFormat:@"大小：%@",self.bookdata.bbook_size];
    self.bookSize.alpha = 0.8;
    self.bookSize.textColor = [UIColor blackColor];
    [_backView addSubview:self.bookSize];
    [self.bookSize resetLineFrame];
    
    
    YLLabel* _contextLb = [[YLLabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(headView.frame)+10,
                                                          _backView.frame.size.width-30,30)];
    _contextLb.backgroundColor = [UIColor clearColor];
    [_contextLb setTextColor:[UIColor colorWithRed:15/255.0 green:20/255.0 blue:26/255.0 alpha:0.4]];
    [_contextLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15]];
    [_backView addSubview:_contextLb];
//    _contextLb.backgroundColor = [UIColor grayColor];
    
    [_contextLb setText:[NSString stringWithFormat:@"        %@",[self.bookdata.bbook_introduction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];//
    [_contextLb resetFrame:_backView.frame.size.width-30];
    [_contextLb release];
    
//    UIButton *commBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_backView.frame)-50-10, CGRectGetMaxY(headView.frame)-22.5, 60, 30)];
////    commBtn.backgroundColor = [UIColor grayColor];
//    commBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    [commBtn setTitle:@"评论" forState:UIControlStateNormal];
//    [commBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [_backView addSubview:commBtn];
//    [commBtn addTarget:self action:@selector(showComm) forControlEvents:UIControlEventTouchUpInside];
//    [commBtn release];
    
    
    CGRect rect = _backView.frame;
    rect.size.height = CGRectGetMaxY(_contextLb.frame)+10;
    if (rect.size.height>self.view.frame.size.height-10-45-64) {
        _backView.frame = rect;
        _backView.layer.cornerRadius = 3;
        _backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_backView.bounds].CGPath;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.shadowOffset = CGSizeMake(0, 1);
        _backView.layer.shadowRadius = 1;
        _backView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backView.layer.shadowOpacity = 0.2;
        [self.scrollview setContentSize:CGSizeMake(UIBounds.size.width,_backView.frame.size.height+15)];
    }

}
 


-(void)initScrollview{
//    UIImage *image = [UIImage imageNamed:@"mycenter.png"];
//    NSInteger pages = 12;
    
    self.scrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UIBounds.size.width, self.view.frame.size.height-52-64)] autorelease];
    
    self.scrollview.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.scrollview.showsVerticalScrollIndicator = NO;
    //    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollview.bounces = YES;
    self.scrollview.alwaysBounceVertical = YES;
    //        self.scrollView.decelerationRate = 1000;
    //        self.scrollView.bouncesZoom = NO;
//    self.scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.scrollview.frame), CGRectGetHeight(self.scrollview.frame));
    self.scrollview.delegate = self;
    //    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
//    self.scrollview.pagingEnabled = YES;
    //    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollview];
    
}
- (void)createPages:(NSInteger)pages {
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
