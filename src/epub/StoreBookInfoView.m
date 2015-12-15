//
//  StoreBookInfoView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-23.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "StoreBookInfoView.h"
#import "BlackView.h"
#import "WxxImageView.h"
#import "BookData.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#import "SDImageView+SDWebCache.h"
#import "BlockUI.h"
#import "ResourceHelper.h"
@interface StoreBookInfoView()
@property (nonatomic,strong)WxxImageView *bookImgV;
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookIntroduction; //介绍
@property (nonatomic,strong)WxxLabel *bookAuthorLb;
@property (nonatomic,strong)WxxLabel *bookSize;
@property (nonatomic,assign)int lineWidth;
@property (nonatomic,strong)WxxButton *closeBtn;
@property (nonatomic, strong) BookData *bookData;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation StoreBookInfoView
#pragma mark -
#pragma mark Singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(StoreBookInfoView);
-(void)dealloc{
    [_bookIntroduction release];
    [_bookImgV release];
    
    [_timer release];
    [_closeBtn release];
    [_bookData release];
    [_bookTitleLb release];
    [_bookAuthorLb release];
    [_bookSize release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(-UIBounds.size.width, 65, UIBounds.size.width-5, 230)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.alpha = 0.9;
        self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 80)] autorelease];
        
        [self.bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.bookImgV.layer setBorderWidth:0.3f];
        [self addSubview:self.bookImgV];
        
        self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+5,
                                                                      CGRectGetMinY(self.bookImgV.frame),
                                                                      200, 50) font:fontTTFToSize(18)] autorelease];
        self.bookTitleLb.text =@"name";
        self.bookTitleLb.textColor = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];
        [self addSubview:self.bookTitleLb];
        [self.bookTitleLb resetLineFrame];
        self.bookAuthorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookTitleLb.frame),
                                                                       CGRectGetMinY(self.bookTitleLb.frame)+5,
                                                                       200, 20) font:fontTTFToSize(11)] autorelease];
        self.bookAuthorLb.text =@"author";
        self.bookAuthorLb.textColor = [UIColor colorWithRed:233/255.f green:108/255.f blue:43/255.f alpha:1];
        [self addSubview:self.bookAuthorLb];
        [self.bookAuthorLb resetLineFrame];
        
        self.bookIntroduction = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                          CGRectGetMaxY(self.bookAuthorLb.frame)+8,
                                                                          220, 55) font:fontToSize(11)] autorelease];
        self.bookIntroduction.text = @"";
        self.bookIntroduction.textColor =[UIColor colorWithRed:190/255.f green:190/255.f blue:190/255.f alpha:1];
        [self addSubview:self.bookIntroduction];
        
        
        self.closeBtn = [[[WxxButton alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)-35, 65, 35)] autorelease];
        [self.closeBtn setTitle:@"close" forState:UIControlStateNormal];
        self.closeBtn.backgroundColor = [UIColor orangeColor];//[UIColor colorWithRed:88/255.f green:140/255.f blue:159/255.f alpha:1];
        [self addSubview:self.closeBtn];
        [self.closeBtn receiveObject:^(id object) {
            
            [self hidden];
            
        }];
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-3, CGRectGetWidth(self.frame), 3)];
        bottomLine.backgroundColor = self.closeBtn.backgroundColor;
        [self addSubview:bottomLine];
        [bottomLine release];
        self.lineWidth = 0;
        
        
    }
    return self;
}

-(void)addLine{
    self.lineWidth ++;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 100/255.0, 100/255.0, 100/255.0, 0.7);
    CGContextSetLineWidth(context, 2);
    
    CGPoint points[2];
    
    points[0] = CGPointMake(0,20);//这里应该是points ？？
    points[1] = CGPointMake(self.lineWidth,20);//这里应该是points ？？
    
    CGContextAddLines(context, points, 2);
    
    CGContextStrokePath(context);
//    NSLog(@"adfasdf");
}

-(void)setCellInfo:(BookData*)bookData{
    self.bookData = bookData;
    
    //    self.bookData.bbook_author  = @"傻逼傻逼大傻逼";
    //    self.bookFileUrl = self.bookData.bbook_url; //下载链接
    [self.bookImgV setImageWithURL:[NSURL URLWithString:self.bookData.bbook_coverurl] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"cellImgBack"]]; //图标
    self.bookTitleLb.text =self.bookData.bbook_name; //书名
    [self.bookTitleLb resetLineFrame];
    self.bookAuthorLb.text = [NSString stringWithFormat:@" .%@",self.bookData.bbook_author]; //作者
    [self.bookAuthorLb resetLineFrame];
    self.bookAuthorLb.frame = CGRectMake(CGRectGetMaxX(self.bookTitleLb.frame),
                                         CGRectGetMaxY(self.bookTitleLb.frame)-CGRectGetHeight(self.bookAuthorLb.frame),
                                         CGRectGetWidth(self.bookAuthorLb.frame),
                                         CGRectGetHeight(self.bookAuthorLb.frame));
    self.bookSize.text = self.bookData.bbook_size;//大小
    [self.bookSize resetLineFrame];
    self.bookSize.frame = CGRectMake(CGRectGetWidth(self.bookImgV.frame)-CGRectGetWidth(self.bookSize.frame)-2,
                                     CGRectGetMinY(self.bookSize.frame),
                                     CGRectGetWidth(self.bookSize.frame),
                                     CGRectGetHeight(self.bookSize.frame));
    self.bookIntroduction.text = self.bookData.bbook_introduction;
    [self.bookIntroduction reset2Frame];//
}

-(void)show{
    //    [self.alerLb setText:@"ffffffff"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addLine) userInfo:nil repeats:YES];
    [self.timer fire];
    [BlackView orgXAnimation:self orgx:0 duration:0.5];
}
-(void)hidden{
    [BlackView orgXAnimation:self orgx:-self.frame.size.width duration:0.5];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}

@end
