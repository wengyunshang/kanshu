//
//  YLLabel.h
//  YLLabelDemo
//
//  Created by Eric Yuan on 12-11-8.
//  Copyright (c) 2012年 YuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+wxx.h"
@interface YLLabel : UIView
{
    NSMutableAttributedString* _string;
    UIFont* _font;
    UIColor* _textColor;
}

@property (nonatomic, strong)NSMutableAttributedString* string;
@property (nonatomic, strong)UIFont* font;
@property (nonatomic, strong)UIColor* textColor;

- (void)setText:(NSString*)text;
-(float)highHeight:(float)width;
-(void)resetFrame:(float)height;
@end
