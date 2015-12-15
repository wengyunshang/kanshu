//
//  EVCircularProgressView.m
//  Test
//
//  Created by Ethan Vaughan on 8/18/13.
//  Copyright (c) 2013 Ethan James Vaughan. All rights reserved.
//

#import "EVCircularProgressView.h"
#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define kKYButtonInNormalSize 35.f


//********************下载完成 打钩 圆圈 ***********************//
@interface EVDownloadedProgressViewBackgroundLayer : CALayer
@property (nonatomic, strong) UIColor *tintColor;
@end

@implementation EVDownloadedProgressViewBackgroundLayer
- (id)init
{
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)theContext
{
    
    float width = 25;
    float height = 25;
    UIBezierPath* ovalPath = [UIBezierPath customBezierPathOfCheckSymbolWithRect:CGRectMake((CGRectGetWidth(self.frame)-width)/2,
                                                                                            (CGRectGetHeight(self.frame)-height)/2,
                                                                                            width,height) scale:0.5 thick:35.f * .1f];
    //// Oval 1 Drawing
//    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
//    [ovalPath addArcWithCenter: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) radius: CGRectGetWidth(self.frame) / 2 startAngle: 1195 * M_PI/180 endAngle: 2255 * M_PI/180 clockwise: YES];
    CGContextAddPath(theContext, ovalPath.CGPath);
    CGContextSetLineWidth(theContext,1);
    CGContextSetFillColorWithColor(theContext, self.tintColor.CGColor);
    CGContextFillPath(theContext);
//    CGContextStrokePath(theContext);
    CGContextSetStrokeColorWithColor(theContext, self.tintColor.CGColor);
    CGContextStrokeEllipseInRect(theContext, CGRectInset(CGRectMake((CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(self.frame))/2, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)), 1, 1));
}
@end


//**************************下载之前 正方形 圆圈 ***************//
@interface EVCircularProgressViewBackgroundLayer : CALayer
@property (nonatomic, strong) UIColor *tintColor;
@end

@implementation EVCircularProgressViewBackgroundLayer

- (id)init
{
    self = [super init];
    if (self) {
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
    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
//    CGContextSetFillColorWithColor(ctx, [UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon.png"]].CGColor);
//    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
//    CGContextStrokeEllipseInRect(ctx, CGRectInset(CGRectMake((CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(self.frame))/2, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame)), 1, 1));
    CGContextFillRect(ctx, CGRectMake(CGRectGetMidX(self.bounds) - 4, CGRectGetMidY(self.bounds) - 4, 8, 8));
}
@end

//**************************正方形  文字***********************//
@interface EVTextProgressViewBackgroundLayer : CALayer
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) NSString *text;
- (id)initwithText:(NSString *)text;
@end

@implementation EVTextProgressViewBackgroundLayer

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
//- (void)drawInContext:(CGContextRef)context {
//    UIGraphicsPushContext(context);
//    CGContextSetGrayFillColor(context, 1.0f, 1.0f);
//    CGContextFillRect(context, self.bounds);
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetShouldAntialias(context, true);
//    CGContextSetAllowsFontSmoothing(context, true);
//    CGContextSetShouldSmoothFonts(context, true);
//    CGContextSetAllowsFontSubpixelQuantization(context, true);
//    CGContextSetShouldSubpixelQuantizeFonts(context, true);
//    CGContextTranslateCTM(context, 0.0f, self.frame.size.height);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
//    CGContextSelectFont(context, "CardKit", 30.0f, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextShowText(context, "A", sizeof("A")); UIGraphicsPopContext();
//}
- (void)drawInContext:(CGContextRef)ctx
{
    
    //正方形
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextClearRect(ctx, CGRectInset(self.bounds, 1, 1));

//    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
//    CGContextStrokeRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
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
             withFont:[UIFont boldSystemFontOfSize:13]
        lineBreakMode:UILineBreakModeClip];
    UIGraphicsPopContext();
}
@end


@interface EVCircularProgressView ()
@property (nonatomic, strong) EVTextProgressViewBackgroundLayer *textLayer;       //正方形 圆圈
@property (nonatomic, strong) EVCircularProgressViewBackgroundLayer *backgroundLayer;       //正方形 圆圈
@property (nonatomic, strong) EVDownloadedProgressViewBackgroundLayer *downbackgroundLayer; //打钩 圆圈
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSString *text;
@end

@implementation EVCircularProgressView {
    UIColor *_progressTintColor;
}

-(void)yesDownLayer{
   
    self.textLayer.hidden = YES;
   
    if (!self.downbackgroundLayer) {
        EVDownloadedProgressViewBackgroundLayer *backgroundLayerg = [[EVDownloadedProgressViewBackgroundLayer alloc] init];
        backgroundLayerg.frame = self.bounds;
        backgroundLayerg.tintColor = self.progressTintColor;
        [self.layer addSublayer:backgroundLayerg];
        self.downbackgroundLayer = backgroundLayerg; //显示下载动画
        [backgroundLayerg release];
    }else{
        self.downbackgroundLayer.hidden = NO;
    }
    
}
-(void)noDownLayer{
    if (!self.downbackgroundLayer.hidden) {
        self.downbackgroundLayer.hidden = YES;
    }
    if (!self.textLayer) {
        EVTextProgressViewBackgroundLayer *textLayer = [[EVTextProgressViewBackgroundLayer alloc] initwithText:self.text];
        textLayer.frame = self.bounds;
        textLayer.tintColor = self.progressTintColor;
        [self.layer addSublayer:textLayer];
        self.textLayer = textLayer;
        [textLayer release];
    }
    if (self.textLayer.hidden) {
        self.textLayer.hidden = NO;
    }
}

- (instancetype)initWithText:(NSString*)text
{
    self = [super initWithFrame:CGRectMake(UIBounds.size.width-55, 75, 50, 25)];
    
    if (self) {
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

//请求中转圈
-(void)showDownloadingBefor{
    [self startIndeterminateAnimation];
    if (!self.textLayer.hidden) {
        /* When false layers facing away from the viewer are hidden from view.
         * Defaults to YES. Animatable. */
        self.textLayer.hidden = YES;      //隐藏文字
        if (!self.backgroundLayer) {
            EVCircularProgressViewBackgroundLayer *backgroundLayer = [[EVCircularProgressViewBackgroundLayer alloc] init];
            backgroundLayer.frame = self.bounds;
            backgroundLayer.tintColor = self.progressTintColor;
            [self.layer addSublayer:backgroundLayer];
            self.backgroundLayer = backgroundLayer;
            [backgroundLayer release];
        }else{
            self.backgroundLayer.hidden = NO;
        }
    }
}

- (void)commonInit
{
    _progressTintColor = [UIColor greenColor];
    
    // Set up the background layer
 
//    
//    EVTextProgressViewBackgroundLayer *textLayer = [[EVTextProgressViewBackgroundLayer alloc] initwithText:self.text];
//    textLayer.frame = self.bounds;
//    textLayer.tintColor = self.progressTintColor;
//    [self.layer addSublayer:textLayer];
//    self.textLayer = textLayer;
//    [textLayer release];
    
    
    // Set up the shape layer
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.progressTintColor.CGColor;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    

    
    
//    [self startIndeterminateAnimation];
}
//复原
-(void)reHeal{
    self.textLayer.hidden = NO;      //隐藏文字
    self.shapeLayer.hidden = YES;
    self.backgroundLayer.hidden = YES;
    self.downbackgroundLayer.hidden = YES;
}

#pragma mark - Accessors

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    
    if (progress > 0) {
        BOOL startingFromIndeterminateState = [self.shapeLayer animationForKey:@"indeterminateAnimation"] != nil;
        
        [self stopIndeterminateAnimation];
        if (self.shapeLayer.hidden) {
            self.shapeLayer.hidden = NO;
        }
        self.shapeLayer.lineWidth = 3;
        
        self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                              radius:CGRectGetHeight(self.frame)/2 - 2
                                                          startAngle:3*M_PI_2
                                                            endAngle:3*M_PI_2 + 2*M_PI
                                                           clockwise:YES].CGPath;
        
        if (animated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = (startingFromIndeterminateState) ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            self.shapeLayer.strokeEnd = progress;
            
            [self.shapeLayer addAnimation:animation forKey:@"animation"];
            if (progress>=1) {
//                  NSLog(@"进度条。。。%f",progress);
//                [NSThread sleepForTimeInterval:0.5f];
                //****显示已经下载状态****************
                if (!self.downbackgroundLayer) {
                    EVDownloadedProgressViewBackgroundLayer *backgroundLayerg = [[EVDownloadedProgressViewBackgroundLayer alloc] init];
                    backgroundLayerg.frame = self.bounds;
                    backgroundLayerg.tintColor = self.progressTintColor;
                    [self.layer addSublayer:backgroundLayerg];
                    self.downbackgroundLayer = backgroundLayerg; //显示下载动画
                    [backgroundLayerg release];
                }else{
                    self.downbackgroundLayer.hidden = NO;
                }
                self.backgroundLayer.hidden = YES;//隐藏未下载状态
//                [self sendObject:nil];  //下载完毕通知前方修改状态
            }else{
                self.downbackgroundLayer.hidden = YES;
            }
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    } else {
        // If progress is zero, then add the indeterminate animation
        [self.shapeLayer removeAnimationForKey:@"animation"];
        
        [self startIndeterminateAnimation];
    }
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        self.tintColor = progressTintColor;
    } else {
        _progressTintColor = progressTintColor;
        [self tintColorDidChange];
    }
}

- (UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(tintColor)]) {
        return self.tintColor;
    } else {
        return _progressTintColor;
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

- (void)tintColorDidChange
{
    self.backgroundLayer.tintColor = self.progressTintColor;
    self.shapeLayer.strokeColor = self.progressTintColor.CGColor;
}

- (void)startIndeterminateAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.backgroundLayer.hidden = YES;
    self.shapeLayer.hidden = NO;
    self.shapeLayer.lineWidth = 1;
    self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                          radius:CGRectGetHeight(self.frame)/2 - 1
                                                      startAngle:DEGREES_TO_RADIANS(348)
                                                        endAngle:DEGREES_TO_RADIANS(12)
                                                       clockwise:NO].CGPath;
    self.shapeLayer.strokeEnd = 1;
    
    [CATransaction commit];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"indeterminateAnimation"];
}

- (void)stopIndeterminateAnimation
{
    [self.shapeLayer removeAnimationForKey:@"indeterminateAnimation"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.hidden = NO;
    [CATransaction commit];
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//}

@end
