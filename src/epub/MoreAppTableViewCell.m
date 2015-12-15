//
//  MoreAppTableViewCell.m
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "MoreAppTableViewCell.h"
#import "SDImageView+SDWebCache.h"
#import "SVHTTPRequest.h"
#import "AppData.h"
#import "ResourceHelper.h"
#import "WxxIapStore.h"
#import "YLLabel.h"
#import "ClassData.h"
#import "BlockUI.h"
#import "BlackView.h"
#import "EVCircularProgressView.h"
#import "UIImageView+Curled.h"
@interface MoreAppTableViewCell()
@property (nonatomic, strong) AppData *appData;
@end
@implementation MoreAppTableViewCell

-(void)dealloc{
    if (_progressView) {
        [_progressView release];
    }
    [_appIntroduction release];
    [_appImgV release];
    [_appData release];
    [_appTitleLb release];
    [_buyBtn release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.appImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(15, 15, 57, 57)] autorelease];
        
        [self.appImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.appImgV.layer setBorderWidth:0.3f];
        self.appImgV.layer.cornerRadius = 6;
        self.appImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.appImgV];
        
        self.appTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.appImgV.frame)+10,
                                                                      CGRectGetMinY(self.appImgV.frame),
                                                                      200, 50) font:fontTTFToSize(15)] autorelease];
        self.appTitleLb.text =@"name";
        self.appTitleLb.textColor = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];
        [self.contentView addSubview:self.appTitleLb];
        [self.appTitleLb resetLineFrame];
        
        self.appIntroduction = [[[YLLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.appTitleLb.frame),
                                                                         CGRectGetMaxY(self.appTitleLb.frame)+20,
                                                                         175, 50)] autorelease];
        self.appIntroduction.font = fontTTFToSize(14);
        self.appIntroduction.text = @"";
        [self.contentView addSubview:self.appIntroduction];
       
        
        self.progressView = [[[EVCircularProgressView alloc]initWithText:@"下载"] autorelease];
        self.progressView.frame = CGRectMake(260, 50, 50, 25);
//        self.progressView.backgroundColor = [UIColor redColor];
        [self.progressView noDownLayer];
        [self.contentView addSubview:self.progressView];
    }
    return self;
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    
    //处理事件
    if([touch.view isKindOfClass:[EVCircularProgressView class]]){
        
        NSLog(@"下载");
//        [self sendObject:self.appData.capp_appstoreid];
//        [NSString stringWithFormat:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=%@&type=Purple+Software", self.appData.capp_appstoreid]
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appData.capp_down_url]];
        return NO;
    }else{
        
        return YES;
    }
}


-(void)setCellInfo:(AppData*)appData{
    self.appData = appData;
    
    if (CGRectGetHeight(self.appIntroduction.frame)) {
        
        [self.appIntroduction resetFrame:50];
    }
    
//    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
    
//    //logo采用双URL机制，优先考虑gao7服务器， 如果gao7上还没有，读取默认设置服务器的图片
//    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.appData.bapp_coverurl];
//    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.appData.bapp_id];
//    NSLog(@"gao7::::%@",gao7gao8url);
//    if (locked) {
//        gao7gao8url = nil;
//        url = nil;
//    }
//    self.appImgV.url2 = [NSURL URLWithString:url];
    NSString *iconurl =[NSString stringWithFormat:@"%@%@.png",httpiconurl,self.appData.capp_id];
    NSLog(@"%@",iconurl);
//    [self.appImgV setImageWithURL:[NSURL URLWithString:iconurl] url2:[NSURL URLWithString:iconurl] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"Icon"]]; //图标
    [self.appImgV setImageWithURL:[NSURL URLWithString:iconurl] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"Icon"]];
    self.appTitleLb.text =self.appData.capp_appname; //书名
    [self.appTitleLb resetLineFrame];
    
    [self.appIntroduction setText:self.appData.capp_notice];
    
    //计算cell点击后的总高度:  appIntroduction的height+orginY
    self.highHeight = [self.appIntroduction highHeight:CGRectGetWidth(self.appIntroduction.frame)] + 8;
    if (self.highHeight < 100) {
        self.highHeight = 100;
    }
}

//点击cell显示更多信息
-(void)highCell{
    //    [self.appIntroduction reset2Frame];
    //点击本行后，new标签消失
     [self.appIntroduction resetFrame:self.highHeight-CGRectGetMinY(self.appIntroduction.frame)];
}
//cell回复到原始高度，隐藏多余信息
-(void)lowCell{
    [self.appIntroduction resetFrame:50];
    //[self.appIntroduction resetFrameToMaxHeight:55];//
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
