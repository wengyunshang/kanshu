//
//  EvSetingProgressView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-30.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "EvSetingProgressView.h"
#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
#import "BlackView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

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
    btnType callbackNum;
    CGFloat startAngle;
    CGFloat endAngle;
    BOOL clockwise;
};
typedef struct WxxPosition WxxPosition;
CG_INLINE WxxPosition
WxxPositionMake(CGFloat radius,CGFloat orgX,CGFloat orgY,int duration,btnType callbackNum,CGFloat startAngle,CGFloat endAngle,BOOL clockwise)
{
    WxxPosition p;p.radius = radius;p.orgX = orgX;p.orgY = orgY; p.duration = duration;p.callbackNum = callbackNum; p.startAngle = startAngle;p.endAngle = endAngle;p.clockwise = clockwise;
    return p;
}




//*****************casheplayer类别********************************//
@interface CAShapeLayer (IndieBandName)
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float orgX;
@property (nonatomic, assign) float orgY;
@property (nonatomic, assign) btnType btnType;
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

- (btnType)btnType {
    return [objc_getAssociatedObject(self, BtnTypeKey) boolValue];
}
- (void)setBtnType:(btnType)btnType{
    objc_setAssociatedObject(self, BtnTypeKey, [NSNumber numberWithFloat:btnType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end//******************类别结束*************************//

@interface EvSetingProgressView ()
@property (nonatomic,strong)NSMutableArray *layerArr;
@end

@implementation EvSetingProgressView{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = self;
        [self addGestureRecognizer:singleFingerOne];
        [singleFingerOne release];
    }
    return self;
}


-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:self];

    for (int i=0; i<[self.layerArr count]; i++) {
        CAShapeLayer *layer = [self.layerArr objectAtIndex:i];
        NSLog(@"%f----%f----%f---%f",point.x,point.y,layer.orgY,layer.orgX);
        NSLog(@"TOUCH_ 画画 -- orgX:%f--orgY:%f-----up:%f----down:%f",layer.orgX,layer.orgX+layer.radius*2,layer.orgY-layer.radius,layer.orgY+layer.radius);
        if ( point.x>layer.orgX
            && point.x<layer.orgX+layer.radius*2
            && point.y>layer.orgY-layer.radius
            && point.y<layer.orgY+layer.radius) {
//            layer.opacity = 0;
//            [UIView animateWithDuration:1.0 animations:^{
//                layer.opacity = 1.0;
//            }];
            //按钮按下去的时候
            switch (layer.btnType) {
                case btnSet:
                    NSLog(@"设置按妞");
                    [self showLineToOrgX:layer.orgX callBack:btnTtfSize];
                    break;
                case btnTtfSize:
                    NSLog(@"字体按妞");
                    [self showVerticalLineToOrgX:layer.orgX+25 storgY:-layer.orgY+25 endOrgY:-layer.orgY+35 callBack:btnTtfSizeAdd];
                    break;
                case btnColor:
                    NSLog(@"颜色按妞");
                    break;
                    
                case btnLight:
                    
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (void)setupLayersWithStOrgX:(float)stOrgx stOrgY:(float)stOrgy endOrgx:(float)endOrgx endOrgy:(float)endOrgy duration:(float)duration callback:(btnType)callbackNum
{
    
    CGPoint midLeft = CGPointMake(stOrgx, stOrgy);   //起点
    CGPoint midRight = CGPointMake(endOrgx, endOrgy); //终点
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:midLeft];
    [path addLineToPoint:midRight];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0, 0, 10, 5);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor greenColor].CGColor;
    pathLayer.lineWidth = 1;
    [self.layer addSublayer:pathLayer];
    
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [CATransaction setCompletionBlock:^{
        //画完线要画得按钮
        switch (callbackNum) {
            case btnSet:
                [self setBtn]; //画设置按钮
                break;
            case btnTtfSize:   //画字体大小按钮
                [self ttfSizeBtnLeftHalf:endOrgx-50];
                break;
            case btnColor:     //画颜色按你u
                [self colorBtnLeftHalf:endOrgx-50];
                break;
            case btnLight:     //话亮度按钮
                [self lightBtnLeftHalf:endOrgx - 50];
                break;
            default:
                break;
        }
    }];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [CATransaction commit];
    
}


#define lingOrgY 200
#define lineOrgY -200
#define durationTime  1.0
#define radiusLength 25
- (void)showLine{
    NSLog(@"线1");
    [self setupLayersWithStOrgX:self.frame.size.width stOrgY:lineOrgY endOrgx:self.frame.size.width-15 endOrgy:lineOrgY duration:0.3 callback:btnSet];
}
- (void)showLineToOrgX:(float)orgX callBack:(btnType)btnType{
    NSLog(@"线2");
    [self setupLayersWithStOrgX:orgX stOrgY:lineOrgY endOrgx:orgX-10 endOrgy:lineOrgY duration:0.3 callback:btnType];
}

- (void)showVerticalLineToOrgX:(float)orgX storgY:(float)orgY endOrgY:(float)endOrgY callBack:(btnType)btnType{
    NSLog(@"线2");
    [self setupLayersWithStOrgX:orgX stOrgY:orgY endOrgx:orgX endOrgy:endOrgY duration:0.3 callback:btnType];
}


-(void)setBtn{
    NSLog(@"设置按钮");
    WxxPosition setBtnPst = WxxPositionMake(radiusLength, 250, lingOrgY, durationTime, btnSet, 4, 2, NO);
    WxxPosition setBtnPst2 = WxxPositionMake(radiusLength, 250, lingOrgY, durationTime, btnSet, 4, 2, YES);
    [self initStrokeEndBtnWithPosition:setBtnPst];//画圈
    [self initStrokeEndBtnWithPosition:setBtnPst2];//画圈
}
//保存按钮 1
-(void)saveBtn{
    NSLog(@"保存按钮");
    //[self initStrokeEndBtnWithRadius:25 orgX:15 orgY:CGRectGetMidY(self.bounds) duration:1.0 callback:1 startAngle:2 endAngle:2 clockwise:YES];//画圈
    //[self initStrokeEndBtnWithRadius:25 orgX:15 orgY:CGRectGetMidY(self.bounds) duration:1.0 callback:0 startAngle:2 endAngle:2 clockwise:NO];//画圈
}
//取消按钮
-(void)closeBtn{
    NSLog(@"关闭按钮");
    //[self initStrokeEndBtnWithRadius:25 orgX:75 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:2 startAngle:2 endAngle:2 clockwise:YES];//画圈
    //[self initStrokeEndBtnWithRadius:25 orgX:75 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:0 startAngle:2 endAngle:2 clockwise:NO];//画圈
}
//字体
-(void)ttfSizeBtnLeftHalf:(float)orgX{
    NSLog(@"字体左");
    WxxPosition setBtnPst = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnTtfSize, 4, 2, NO);
    WxxPosition setBtnPst2 = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnTtfSize, 4, 2, YES);
    [self initStrokeEndBtnWithPosition:setBtnPst];//画圈
    [self initStrokeEndBtnWithPosition:setBtnPst2];//画圈
}
-(void)ttfSizeBtnAdd{
    NSLog(@"字体加");
    //[self initStrokeEndBtnWithRadius:25 orgX:135 orgY:-60 duration:3.5 callback:0 startAngle:1 endAngle:5 clockwise:YES];//画圈
}
-(void)ttfSizeBtnDel{
    NSLog(@"字体减");
    // [self initStrokeEndBtnWithRadius:25 orgX:135 orgY:60 duration:3.5 callback:0 startAngle:3 endAngle:5 clockwise:YES];//画圈
}

-(void)colorBtnLeftHalf:(float)orgX{
    NSLog(@"颜色左");
    WxxPosition setBtnPst = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnColor, 4, 2, NO);
    WxxPosition setBtnPst2 = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnColor, 4, 2, YES);
    [self initStrokeEndBtnWithPosition:setBtnPst];//画圈
    [self initStrokeEndBtnWithPosition:setBtnPst2];//画圈
}

-(void)lightBtnLeftHalf:(float)orgX{
    NSLog(@"亮度左");
    WxxPosition setBtnPst = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnLight, 4, 2, NO);
    WxxPosition setBtnPst2 = WxxPositionMake(radiusLength, orgX, lingOrgY, durationTime, btnLight, 4, 2, YES);
    [self initStrokeEndBtnWithPosition:setBtnPst];//画圈
    [self initStrokeEndBtnWithPosition:setBtnPst2];//画圈
}




-(void)lightBtnRightHalf{
    NSLog(@"亮度右");
   // [self initStrokeEndBtnWithRadius:25 orgX:195 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:6 startAngle:3 endAngle:1 clockwise:YES];//画圈
    //[self initStrokeEndBtnWithRadius:25 orgX:195 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:0 startAngle:1 endAngle:-1 clockwise:NO];//画圈
}
-(void)linghtAdd{
    NSLog(@"亮度加");
    //[self initStrokeEndBtnWithRadius:25 orgX:195 orgY:-60 duration:3.5 callback:0 startAngle:1 endAngle:5 clockwise:YES];//画圈
}
-(void)linghtDel{
    NSLog(@"亮度减");
   // [self initStrokeEndBtnWithRadius:25 orgX:195 orgY:60 duration:3.5 callback:0 startAngle:3 endAngle:5 clockwise:YES];//画圈
}


-(void)colorBtnRightHalf{
    NSLog(@"颜色右");
    //[self initStrokeEndBtnWithRadius:25 orgX:255 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:8 startAngle:3 endAngle:1 clockwise:YES];//画圈
    //[self initStrokeEndBtnWithRadius:25 orgX:255 orgY:CGRectGetMidY(self.bounds) duration:0.5 callback:0 startAngle:1 endAngle:-1 clockwise:NO];//画圈
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
    self.progressTintColor = [UIColor blackColor];
    NSLog(@"%f",wxxPosition.orgY);
    //创建layer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.radius = wxxPosition.radius; //半径
    shapeLayer.orgX = wxxPosition.orgX;     //x轴位置
    shapeLayer.orgY = wxxPosition.orgY;     //y轴位置
    shapeLayer.ynTouch = YES;               //允许点击
    shapeLayer.btnType = wxxPosition.callbackNum; //回调函数
    shapeLayer.lineWidth = 2; //线宽度
    shapeLayer.strokeColor = self.progressTintColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    if (!self.layerArr) {
        self.layerArr = [[NSMutableArray alloc]init];
    }
    [self.layerArr addObject:shapeLayer];
    shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wxxPosition.orgX + wxxPosition.radius, wxxPosition.orgY)
                                                          radius:wxxPosition.radius  //半径
                                                      startAngle:wxxPosition.startAngle*M_PI_2
                                                        endAngle:wxxPosition.startAngle*M_PI_2 + wxxPosition.endAngle*M_PI_2
                                                       clockwise:wxxPosition.clockwise].CGPath;       //圆圈
    
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = (YES) ? @0 : nil;
    animation.toValue = [NSNumber numberWithFloat:progress];
    animation.duration = wxxPosition.duration;
    shapeLayer.strokeEnd = progress;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    [CATransaction setCompletionBlock:^{
        //画完按钮要处理的事情
        switch (wxxPosition.callbackNum) {
            case btnSet: //设置按钮
                shapeLayer.fillColor = [UIColor redColor].CGColor;
                break;
            case btnTtfSize: //字体大小按钮
                shapeLayer.fillColor = [UIColor blackColor].CGColor;
                if (wxxPosition.clockwise) {
                    [self showLineToOrgX:wxxPosition.orgX callBack:btnColor];
                }
                break;
            case btnColor: //颜色
                shapeLayer.fillColor = [UIColor blueColor].CGColor;
                if (wxxPosition.clockwise) {
                    [self showLineToOrgX:wxxPosition.orgX callBack:btnLight];
                }
                break;
            case btnLight:
                shapeLayer.fillColor = [UIColor grayColor].CGColor;
                if (wxxPosition.clockwise) {
                    [self showLineToOrgX:wxxPosition.orgX callBack:btNothing];
                }
                break;
            default:
                break;
        }
    }];
    [shapeLayer addAnimation:animation forKey:@"strokeEnd"];
    [CATransaction commit];
    [shapeLayer release];
}

-(void)removeLayers{
    for (int i=0; i<[self.layerArr count]; i++) {
        CAShapeLayer *layer = [self.layerArr objectAtIndex:i];
        [layer removeFromSuperlayer];
    }
}
//- (void)startIndeterminateAnimation
//{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    
//    self.shapeLayer.lineWidth = 1;
//    self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
//                                                          radius:30
//                                                      startAngle:DEGREES_TO_RADIANS(348)
//                                                        endAngle:DEGREES_TO_RADIANS(12)
//                                                       clockwise:NO].CGPath;
//    self.shapeLayer.strokeEnd = 1;
//    
//    [CATransaction commit];
//    
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
//    rotationAnimation.duration = 1.0;
//    rotationAnimation.repeatCount = HUGE_VALF;
//    
//    [self.shapeLayer addAnimation:rotationAnimation forKey:@"indeterminateAnimation"];
//}
//
//- (void)stopIndeterminateAnimation
//{
//    [self.shapeLayer removeAnimationForKey:@"indeterminateAnimation"];
//    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    [CATransaction commit];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
