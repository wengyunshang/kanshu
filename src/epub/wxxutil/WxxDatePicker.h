//
//  WxxDatePicker.h
//  driftbottle
//
//  Created by weng xiangxun on 13-8-9.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WxxDatePicker : UIDatePicker
@property (nonatomic, strong) UIDatePicker *datePickerView;
-(void)cancelDatePicker;
-(void)showDatePicker;
-(void)initDatePicker:(UIView *)view;
@end
