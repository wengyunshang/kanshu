//
//  WxxAlertView.m
//  DontTry
//
//  Created by weng xiangxun on 13-1-18.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxAlertView.h"
#import "BlackView.h"
#import "KYButton.h"
#import "Reachability.h"
#import "ResourceHelper.h"
#import "WxxButton.h"
#import "NSString+wxx.h"
@implementation WxxAlertView
#pragma mark -
#pragma mark Singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(WxxAlertView);
- (id)initWithFrame:(CGRect)frame
{
    UIImage *img = [ResourceHelper loadImageByTheme:@"alertOrage"];
    self = [super initWithFrame:CGRectMake(-310, 65, 310, 190)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:img];
        
        self.alerLb = [[[UILabel alloc]initWithFrame:CGRectMake(0 ,0,self.frame.size.width/4/3,self.frame.size.height/4/3)] autorelease];
        
        self.alerLb.backgroundColor = [UIColor clearColor];
        self.alerLb.font = [UIFont systemFontOfSize:19];
        self.alerLb.textColor = [UIColor blackColor];
        
        //        _contextLabel.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.alerLb.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.alerLb.numberOfLines = 0;
        [self addSubview:self.alerLb];
        
        //        UILabel *tishiLb = [[UILabel alloc]initWithFrame:CGRectMake(0, img.size.height-30, self.frame.size.width/3*2, 30)];
        //        tishiLb.text = @"提示";
        //        tishiLb.textColor = [UIColor whiteColor];
        //        tishiLb.font = [UIFont systemFontOfSize:20];
        //        tishiLb.backgroundColor = [UIColor clearColor];
        //        [self addSubview:tishiLb];
        //        [tishiLb release];
        [self initCloseBtn];
    }
    return self;
}

-(void)initCloseBtn{
    WxxButton *feedbackbtn = [[WxxButton alloc]initWithFrame: CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    
    [feedbackbtn setBackgroundImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"] forState:UIControlStateNormal];
    [feedbackbtn setBackgroundImage:[ResourceHelper loadImageByTheme:@"item_bg_selectedbt"] forState:UIControlStateHighlighted];
    [self addSubview:feedbackbtn];
    feedbackbtn.titleLabel.font =fontTTFToSize(20);
    [feedbackbtn setTitle:NSLocalizedString(@"ok", nil) forState:UIControlStateNormal];
    [feedbackbtn receiveObject:^(id object) {
        [self hidden];
    }];
}

-(void)resetText:(NSString  *)text{
    
    [self showActivity];
    self.alerLb.text = text;
    float hei = [self sizeHeight:text fontSize:self.alerLb.font.pointSize];
    float width = [self sizeWidth:text fontSize:self.alerLb.font.pointSize];
    
    
    //    NSLog(@"%f--aaa-%f",hei,width);
    self.alerLb.frame = CGRectMake(self.frame.size.width/5/2, (self.frame.size.height - (width/(self.frame.size.width/4*3)+1)*hei)/2, self.frame.size.width/5*4, (width/(self.frame.size.width/4*3)+1)*hei);
}

-(void)showWithText:(NSString *)texts{
    
    [self resetText:texts];
    
    [BlackView orgXAnimation:self orgx:0 duration:0.5];
}

-(void)showWithTextWithTime:(NSString *)texts{
    
    [self resetText:texts];
    
    [BlackView orgXAnimation:self orgx:0 duration:0.5];
//    [self performSelector:@selector(hidden) withObject:nil afterDelay:3.0];
}


-(void)show{
    //    [self.alerLb setText:@"ffffffff"];
    [BlackView orgXAnimation:self orgx:0 duration:0.5];
}
-(void)hidden{
    [BlackView orgXAnimation:self orgx:-self.frame.size.width duration:0.5];
}

-(void)hiddenAndeShowNext:(NSString *)text{
    sssss = text;
    [self performSelector:@selector(showText) withObject:nil afterDelay:0.5];
    [BlackView orgXAnimation:self orgx:-self.frame.size.width OrgX2:0];
}
-(void)showText{
    [self resetText:sssss];
}

-(CGFloat)sizeWidth:(NSString*)strin fontSize:(float)pointSize{
    //    NSLog(@"%f",userName.font.pointSize);
    UIFont *ffont = [UIFont systemFontOfSize:pointSize];
//    CGSize stringSize = [strin sizeWithFont:ffont]; //规定字符字体获取字符串Size，再获取其宽度。
    
    CGFloat width = [strin stringTextWidthFont:ffont maxWidth:self.frame.size.width].width;
    ;
    return width;
}

-(CGFloat)sizeHeight:(NSString*)strin fontSize:(float)pointSize{
    //    NSLog(@"%f",userName.font.pointSize);
    UIFont *ffont = [UIFont systemFontOfSize:pointSize];
    CGSize stringSize = [strin stringTextWidthFont:ffont maxWidth:self.frame.size.width]; //规定字符字体获取字符串Size，再获取其宽度。
    CGFloat heights = stringSize.height;
    
    return heights;
}

- (void)showActivity {
//    if (!spinner) {
//        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [spinner setCenter:CGPointMake(self.frame.size.width-20, self.frame.size.height-20)]; // I do this because I'm in landscape mode
//        // spinner is not visible until started
//        [self addSubview:spinner];
//        [spinner release];
//    }
//    [self startSpinner];
}

- (void) startSpinner {
//	[spinner startAnimating];
}

- (void) stopSpinner {
//	[spinner stopAnimating];
//    spinner = nil;
}

-(void)checkNetwork{
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)dealloc{
    [_alerLb release];
    [super dealloc];
}
@end
