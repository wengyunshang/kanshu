//
//  WxxAdView.h
//  epub
//
//  Created by weng xiangxun on 14-3-28.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"



@interface WxxAdView : UIView
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WxxAdView);
-(void)hideWxxAdView;
-(void)showWxxAdView;

-(void)sendDeveceInfo2Server;
@end
