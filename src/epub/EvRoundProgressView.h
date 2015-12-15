//
//  EvRoundProgressView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvRoundProgressView : UIView<UIGestureRecognizerDelegate>
- (id)initWithFrame:(CGRect)frame progressColor:(UIColor *)progressColor backColor:(UIColor *)backColor;
- (id)initWithlogoFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame arrow:(int)angle;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *onTouchshapeLayer;

-(void)createBtn;
-(void)createAdd;
-(void)createDel;
@end
