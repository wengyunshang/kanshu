//
//  WxxLabel.h
//  DontTry
//
//  Created by weng xiangxun on 13-2-5.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+wxx.h"
@interface WxxLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
-(void)resetFrame;
-(void)reset2Frame;
-(float)highHeight:(float)width;
-(void)resetLineFrame;
- (id)initWithFrame:(CGRect)frame font:(UIFont*)font;
-(void)resetFrameToMaxHeight:(float)maxheight;
- (id)initWithFrame:(CGRect)frame text:(NSString*)text font:(UIFont*)font;
-(void)reset2FrameWIthRight:(float)maxWidth rightOrg:(float)rightOrgx;
@end 
