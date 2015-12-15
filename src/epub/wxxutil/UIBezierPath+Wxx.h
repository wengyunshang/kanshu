//
//  UIBezierPath+Wxx.h
//  driftbottle
//
//  Created by weng xiangxun on 13-7-13.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UIBezierPath(Wxx)

+(UIBezierPath*)customBezierPathOfWaveWithRect:(CGRect)rect waveCount:(int)count waveWidth:(float)width waveHeight:(float)waveheight;

+(UIBezierPath*)custombezierPathWithOvalInRect:(CGRect)rect;
+(UIBezierPath*)custombezierPathInRect:(CGRect)rect;
@end