//
//  StoreTableVeiwCell.m
//  epub
//
//  Created by weng xiangxun on 14-3-2.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "StoreTableVeiwCell.h"
#import "SDImageView+SDWebCache.h"
#import "WxxAlertView.h"
#import "SVHTTPRequest.h"
#import "BookData.h"
#import "ResourceHelper.h"
#import "WxxIapStore.h"
#import "YLLabel.h"
#import "ClassData.h"
#import "BlackView.h"
#import "UIImageView+Curled.h"

#define intrductionDefualtHeigt 35
@interface StoreTableVeiwCell()
@property (nonatomic, strong) BookData *bookData;
@property (nonatomic,strong)UIView *view;

@end

@implementation StoreTableVeiwCell

-(void)dealloc{
    [_bookIntroduction release];
    [_bookImgV release];
    [_bookData release];
    [_bookIdLb release];
    [_bookTitleLb release];
    [_bookAuthorLb release];
    [_buyBtn release];
    [_newImageV release];
    [_bookSize release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.view = [[[UIView alloc]initWithFrame:CGRectMake(5, 5, UIBounds.size.width-10, 105)] autorelease];
        self.view.layer.cornerRadius = 3;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
//        view.backgroundColor = WXXCOLOR(255, 255, 255, 0.6);
        self.view.backgroundColor = WXXCOLOR(255, 255, 255, 0.9);
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123123.png"]];
        self.view.layer.shadowOffset = CGSizeMake(0, 1);
        self.view.layer.shadowRadius = 1;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOpacity = 0.1;
        [self.contentView addSubview:self.view];
        
        
        self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 80)] autorelease];
     
        [self.bookImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.bookImgV.layer setBorderWidth:0.3f];
        self.bookImgV.layer.cornerRadius = 3;
        self.bookImgV.layer.masksToBounds = YES;
//        [self.contentView addSubview:self.bookImgV];
        
        
        UIView *headView = [[[UIView alloc]initWithFrame:CGRectMake(15, 15, 60, 80)] autorelease];
        headView.backgroundColor = [UIColor whiteColor];
        //        self.imgV.layer.masksToBounds = YES;
        [self.contentView addSubview:headView];
        headView.layer.cornerRadius = 5;
        headView.layer.shadowPath = [UIBezierPath bezierPathWithRect:headView.bounds].CGPath;
        headView.layer.shadowOffset = CGSizeMake(1, 1.0f);
        headView.layer.shadowRadius = 2;
        headView.layer.shadowColor = [UIColor blackColor].CGColor;
        headView.layer.shadowOpacity = 0.6;
        
        [headView addSubview:self.bookImgV];
        
        
        
        
        self.bookIdLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+10,
                                                                   CGRectGetMinY(headView.frame),
                                                                   200, 50) font:fontTTFToSize(10)] autorelease];
        self.bookIdLb.text =@"o";
        self.bookIdLb.textColor = WXXCOLOR(0, 0, 0, 0.54);;
        [self.contentView addSubview:self.bookIdLb];
        [self.bookIdLb resetLineFrame];
        
        
        self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+10,
                                                                     CGRectGetMaxY(self.bookIdLb.frame)+2,
                                                                      200, 50) font:fontTTFToSize(18)] autorelease];
        self.bookTitleLb.text =@"name";
        self.bookTitleLb.textColor = WXXCOLOR(0, 0, 0, 0.54);;
        [self.contentView addSubview:self.bookTitleLb];
//        self.bookTitleLb.backgroundColor = [UIColor redColor];
        [self.bookTitleLb resetLineFrame];
        self.bookAuthorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                       CGRectGetMaxY(self.bookTitleLb.frame)+5,
                                                                       200, 20) font:fontTTFToSize(11)] autorelease];
        self.bookAuthorLb.text =@"author";
//        self.bookAuthorLb.backgroundColor = [UIColor blueColor];
        self.bookAuthorLb.textColor = [UIColor colorWithRed:233/255.f green:108/255.f blue:43/255.f alpha:1];
        [self.contentView addSubview:self.bookAuthorLb];
        [self.bookAuthorLb resetLineFrame];
        
        self.bookIntroduction = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                                                          CGRectGetMaxY(self.bookAuthorLb.frame)+5,
                                                                          UIBounds.size.width-CGRectGetMinX(self.bookTitleLb.frame)-67, 12)] autorelease];
        self.bookIntroduction.font = fontToSize(12);
        self.bookIntroduction.text = @"";
        self.bookIntroduction.alpha = 0.8;
        self.bookIntroduction.textColor = WXXCOLOR(0, 0, 0, 0.54);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//        [paragraphStyle setLineSpacing:8];//调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//        self.bookIntroduction.attributedText = attributedString;
//        [self.bookIntroduction sizeToFit];
        
//        self.bookIntroduction.backgroundColor = [UIColor redColor];
//        [self.bookIntroduction setTextColor:[UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1]];
//        self.bookIntroduction.textColor =[UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1];
        [self.contentView addSubview:self.bookIntroduction];
//        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), 320, 1)];
//        lineview.backgroundColor = [UIColor blackColor];
//        [self.contentView addSubview:lineview];
        
        UIImageView *sizeBackV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, 60, 18)];
        sizeBackV.image = [ResourceHelper loadImageByTheme:@"item_bg_selected"];
        sizeBackV.alpha = 0.9;
        [self.bookImgV addSubview:sizeBackV];
        [sizeBackV release];
        
        self.bookSize = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(headView.frame)-40,
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
                
                //不在下载的时候才能开始购买下载
                if (![WxxIapStore sharedWxxIapStore].ynDown) {
                    
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
                            [WxxIapStore sharedWxxIapStore].ynDown = false;
                            [self.bookData.progressView reHeal]; //复原
                        }
                    }];
                    
                    [self.bookData.progressView showDownloadingBefor];
                    
                    if (booktype == BTfojing || booktype == BTguwen || booktype == BTLiangyusheng || booktype == BTjinyong || booktype == BTmoyan) {//不可重复购买的选项
                        if ([self.bookData.bbook_price intValue]>0) {
                            [[WxxIapStore sharedWxxIapStore] buyGood:[self.bookData.bbook_id intValue]];
                        }else{
                            [self.bookData downFile];
                        }
                    }else{//可重复购买的选项
                        [[WxxIapStore sharedWxxIapStore] buyGood:[self.bookData.bbook_price intValue]];
                    }
                }else{
                    [[WxxPopView sharedInstance] showPopText:@"正在下载，请稍候"];
//                    [[WxxAlertView sharedInstance]showWithText:@"正在下载，请稍候"];
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
            
            [self.contentView insertSubview:[self.bookData initProgreddView:priceStr] atIndex:5];//下载动画 progressview
            [self.bookData.progressView noDownLayer];  //未下载按钮状态
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
}


-(void)setCellInfo:(BookData*)bookData row:(NSString*)row{
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    self.bookData = bookData;
    self.bookData.bbook_price = 0;
    
    self.bookIdLb.text = row;
    [self.bookIdLb resetLineFrame];
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];

    //logo采用双URL机制，优先考虑gao7服务器， 如果gao7上还没有，读取默认设置服务器的图片
    
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookData.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookData.bbook_id];
    NSString *url3 = self.bookData.bbook_doubanlogo;
    NSLog(@"%@",gao7gao8url);
//    if (booktype == BTGulong || booktype == BTjingdu || booktype == BTHanhan || booktype == BTmoyan || booktype == BTzhangailin || booktype == BTqiongyao || booktype == BTWolongsheng || booktype == BTHuangyi) {//静读时光采用豆瓣logo
//        url = gao7gao8url;
//        gao7gao8url = self.bookData.bbook_doubanlogo;
//    }
//    NSLog(@"gao7::::%@",gao7gao8url);
    if (locked) {
        gao7gao8url = nil;
        url = nil;
    }
    NSLog(@"%@",self.bookData.bbook_doubanlogo);
    self.bookImgV.url2 = [NSURL URLWithString:url];
    [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url3] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
    
    self.bookTitleLb.frame = CGRectMake(CGRectGetMaxX(self.bookImgV.frame)+10+15,
                                        CGRectGetMinY(self.bookTitleLb.frame),
                                        230, 50);;
    self.bookTitleLb.text =self.bookData.bbook_name; //书名
    [self.bookTitleLb reset2Frame];
    self.bookAuthorLb.text = [NSString stringWithFormat:@"%@",self.bookData.bbook_author]; //作者
    [self.bookAuthorLb resetLineFrame];
    self.bookAuthorLb.frame = CGRectMake(CGRectGetMinX(self.bookTitleLb.frame),
                                         CGRectGetMaxY(self.bookTitleLb.frame)+3,
                                         CGRectGetWidth(self.bookAuthorLb.frame),
                                         CGRectGetHeight(self.bookAuthorLb.frame));
    self.bookSize.text = self.bookData.bbook_size;//大小
    [self.bookSize resetLineFrame];
    self.bookSize.frame = CGRectMake(CGRectGetWidth(self.bookImgV.frame)-CGRectGetWidth(self.bookSize.frame)-2,
                                         CGRectGetMinY(self.bookSize.frame),
                                         CGRectGetWidth(self.bookSize.frame),
                                         CGRectGetHeight(self.bookSize.frame));
    
    
//    [self.bookIntroduction setNumberOfLines:1];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.bookData.bbook_introduction];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    [paragraphStyle setLineSpacing:3];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.bookData.bbook_introduction length])];
//    self.bookIntroduction.attributedText = attributedString;
//    [self.bookIntroduction sizeToFit];
    
    
    self.bookIntroduction.text = [self.bookData.bbook_introduction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [self.bookIntroduction setText:self.bookData.bbook_introduction];
//    [self.bookIntroduction reset2Frame];
//    [self.bookIntroduction setNumberOfLines:2];
//    self.bookIntroduction.lineBreakMode = NSLineBreakByTruncatingTail;
//    lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    //购买按钮
    [self initProgressView];
    
    
    
    
//    if ([self.bookData.bbook_new isEqualToString:@"1"]) { //新书 显示new图标
//        [self.bookData updateBook_newTo0]; //先改变数据库的book_new字段为0  ui依然显示new, 这是为了本次显示new,  下次打开重新加载的时候不显示new
//        if (!self.newImageV) {
//            //new图标
//            UIImage *newimg = [ResourceHelper loadImageByTheme:@"new-icon2"];
//            self.newImageV = [[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImgV.frame)-newimg.size.width/3*2*2/3, CGRectGetMinY(self.bookImgV.frame)+5, newimg.size.width/3*2, newimg.size.height/3*2)] autorelease];
//            self.newImageV.image = newimg;
//
//            [self.contentView addSubview:self.newImageV];
//        }
//        self.newImageV.hidden = NO;
//    }else{
//        if (self.newImageV) {
//            self.newImageV.hidden = YES;
//        }
//    }
    
}

//点击cell显示更多信息
-(void)highCell{
//    [self.bookIntroduction reset2Frame];
    //点击本行后，new标签消失
    if ([self.bookData.bbook_new isEqualToString:@"1"]) {
        self.bookData.bbook_new = @"0";
        [self.bookData updateSelf];
        
        [BlackView alphaAnimationTo0:self.newImageV duration:0.8];
    }
    
//    [self.bookIntroduction resetFrame:self.highHeight-CGRectGetMinY(self.bookIntroduction.frame)];
}
//cell回复到原始高度，隐藏多余信息
-(void)lowCell{
//    [self.bookIntroduction resetFrame:intrductionDefualtHeigt];
//[self.bookIntroduction resetFrameToMaxHeight:55];//
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end