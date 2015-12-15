//
//  WxxButton.m
//  DontTry
//
//  Created by weng xiangxun on 13-1-17.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxButton.h"
#import "BlackView.h"
#import "WxxView.h"
#import "UIBezierPath+Wxx.h"
#define TextColor [UIColor blackColor]

@interface WxxButton(){
}
@end

@implementation WxxButton


//点击有效果的初始化
- (id)initWithTouchLightFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.titleLabel.textColor = TextColor;
        [self addTarget:self action:@selector(touchLightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)touchLightBtn{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.layer.opacity = 0.2;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            
            self.layer.opacity = 1.0;
        }completion:^(BOOL finished){
        }];
    }];
    [self sendObject:nil];
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.titleLabel.textColor = TextColor;
        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName selectImg:(NSString *)selImg str:(NSString*)str
{
    UIImage *secrectFldpng = [UIImage imageNamed:imgName];
    UIImage *selImgpng = [UIImage imageNamed:selImg];
    self = [super initWithFrame:CGRectMake(point.x, point.y, secrectFldpng.size.width, secrectFldpng.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundImage:secrectFldpng forState:UIControlStateNormal];
        [self setBackgroundImage:selImgpng forState:UIControlStateSelected];
        [self setTitle:str forState:UIControlStateNormal];
//        self.titleLabel.textColor = TextColor;
        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point imagePng:(UIImage *)secrectFldpng selectImgPng:(UIImage *)selImgpng str:(NSString*)str
{
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, secrectFldpng.size.width, secrectFldpng.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundImage:secrectFldpng forState:UIControlStateNormal];
        [self setBackgroundImage:selImgpng forState:UIControlStateSelected];
        [self setTitle:str forState:UIControlStateNormal];
        //        self.titleLabel.textColor = TextColor;
        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setBackgroundImageInsets:(UIImage *)image forState:(UIControlState)state{
    

    
    CGFloat top = floorf(image.size.height/2); // 顶端盖高度
    CGFloat bottom = floorf(image.size.height/2) ; // 底端盖高度
    CGFloat left = floorf(image.size.width/2); // 左端盖宽度
    CGFloat right = floorf(image.size.width/2); // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:image forState:state];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}
//九宫格
- (id)initWithPoint:(CGPoint)point image:(UIImage *)img selectImg:(UIImage *)selImg str:(NSString*)str
              width:(float)widths height:(float)heights
{
    
    
//    UIImage *secrectFldpng = [UIImage imageNamed:imgName];
//    UIImage *selImgpng = [UIImage imageNamed:selImg];
    
    CGFloat top = floorf(img.size.height/2); // 顶端盖高度
    CGFloat bottom = floorf(img.size.height/2) ; // 底端盖高度
    CGFloat left = floorf(img.size.width/2); // 左端盖宽度
    CGFloat right = floorf(img.size.width/2); // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 伸缩后重新赋值
    img = [img resizableImageWithCapInsets:insets];
    selImg = [selImg resizableImageWithCapInsets:insets];
    
    float height = heights>0 ? heights : img.size.height;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, widths, height)];
    if (self) {
        // Initialization code
        [self setBackgroundImage:img forState:UIControlStateNormal];
        [self setBackgroundImage:selImg forState:UIControlStateHighlighted];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:TextColor forState:UIControlStateNormal];
//                self.titleLabel.textColor = TextColor;
        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//九宫格
//- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName selectImg:(NSString *)selImg str:(NSString*)str
//width:(float)widths height:(float)heights
//{
//    
//    
//    UIImage *secrectFldpng = [UIImage imageNamed:imgName];
//    UIImage *selImgpng = [UIImage imageNamed:selImg];
//    
//    CGFloat top = floorf(secrectFldpng.size.height/2); // 顶端盖高度
//    CGFloat bottom = floorf(secrectFldpng.size.height/2) ; // 底端盖高度
//    CGFloat left = floorf(secrectFldpng.size.width/2); // 左端盖宽度
//    CGFloat right = floorf(secrectFldpng.size.width/2); // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 伸缩后重新赋值
//    secrectFldpng = [secrectFldpng resizableImageWithCapInsets:insets];
//    selImgpng = [selImgpng resizableImageWithCapInsets:insets];
//    
//    float height = heights>0 ? heights : secrectFldpng.size.height;
//
//    self = [super initWithFrame:CGRectMake(point.x, point.y, widths, height)];
//    if (self) {
//        // Initialization code
//        [self setBackgroundImage:secrectFldpng forState:UIControlStateNormal];
//        [self setBackgroundImage:selImgpng forState:UIControlStateHighlighted];
//        [self setTitle:str forState:UIControlStateNormal];
//        //        self.titleLabel.textColor = TextColor;
//        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
//
//UIImage *image = [UIImage imageNamed:backImageFile];
////设置图片的拉伸方式，从图片的正中心拉伸，如果你的扩展位置不同，可以调整capInsets的值
////UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) 分别对应上，左，下，右的距离
//image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height/2), floorf(image.size.width/2), floorf(image.size.height/2), floorf(image.size.width/2))];
////指定一下背景图片，就可以了。
//[btnIcon setBackgroundImage:image forState:UIControlStateNormal];

-(void)hideSeelcted{
    if (self.ynDraw) {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    self.selected = NO;
}

-(void)touchBtn{
    
    [self sendObject:@""];
}


- (id)initWithPoint:(CGPoint)point image:(NSString *)imgName place:(NSString *)str
{
    UIImage *secrectFldpng = [UIImage imageNamed:imgName];
    self = [super initWithFrame:CGRectMake(point.x, point.y, secrectFldpng.size.width, secrectFldpng.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundImage:secrectFldpng forState:UIControlStateNormal];
        [self setTitle:str forState:UIControlStateNormal];
        self.titleLabel.textColor = TextColor;
    }
    return self;
}

-(void)setOrgXTo0{
    self.frame = CGRectMake(self.frame.origin.x-self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}


-(id)initWithRect:(CGRect)rect btnEnum:(btnEnum)be color:(UIColor*)co{
    
    self = [super initWithFrame:rect];
    if (self) {
        //        self.backgroundColor = [UIColor clearColor];
        self.be = be;
        self.color = co;
        self.ynDraw = YES;
        [self setTitle:@"下载" forState:UIControlStateNormal];
self.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}
//
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.ynDraw) {
        [super drawRect:rect];
        if (self.be == ovalEnum) {
 
            
            UIBezierPath *bbb = [UIBezierPath custombezierPathInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            //        [[UIColor blackColor] setStroke];
            if (self.color) {
                [self.color setStroke];
            }else{}
            [bbb stroke];
        }
    }
}


@end
