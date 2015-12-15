//
//  WxxButton.h
//  DontTry
//
//  Created by weng xiangxun on 13-1-17.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockUI.h"
#import "SetConfig.h"
typedef enum {
    
    ovalEnum,//圆形按钮
}btnEnum;
@interface WxxButton : UIButton
@property (assign,nonatomic)bool ynDraw;
@property (assign,nonatomic)btnEnum be;
@property (assign,nonatomic)UIColor *color;
- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName selectImg:(NSString *)selImg str:(NSString*)str;
//九宫格
//- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName selectImg:(NSString *)selImg str:(NSString*)str
//              width:(float)widths height:(float)heights;
- (id)initWithPoint:(CGPoint)point image:(UIImage *)img selectImg:(UIImage *)selImg str:(NSString*)str
              width:(float)widths height:(float)heights;
-(void)setOrgXTo0;
- (id)initWithPoint:(CGPoint)point imagePng:(UIImage *)secrectFldpng selectImgPng:(UIImage *)selImgpng str:(NSString*)str;
//- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName;
-(id)initWithRect:(CGRect)rect btnEnum:(btnEnum)be color:(UIColor*)co;
-(void)hideSeelcted;
-(void)setBackgroundImageInsets:(UIImage *)image forState:(UIControlState)state;//九宫格
- (id)initWithTouchLightFrame:(CGRect)frame;
@end
