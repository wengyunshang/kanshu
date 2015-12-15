//
//  EvRoundProgressView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "EvRoundProgressView.h"
#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
#import "BlackView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0
#define lingOrgY 200
#define lineOrgY -200
#define durationTime  1.0
#define radiusLength 20
#define kKYButtonInNormalSize 35.f
/*
 *      radius: 半径
 *        orgX: x轴位置
 *        orgY: y轴位置
 *    duration: 动画时间
 * callbackNum: 回调函数
 *  startAngle: 开始画线位置
 *    endAngle: 结束画线位置
 *   clockwise: 顺时针yes /  逆时针no
 */
struct WxxPosition {
    CGFloat radius;
    CGFloat orgX;
    CGFloat orgY;
    CGFloat duration;
    CGFloat startAngle;
    CGFloat endAngle;
    BOOL clockwise;
};
typedef struct WxxPosition WxxPosition;
CG_INLINE WxxPosition
WxxPositionMake(CGFloat radius,CGFloat orgX,CGFloat orgY,int duration,CGFloat startAngle,CGFloat endAngle,BOOL clockwise)
{
    WxxPosition p;p.radius = radius;p.orgX = orgX;p.orgY = orgY; p.duration = duration; p.startAngle = startAngle;p.endAngle = endAngle;p.clockwise = clockwise;
    return p;
}




//*****************casheplayer类别********************************//
@interface CAShapeLayer (IndieBandName)
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float orgX;
@property (nonatomic, assign) float orgY;
@property (nonatomic, assign) BOOL ynTouch;
@end
static const void *RadiusKey = &RadiusKey;
static const void *OrgXKey = &OrgXKey;
static const void *OrgYKey = &OrgYKey;
static const void *YnTouchKey = &YnTouchKey;
static const void *BtnTypeKey = &BtnTypeKey;
@implementation CAShapeLayer (IndieBandName)
@dynamic radius;@dynamic orgX;@dynamic orgY;@dynamic ynTouch;
- (float)radius {
    return [objc_getAssociatedObject(self, RadiusKey) floatValue];
}
- (void)setRadius:(float)radiusarg{
    objc_setAssociatedObject(self, RadiusKey, [NSNumber numberWithFloat:radiusarg], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)orgX {
    return [objc_getAssociatedObject(self, OrgXKey) floatValue];
}
- (void)setOrgX:(float)orgXarg{
    objc_setAssociatedObject(self, OrgXKey, [NSNumber numberWithFloat:orgXarg], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)orgY{
    return [objc_getAssociatedObject(self, OrgYKey) floatValue];
}
- (void)setOrgY:(float)orgYarg{
    objc_setAssociatedObject(self, OrgYKey, [NSNumber numberWithFloat:orgYarg], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ynTouch {
    return [objc_getAssociatedObject(self, YnTouchKey) boolValue];
}
- (void)setYnTouch:(BOOL)ynToucharg{
    objc_setAssociatedObject(self, YnTouchKey, [NSNumber numberWithFloat:ynToucharg], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end//******************类别结束*************************//

@interface EvRoundProgressView ()
@property (nonatomic,strong)NSMutableArray *layerArr;
@end
@implementation EvRoundProgressView
-(void)dealloc{
    [_shapeLayer release];
    [_onTouchshapeLayer release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame progressColor:(UIColor *)progressColor backColor:(UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        // Initialization code
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = self;
        [self addGestureRecognizer:singleFingerOne];
        [singleFingerOne release];
        
        self.progressTintColor = progressColor;
        if (backColor) {
            self.backColor = backColor;
        }
        
        [self createBtn];
    }
    return self;
}
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)gestureRecognizer{
    
//    CGPoint point = [gestureRecognizer locationInView:self];
    
    
//        if ( point.x>CGRectGetMinX(self.frame)
//            && point.x<CGRectGetMaxX(self.frame)
//            && point.y>CGRectGetMinY(self.frame)
//            && point.y<CGRectGetMaxY(self.frame)) {
//            [self createTouch];
            [UIView animateWithDuration:1.0 animations:^{
                
                self.shapeLayer.opacity = 0.2;
            }completion:^(BOOL finished){
                
                double delayInSeconds = 0.6;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
                  
                    self.shapeLayer.opacity = 1.0;
                });
            }];
            [self sendObject:nil];
//        }
}

- (id)initWithlogoFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor redColor];
        // Initialization code
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = self;
        [self addGestureRecognizer:singleFingerOne];
        [singleFingerOne release];
        
        self.progressTintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self createTouch];
        
        
        float redia = CGRectGetWidth(self.frame)/2;
        WxxPosition setBtnPst = WxxPositionMake(0, 0, (CGRectGetHeight(self.frame)-redia*2)/2+redia, durationTime, 2, 3, YES);
        [self createTouchLayer:setBtnPst width:3 color:[UIColor redColor]];//画圈
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame arrow:(int)angle
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor redColor];
        // Initialization code
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = self;
        [self addGestureRecognizer:singleFingerOne];
        [singleFingerOne release];
        
        self.progressTintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self createTouch];
        
        
        
    }
    return self;
}




-(void)createBtn{
//    NSLog(@"设置按钮");
    float redia = CGRectGetWidth(self.frame)/2 -4;
    WxxPosition setBtnPst = WxxPositionMake(redia, 4, (CGRectGetHeight(self.frame)-redia*2)/2+redia, durationTime, 2, 6, YES);
    [self initStrokeEndBtnWithPosition:setBtnPst];//画圈
}

-(void)createTouch{
//    NSLog(@"点击效果。。。。。。。。");
    if (self.onTouchshapeLayer) {
        
//        self.onTouchshapeLayer.hidden = YES;
//        NSLog(@"删除");
        self.onTouchshapeLayer = nil;
    }
//    self.progressTintColor = [UIColor blackColor];
    float redia = CGRectGetWidth(self.frame)/2 -10;
    WxxPosition setBtnPst = WxxPositionMake(redia, 10, (CGRectGetHeight(self.frame)-redia*2)/2+redia, durationTime, 2, 3, YES);
    [self createTouchLayer:setBtnPst width:3];//画圈
}


//加号
-(void)createAdd{
    int width = 20;
    int height = 20;
    //横
    [self setupLayersWithStOrgX:(CGRectGetWidth(self.frame)-width)/2 stOrgY:CGRectGetHeight(self.frame)/2 endOrgx:(CGRectGetWidth(self.frame)-width)/2+width endOrgy:CGRectGetHeight(self.frame)/2 duration:0.5];
    //竖
    [self setupLayersWithStOrgX:(CGRectGetWidth(self.frame))/2 stOrgY:(CGRectGetHeight(self.frame)-height)/2 endOrgx:(CGRectGetWidth(self.frame))/2 endOrgy:(CGRectGetHeight(self.frame)-height)/2 + height duration:0.5];
}
//减号
-(void)createDel{
    int width = 20;
    int height = 20;
    //横
    [self setupLayersWithStOrgX:(CGRectGetWidth(self.frame)-width)/2 stOrgY:CGRectGetHeight(self.frame)/2 endOrgx:(CGRectGetWidth(self.frame)-width)/2+width endOrgy:CGRectGetHeight(self.frame)/2 duration:0.5];
}

/**
 *      radius: 半径
 *        orgX: x轴位置
 *        orgY: y轴位置
 *    duration: 动画时间
 * callbackNum: 回调函数
 *  startAngle: 开始画线位置
 *    endAngle: 结束画线位置
 *   clockwise: 顺时针yes /  逆时针no
 
 */
-(void)initStrokeEndBtnWithPosition:(WxxPosition)wxxPosition{
    
    //**********基础参数，可更改****************//
    //    BOOL animated = YES;
    float progress = 1.0;
    //    wxxPosition.orgY = 200;
   
    if (!self.shapeLayer) {
        //创建layer
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.fillColor = nil;
        self.shapeLayer.radius = wxxPosition.radius; //半径
        self.shapeLayer.orgX = wxxPosition.orgX;     //x轴位置
        self.shapeLayer.orgY = wxxPosition.orgY;     //y轴位置
        self.shapeLayer.ynTouch = YES;               //允许点击
        self.shapeLayer.lineWidth = 1; //线宽度
        self.shapeLayer.strokeColor = self.progressTintColor.CGColor;
        [self.layer addSublayer:self.shapeLayer];
        self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wxxPosition.orgX + wxxPosition.radius, wxxPosition.orgY)
                                                              radius:wxxPosition.radius  //半径
                                                          startAngle:wxxPosition.startAngle*M_PI_2
                                                            endAngle:wxxPosition.startAngle*M_PI_2 + wxxPosition.endAngle*M_PI_2
                                                           clockwise:wxxPosition.clockwise].CGPath;       //圆圈
        
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (YES) ? @0 : nil;
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = 0;
        self.shapeLayer.strokeEnd = progress;
        [CATransaction setCompletionBlock:^{
//            self.shapeLayer.fillRule = @"even-odd";
            self.shapeLayer.fillMode = @"backwards";
            self.shapeLayer.fillColor = self.backColor.CGColor;
            
        }];
        [self.shapeLayer addAnimation:animation forKey:@"strokeEnd"];
        [CATransaction commit];
        [self.shapeLayer release];
    }
    
}

-(void)createTouchLayer:(WxxPosition)wxxPosition width:(int)width color:(UIColor*)color{
    
    //**********基础参数，可更改****************//
    //    BOOL animated = YES;
    float progress = 1.0;
    //    wxxPosition.orgY = 200;
    
    if (!self.onTouchshapeLayer) {
        //创建layer
        self.onTouchshapeLayer = [[CAShapeLayer alloc] init];
        self.onTouchshapeLayer.frame = self.bounds;
        self.onTouchshapeLayer.fillColor = nil;
        self.onTouchshapeLayer.radius = wxxPosition.radius; //半径
        self.onTouchshapeLayer.orgX = wxxPosition.orgX;     //x轴位置
        self.onTouchshapeLayer.orgY = wxxPosition.orgY;     //y轴位置
        self.onTouchshapeLayer.ynTouch = YES;               //允许点击
        self.onTouchshapeLayer.lineWidth = width; //线宽度
        self.onTouchshapeLayer.strokeColor = color.CGColor;
        [self.layer addSublayer:self.onTouchshapeLayer];
        self.onTouchshapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wxxPosition.orgX + wxxPosition.radius, wxxPosition.orgY)
                                                                     radius:wxxPosition.radius  //半径
                                                                 startAngle:wxxPosition.startAngle*M_PI_2
                                                                   endAngle:wxxPosition.startAngle*M_PI_2 + wxxPosition.endAngle*M_PI_2
                                                                  clockwise:wxxPosition.clockwise].CGPath;       //圆圈
        
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (YES) ? @0 : nil;
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = wxxPosition.duration;
        self.onTouchshapeLayer.strokeEnd = progress;
        [CATransaction setCompletionBlock:^{
            //            self.shapeLayer.fillRule = @"even-odd";
            self.onTouchshapeLayer.fillMode = @"backwards";
            self.onTouchshapeLayer.fillColor = self.backColor.CGColor;
            
        }];
        [self.onTouchshapeLayer addAnimation:animation forKey:@"strokeEnd"];
        [CATransaction commit];
        [self.onTouchshapeLayer release];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
        //        self.onTouchshapeLayer.hidden = YES;
        
    });
}


-(void)createTouchLayer:(WxxPosition)wxxPosition width:(int)width{
    
    //**********基础参数，可更改****************//
    //    BOOL animated = YES;
    float progress = 1.0;
    //    wxxPosition.orgY = 200;
    
    if (!self.onTouchshapeLayer) {
        //创建layer
        self.onTouchshapeLayer = [[CAShapeLayer alloc] init];
        self.onTouchshapeLayer.frame = self.bounds;
        self.onTouchshapeLayer.fillColor = nil;
        self.onTouchshapeLayer.radius = wxxPosition.radius; //半径
        self.onTouchshapeLayer.orgX = wxxPosition.orgX;     //x轴位置
        self.onTouchshapeLayer.orgY = wxxPosition.orgY;     //y轴位置
        self.onTouchshapeLayer.ynTouch = YES;               //允许点击
        self.onTouchshapeLayer.lineWidth = width; //线宽度
        self.onTouchshapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.onTouchshapeLayer];
        self.onTouchshapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wxxPosition.orgX + wxxPosition.radius, wxxPosition.orgY)
                                                                     radius:wxxPosition.radius  //半径
                                                                 startAngle:wxxPosition.startAngle*M_PI_2
                                                                   endAngle:wxxPosition.startAngle*M_PI_2 + wxxPosition.endAngle*M_PI_2
                                                                  clockwise:wxxPosition.clockwise].CGPath;       //圆圈
        
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (YES) ? @0 : nil;
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = wxxPosition.duration;
        self.onTouchshapeLayer.strokeEnd = progress;
        [CATransaction setCompletionBlock:^{
            //            self.shapeLayer.fillRule = @"even-odd";
            self.onTouchshapeLayer.fillMode = @"backwards";
            self.onTouchshapeLayer.fillColor = self.backColor.CGColor;
            
        }];
        [self.onTouchshapeLayer addAnimation:animation forKey:@"strokeEnd"];
        [CATransaction commit];
        [self.onTouchshapeLayer release];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
        //        self.onTouchshapeLayer.hidden = YES;
        
    });
}


/**
 *      radius: 半径
 *        orgX: x轴位置
 *        orgY: y轴位置
 *    duration: 动画时间
 * callbackNum: 回调函数
 *  startAngle: 开始画线位置
 *    endAngle: 结束画线位置
 *   clockwise: 顺时针yes /  逆时针no
 
 */
-(void)createTouchLayer:(WxxPosition)wxxPosition{
    
    //**********基础参数，可更改****************//
    //    BOOL animated = YES;
    float progress = 1.0;
    //    wxxPosition.orgY = 200;
    
    if (!self.onTouchshapeLayer) {
        //创建layer
        self.onTouchshapeLayer = [[CAShapeLayer alloc] init];
        self.onTouchshapeLayer.frame = self.bounds;
        self.onTouchshapeLayer.fillColor = nil;
        self.onTouchshapeLayer.radius = wxxPosition.radius; //半径
        self.onTouchshapeLayer.orgX = wxxPosition.orgX;     //x轴位置
        self.onTouchshapeLayer.orgY = wxxPosition.orgY;     //y轴位置
        self.onTouchshapeLayer.ynTouch = YES;               //允许点击
        self.onTouchshapeLayer.lineWidth = 2; //线宽度
        self.onTouchshapeLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.onTouchshapeLayer];
        self.onTouchshapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wxxPosition.orgX + wxxPosition.radius, wxxPosition.orgY)
                                                              radius:wxxPosition.radius  //半径
                                                          startAngle:wxxPosition.startAngle*M_PI_2
                                                            endAngle:wxxPosition.startAngle*M_PI_2 + wxxPosition.endAngle*M_PI_2
                                                           clockwise:wxxPosition.clockwise].CGPath;       //圆圈
        
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (YES) ? @0 : nil;
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = wxxPosition.duration;
        self.onTouchshapeLayer.strokeEnd = progress;
        [CATransaction setCompletionBlock:^{
            //            self.shapeLayer.fillRule = @"even-odd";
            self.onTouchshapeLayer.fillMode = @"backwards";
            self.onTouchshapeLayer.fillColor = self.backColor.CGColor;
            
        }];
        [self.onTouchshapeLayer addAnimation:animation forKey:@"strokeEnd"];
        [CATransaction commit];
        [self.onTouchshapeLayer release];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
//        self.onTouchshapeLayer.hidden = YES;
        
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
//        UIImage *overlayImage = [self faceOverlayImageFromImage:_image];
//        dispatch_async(dispatch_get_main_queue(), ^{ // 2
//            [self fadeInNewImage:overlayImage]; // 3
//        });
//    });
}


/**
 画线
   stOrgx: 起点x
   stOrgy: 起点y
  endOrgx: 终点x
  endOrgy: 终点y
 duration: 时间
 */
- (void)setupLayersWithStOrgX:(float)stOrgx stOrgY:(float)stOrgy endOrgx:(float)endOrgx endOrgy:(float)endOrgy duration:(float)duration
{
    
    CGPoint midLeft = CGPointMake(stOrgx, stOrgy);   //起点
    CGPoint midRight = CGPointMake(endOrgx, endOrgy); //终点
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:midLeft];
    [path addLineToPoint:midRight];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.lineWidth = 1;
    [self.layer addSublayer:pathLayer];
    
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [CATransaction setCompletionBlock:^{
      
    }];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [CATransaction commit];
    
}

-(void)removeLayers{
    for (int i=0; i<[self.layerArr count]; i++) {
        CAShapeLayer *layer = [self.layerArr objectAtIndex:i];
        [layer removeFromSuperlayer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
