//
//  WxxLoadView.h
//  ZWYPopKeyWords
//
//  Created by weng xiangxun on 14/12/27.
//  Copyright (c) 2014年 ZWY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
@interface WxxLoadView : UIView
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WxxLoadView);

-(void)showself;
-(void)hideSelf;
@end
