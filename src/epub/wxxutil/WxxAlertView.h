//
//  WxxAlertView.h
//  DontTry
//
//  Created by weng xiangxun on 13-1-18.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
@class KYButton;
@interface WxxAlertView : UIView{
    //    UILabel *alerLb;
    NSString *sssss;

    UIActivityIndicatorView *spinner;
}
@property (strong,nonatomic)UILabel *alerLb;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WxxAlertView);
-(void)show;
-(void)hidden;
-(void)showWithText:(NSString *)texts;
-(void)showWithTextWithTime:(NSString *)texts;
-(void)hiddenAndeShowNext:(NSString *)text;
//-(void)showEmailBtn;
//-(void)stopKbtnActivity;
@end
