//
//  EvLineProgressView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-25.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "EvLineProgressView.h"
#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
#import <QuartzCore/QuartzCore.h>

@interface EvLineProgressView ()
@end

@implementation EvLineProgressView {
    CALayer *animationLayer;
    CAShapeLayer *pathLayer;
    UIColor *lineColor;
}

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        lineColor = color;
    }
    return self;
}

- (void)setupLayers
{
    if (!lineColor) {
        lineColor = WXXCOLOR(0, 0, 0, 0.25);
    }
    if (animationLayer != nil) {
        [animationLayer removeFromSuperlayer];
    }
    animationLayer = [CALayer layer];
    animationLayer.frame = self.bounds;
    [self.layer addSublayer:animationLayer];
    
    CGPoint midLeft = CGPointMake(CGRectGetMinX(animationLayer.bounds), CGRectGetMidY(animationLayer.bounds));
    CGPoint midRight = CGPointMake(CGRectGetMaxX(animationLayer.bounds), CGRectGetMidY(animationLayer.bounds));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:midLeft];
    [path addLineToPoint:midRight];
    
    pathLayer = [CAShapeLayer layer];
    pathLayer.frame = animationLayer.bounds;
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = lineColor.CGColor;
    pathLayer.lineWidth = 1;
    [animationLayer addSublayer:pathLayer];
}

- (void)startAnimation
{
    [animationLayer removeAllAnimations];
    [pathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (void)showLine
{
    //    if (animationLayer.superlayer != nil) {
    [self setupLayers];
    //    }
    
    [self startAnimation];
}


@end
