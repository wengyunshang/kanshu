//
//  EvRoundProgressView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "EvPageProgressView.h"
#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define kKYButtonInNormalSize 35.f


//**************************正方形  文字***********************//
@interface EVPageLayer : CALayer
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) NSString *text;
- (id)initwithText:(NSString *)text;
@end

@implementation EVPageLayer

- (id)initwithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.text = text;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    
    //正方形
//    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
//    CGContextStrokeRect(ctx, CGRectInset(self.bounds, 1, 1));
    //实心圆
//    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
//    CGContextFillEllipseInRect(ctx, CGRectInset(CGRectMake((CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(self.frame))/2, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)), 1, 1));
    
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(CGRectMake((CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(self.frame))/2, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)), 1, 1));
    // 将本视图的四角磨圆
    //    self.opacity = 0.8;
    //    self.masksToBounds = YES;
    //    self.cornerRadius = 5.0f;
    //文字
    if ([self.text isEqualToString:@"下载"]) {
        CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    }
    
    UIGraphicsPushContext(ctx);
    [self.text drawAtPoint:CGPointMake(10, 5)
                  forWidth:50
                  withFont:[UIFont boldSystemFontOfSize:15]
             lineBreakMode:UILineBreakModeClip];
    UIGraphicsPopContext();
}
@end


@interface EvPageProgressView ()
@property (nonatomic, strong) EVPageLayer *textLayer;       //正方形 圆圈
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSString *text;
@end

@implementation EvPageProgressView {
    UIColor *_progressTintColor;
}

- (instancetype)initWithText:(NSString*)text frame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _progressTintColor = color;
        self.text = text;
        [self commonInit];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self recgonTouche];//touch
        [self commonInit];
        
    }
    
    return self;
}

-(void)recgonTouche{
    UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:panRecognizer];//关键语句，给self.view添加一个手势监测；
    panRecognizer.numberOfTapsRequired = 1;
    panRecognizer.delegate = self;
    [panRecognizer release];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return  YES;
}


- (void)commonInit
{
    
    
    // Set up the background layer
    
    if (!self.textLayer) {
        EVPageLayer *textLayer = [[EVPageLayer alloc] initwithText:self.text];
        textLayer.frame = self.bounds;
        textLayer.tintColor = self.progressTintColor;
        [self.layer addSublayer:textLayer];
        self.textLayer = textLayer;
        [textLayer release];
    }
    
    
    // Set up the shape layer
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.progressTintColor.CGColor;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    
    
    
    //    [self startIndeterminateAnimation];
}

- (UIColor *)progressTintColor
{
    if (_progressTintColor) {
        return _progressTintColor;
    }else{
        if ([self respondsToSelector:@selector(tintColor)]) {
            return self.tintColor;
        } else {
            return _progressTintColor;
        }
    }
}

#pragma mark - UIControl overrides

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // Ignore touches that occur before progress initiates
    
    if (self.progress > 0) {
        [super sendAction:action to:target forEvent:event];
    }
}

#pragma mark - Other methods


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//}

@end