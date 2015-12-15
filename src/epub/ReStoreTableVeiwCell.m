//
//  StoreTableVeiwCell.m
//  epub
//
//  Created by weng xiangxun on 14-3-2.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ReStoreTableVeiwCell.h"
#import "SDImageView+SDWebCache.h"
#import "SVHTTPRequest.h"
#import "BookData.h"
#import "ResourceHelper.h"
#import "WxxIapStore.h"
#import "YLLabel.h"
#import "ClassData.h"
#import "BlackView.h"
#import "UIImageView+Curled.h"
@interface ReStoreTableVeiwCell()
@property (nonatomic, strong) BookData *bookData;

@end

@implementation ReStoreTableVeiwCell
-(void)dealloc{
    [_bookIntroduction release];
    [_bookImgV release];
    [_bookData release];
    [_bookTitleLb release];
    [_bookAuthorLb release];
    [_buyBtn release];
    [_booknewImageV release];
    [_bookSize release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 80)] autorelease];
        
        [self.bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.bookImgV.layer setBorderWidth:0.3f];
        self.bookImgV.layer.cornerRadius = 3;
        self.bookImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bookImgV];
        
        self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+10,
                                                                      CGRectGetMinY(self.bookImgV.frame),
                                                                      200, 50) font:fontTTFToSize(20)] autorelease];
        self.bookTitleLb.text =@"name";
        self.bookTitleLb.textColor = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];
        [self.contentView addSubview:self.bookTitleLb];
        [self.bookTitleLb resetLineFrame];
        self.bookAuthorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookTitleLb.frame),
                                                                       CGRectGetMinY(self.bookTitleLb.frame)+5,
                                                                       200, 20) font:fontTTFToSize(11)] autorelease];
        self.bookAuthorLb.text =@"author";
        self.bookAuthorLb.textColor = [UIColor colorWithRed:233/255.f green:108/255.f blue:43/255.f alpha:1];
        [self.contentView addSubview:self.bookAuthorLb];
        [self.bookAuthorLb resetLineFrame];
        
        self.bookIntroduction = [[[YLLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                         CGRectGetMaxY(self.bookAuthorLb.frame)+10,
                                                                         175, 50)] autorelease];
        self.bookIntroduction.font = fontToSize(14);
        self.bookIntroduction.text = @"";
        //        [self.bookIntroduction setTextColor:[UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1]];
        //        self.bookIntroduction.textColor =[UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1];
        [self.contentView addSubview:self.bookIntroduction];
        
        
        UIImageView *sizeBackV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, 60, 18)];
        sizeBackV.image = [ResourceHelper loadImageByTheme:@"item_bg_selected"];
        sizeBackV.alpha = 0.9;
        [self.bookImgV addSubview:sizeBackV];
        [sizeBackV release];
        
        self.bookSize = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bookImgV.frame)-40,
                                                                   56,
                                                                   200, 20) font:fontTTFToSize(7)] autorelease];
        self.bookSize.text =@"size";
        self.bookSize.textColor = [UIColor whiteColor];
        self.bookSize.font = [UIFont systemFontOfSize:12];
        [self.bookImgV addSubview:self.bookSize];
        [self.bookSize resetLineFrame];
        
        
        
    }
    return self;
}




-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    
    //处理事件
    if([touch.view isKindOfClass:[EVCircularProgressView class]]){
        
        //appstore直接去appstore下载
        if ([bookClass isEqualToString:bookAppstore]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bookData.bbook_url]];
            
        }else if ([self.bookData.bbook_down isEqualToString:noDown]) {
            
            [[WxxIapStore sharedWxxIapStore]receiveObject:^(id object) {
                
                //下载书籍
                if ([object isEqualToString:BUYSECCUSS]) {
                    if (self.bookData.bbook_price>0) {
                        //买书去广告
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ynshowad"];
                    }
                    
                }else{
                    [self.bookData.progressView reHeal]; //复原
                }
            }];
            
            if (booktype == BTfojing || booktype == BTguwen) {
                if ([self.bookData.bbook_price intValue]>0) {
                    //购买下载
                    [[WxxIapStore sharedWxxIapStore] buyGood:[self.bookData.bbook_id intValue]];
                }else{
                    //购买完毕，开始下载
                    [self.bookData downFile];//开始下载
                }
            }else{
                //购买下载
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
            NSString *priceStr = @"Do...";
            
            [self.contentView insertSubview:[self.bookData initProgreddView:priceStr] atIndex:5];//下载动画 progressview
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
    if (![self.bookData.progressView isDescendantOfView:self.contentView]) {
        [self.contentView addSubview:self.bookData.progressView];
    }
    //开始
    [self.bookData.progressView showDownloadingBefor];
    //购买完毕，开始下载
    [self.bookData downFile];//开始下载
}


-(void)setCellInfo:(BookData*)bookData{
    self.bookData = bookData;
    
    if (CGRectGetHeight(self.bookIntroduction.frame)) {
        
        [self.bookIntroduction resetFrame:50];
    }
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
    
    //logo采用双URL机制，优先考虑gao7服务器， 如果gao7上还没有，读取默认设置服务器的图片
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookData.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookData.bbook_id];
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
    
    [self.bookIntroduction setText:self.bookData.bbook_introduction];
    //    self.bookIntroduction.textColor = [UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1];
    //    [self.bookIntroduction resetFrameToMaxHeight:CGRectGetHeight(self.bookIntroduction.frame)];//
    //    self.bookIntroduction.hidden = YES;
    //购买按钮
    [self initProgressView];
    
    //计算cell点击后的总高度:  bookIntroduction的height+orginY
    self.highHeight = [self.bookIntroduction highHeight:CGRectGetWidth(self.bookIntroduction.frame)] + 8;
    if (self.highHeight < 100) {
        self.highHeight = 100;
    }
    
    if ([self.bookData.bbook_new isEqualToString:@"1"]) { //新书 显示new图标
        [self.bookData updateBook_newTo0]; //先改变数据库的book_new字段为0  ui依然显示new, 这是为了本次显示new,  下次打开重新加载的时候不显示new
        if (!self.booknewImageV) {
            //new图标
            UIImage *newimg = [ResourceHelper loadImageByTheme:@"new-icon2"];
            self.booknewImageV = [[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)-newimg.size.width/3*2*2/3, CGRectGetMinY(self.bookImgV.frame)+5, newimg.size.width/3*2, newimg.size.height/3*2)] autorelease];
            self.booknewImageV.image = newimg;
            
            [self.contentView addSubview:self.booknewImageV];
        }
        self.booknewImageV.hidden = NO;
    }else{
        if (self.booknewImageV) {
            self.booknewImageV.hidden = YES;
        }
    }
}

//点击cell显示更多信息
-(void)highCell{
    //    [self.bookIntroduction reset2Frame];
    //点击本行后，new标签消失
    if ([self.bookData.bbook_new isEqualToString:@"1"]) {
        self.bookData.bbook_new = @"0";
        [self.bookData updateSelf];
        
        [BlackView alphaAnimationTo0:self.booknewImageV duration:0.8];
    }
    [self.bookIntroduction resetFrame:self.highHeight-CGRectGetMinY(self.bookIntroduction.frame)];
}
//cell回复到原始高度，隐藏多余信息
-(void)lowCell{
    [self.bookIntroduction resetFrame:50];
    //[self.bookIntroduction resetFrameToMaxHeight:55];//
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end