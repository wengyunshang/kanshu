//
//  BookLogoView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-26.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
#import "EvLineProgressView.h"
@class WxxLabel;
@interface BookLogoView : UIView
@property (nonatomic,retain)  EvLineProgressView *lineView;
@property (nonatomic,retain) WxxLabel *tipLb;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(BookLogoView);
-(void)hideSelf;
-(void)performSelectorHideSelf;
@end
