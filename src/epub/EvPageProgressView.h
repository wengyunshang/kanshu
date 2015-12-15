//
//  EvPageProgressView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-8-24.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface EvPageProgressView : UIControl<UIGestureRecognizerDelegate>
//初始化
- (instancetype)initWithText:(NSString*)text;
// A value from 0 to 1 that indicates how much progress has been made
// When progress is zero, the progress view functions as an indeterminate progress indicator (a spinner)

@property (nonatomic) float progress;

// On iOS 7, progressTintColor sets and gets the tintColor property, and therefore defaults to the value of tintColor
// On iOS 6, defaults to [UIColor blackColor]

@property (nonatomic, strong) UIColor *progressTintColor;
- (instancetype)initWithText:(NSString*)text frame:(CGRect)frame;
- (instancetype)initWithText:(NSString*)text frame:(CGRect)frame color:(UIColor*)color;
@end

