//
//  UIBezierPath+Wxx.m
//  driftbottle
//
//  Created by weng xiangxun on 13-7-13.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "UIBezierPath+Wxx.h"

@implementation UIBezierPath(Wxx)

/**
 *  参数:  waveCount:波浪弯曲数量
 *        waveWidth:波浪厚度
 *        
 **/
+(UIBezierPath*)customBezierPathOfWaveWithRect:(CGRect)rect waveCount:(int)wavecount waveWidth:(float)wavewidth waveHeight:(float)waveheight{
    
    UIBezierPath *waveBezier = [self bezierPath];;
    
    waveheight = rect.size.height - wavewidth;
    
    float rectwidth = rect.size.width - wavewidth;
    
    for (int i=1; i<=wavecount; i++) {
        
        if (i == 1) {
            [waveBezier moveToPoint:CGPointMake(rectwidth/wavecount*i, 0)];
        }else{
            [waveBezier addLineToPoint:CGPointMake(rectwidth/wavecount*i, 0)]; //突起点
        }
        if (i<wavecount) {
            [waveBezier addLineToPoint:CGPointMake(rectwidth/wavecount*i+rectwidth/wavecount/2, waveheight)]; //凹曲点
        }
    }
    [waveBezier addLineToPoint:CGPointMake(rect.size.width, 0)];
    
    for (int j=wavecount; j>=1; j--) {
        [waveBezier addLineToPoint:CGPointMake(rectwidth/wavecount*j-rectwidth/wavecount/2, rect.size.height)]; //突起点
        if (j>1) {
            [waveBezier addLineToPoint:CGPointMake(rectwidth/wavecount*j-rectwidth/wavecount, rect.size.height-waveheight)]; //凹曲点
        }

    }
    [waveBezier addLineToPoint:CGPointMake(0, rect.size.height)];
    [waveBezier setLineWidth:5];
    [waveBezier closePath];
    return waveBezier;
}

+(UIBezierPath*)custombezierPathInRect:(CGRect)rect{
    UIBezierPath *waveBezier = [self bezierPath];
    [waveBezier moveToPoint:CGPointMake(0, 0)];
    [waveBezier addLineToPoint:CGPointMake(rect.size.width, 0)]; //突起点
    [waveBezier addLineToPoint:CGPointMake(rect.size.width, rect.size.height)]; //突起点
    [waveBezier addLineToPoint:CGPointMake(0, rect.size.height)];
    [waveBezier closePath];
    return waveBezier;
}

+(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

+(UIBezierPath*)custombezierPathWithOvalInRect:(CGRect)rect{
    UIBezierPath *roundBezier = [self bezierPathWithOvalInRect:rect];
    [roundBezier setLineWidth:3];
   
    return roundBezier;
}





































@end
