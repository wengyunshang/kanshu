//
//  StoreHeadView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-8-24.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "StoreHeadView.h"
#import "WxxLabel.h"
#import "SDImageView+SDWebCache.h"
#import "EvPageProgressView.h"
#import "BlockUI.h"
#import "EvLineProgressView.h"
#import "WxxImageView.h"
#import "ClassData.h"
#import "BookData.h"
#import "ResourceHelper.h"
#import "WxxIapStore.h"
@interface StoreHeadView()
@property (nonatomic, strong) BookData *bookData;
@property (nonatomic,strong)WxxImageView *bookImgV;
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookAuthorLb;
@property (nonatomic,strong)WxxLabel *titleLb;
@end

@implementation StoreHeadView

-(void)dealloc{
    [_bookImgV release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame num:(NSString*)num
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIColor *color = [UIColor blueColor];
        
        EvPageProgressView *pageNumView = [[[EvPageProgressView alloc]initWithText:num frame:CGRectMake(CGRectGetWidth(self.frame)-40-10, 14, 30, 30) color:color] autorelease];
        [self addSubview:pageNumView];
        [pageNumView receiveObject:^(id object) {
            //        NSLog(@"字体变大");
            //        [addFont createBtn];
            [self sendObject:setSelectAddFont];
        }];
        
        
        
        self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(15, 14, 70, 93)] autorelease];
        
        [self.bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.bookImgV.layer setBorderWidth:0.3f];
        self.bookImgV.layer.cornerRadius = 3;
        self.bookImgV.layer.masksToBounds = YES;
        [self addSubview:self.bookImgV];
        [self.bookImgV setImageWithURL:[NSURL URLWithString:@""] url2:[NSURL URLWithString:@""] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
        
        
//        self.titleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+10, CGRectGetMinY(self.bookImgV.frame), 200, 28)] autorelease];
//        self.titleLb.text = @"今日限免";
//        self.titleLb.font = [UIFont fontWithName:@"陈继世-行楷简体" size:25];;
//        [self addSubview:self.titleLb];
        
        self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+10,
                                                                      CGRectGetMinY(self.bookImgV.frame),
                                                                      200, 50) font:[UIFont fontWithName:@"陈继世-行楷简体" size:20]] autorelease];
        self.bookTitleLb.text =@"name";
        self.bookTitleLb.textColor = [UIColor blackColor];
        [self addSubview:self.bookTitleLb];
        [self.bookTitleLb resetLineFrame];
        self.bookAuthorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                       CGRectGetMaxY(self.bookTitleLb.frame)+5,
                                                                       200, 20) font:[UIFont fontWithName:@"陈继世-行楷简体" size:16]] autorelease];
        self.bookAuthorLb.text =@"author";
        self.bookAuthorLb.textColor = [UIColor blackColor];
        [self addSubview:self.bookAuthorLb];
        [self.bookAuthorLb resetLineFrame];
        
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction)];
//        [self addGestureRecognizer:tapGesture];
        
//        [addFont release];
        
//        EvLineProgressView* lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(CGRectGetMinX(pageNumView.frame)+CGRectGetWidth(pageNumView.frame)/2, CGRectGetMaxY(pageNumView.frame)-2, 150, 1) lineColor:color] autorelease];
//        [self addSubview:lineView];
//        [lineView showLine];
    }
    return self;
}
-(void)contentViewTapAction{
    NSLog(@"123123");
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    CGPoint location = [gestureRecognizer locationInView:self.bookData.progressView];
    
//}
////处理事件
//if([touch.view isKindOfClass:[EVCircularProgressView class]]){
    if (location.x > 0 && location.y < 37) {
        
        //appstore直接去appstore下载
        if ([bookClass isEqualToString:bookAppstore]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bookData.bbook_url]];
            
        }else if ([self.bookData.bbook_down isEqualToString:noDown]) {
            
            [[WxxIapStore sharedWxxIapStore]receiveObject:^(id object) {
                
                //下载书籍
                if ([object isEqualToString:BUYSECCUSS]) {
                    if ([self.bookData.bbook_price intValue]>0) {
                        //买书去广告
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];
                    }
                    //购买完毕，开始下载
                    [self.bookData downFile];//开始下载
                }else{
                    [self.bookData.progressView reHeal]; //复原
                }
            }];
            
            [self.bookData.progressView showDownloadingBefor];
            
            if (booktype == BTfojing || booktype == BTguwen) {//不可重复购买的选项
                if ([self.bookData.bbook_price intValue]>0) {
                    [[WxxIapStore sharedWxxIapStore] buyGood:[self.bookData.bbook_id intValue]];
                }else{
                    [self.bookData downFile];
                }
            }else{//可重复购买的选项
                [[WxxIapStore sharedWxxIapStore] buyGood:[self.bookData.bbook_price intValue]];
            }
        }
        
        return NO;
    }else{
        
        return YES;
    }
}
-(void)initProgressView{
    //判断你是否下载过
    if (![self.bookData.bbook_down isEqualToString:yesDown]) {
        if (!self.bookData.progressView) {
            NSString *priceStr = @"下载";
            if (![self.bookData.bbook_price intValue] == 0) {
                priceStr = [NSString stringWithFormat:@"%@元",self.bookData.bbook_price];
            }
            [self insertSubview:[self.bookData initProgreddView:priceStr] atIndex:5];//下载动画 progressview
            CGRect rect = self.bookData.progressView.frame;
            rect.origin.y = rect.origin.y + 18;
            rect.origin.x = rect.origin.x - 5;
            self.bookData.progressView.frame = rect;
        }
        //如果下载中，不改变状态
        if (self.bookData.downType == downing) {
            
        }else{
            [self.bookData.progressView noDownLayer];  //未下载按钮状态
        }
        
    }else{
        [self.bookData.progressView yesDownLayer];  //已下载按钮状态
    }
    
    //如果本data的progressview 不存在，就加到视图里面
    if (![self.bookData.progressView isDescendantOfView:self]) {
        [self addSubview:self.bookData.progressView];
    }
}

-(void)setBookInfo:(BookData*)bookData{
    self.bookData = bookData;
    
    
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
    
    //logo采用双URL机制，优先考虑gao7服务器， 如果gao7上还没有，读取默认设置服务器的图片
    
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookData.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookData.bbook_id];
    
    if (booktype == BTjingdu) {
        url = gao7gao8url;
        gao7gao8url = self.bookData.bbook_doubanlogo;
    }
    NSLog(@"gao7::::%@",gao7gao8url);
    if (locked) {
        gao7gao8url = nil;
        url = nil;
    }
    self.bookImgV.url2 = [NSURL URLWithString:url];
    [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
    
    self.bookTitleLb.frame = CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+10,
                                        CGRectGetMinY(self.bookImgV.frame),
                                        230, 50);;
    self.bookTitleLb.text =self.bookData.bbook_name; //书名
    [self.bookTitleLb reset2Frame];
    self.bookAuthorLb.text = [NSString stringWithFormat:@" .%@",self.bookData.bbook_author]; //作者
    [self.bookAuthorLb resetLineFrame];
    self.bookAuthorLb.frame = CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                         CGRectGetMaxY(self.bookTitleLb.frame)+5,
                                         CGRectGetWidth(self.bookAuthorLb.frame),
                                         CGRectGetHeight(self.bookAuthorLb.frame));
    
    [self initProgressView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
