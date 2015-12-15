//
//  WxxPopView.h
//  ZWYPopKeyWords
//
//  Created by weng xiangxun on 14/12/23.
//  Copyright (c) 2014年 ZWY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
@interface WxxPopView : UIView{

}
-(void)showText:(NSString*)string;
-(void)showBlackText:(NSString*)string;
-(void)showText:(NSString *)string yesBtn:(NSString*)yesStr;
-(void)showPopText:(NSString*)str;
-(void)showPopText:(NSString*)str time:(float)time;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WxxPopView);
@end
