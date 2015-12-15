//
//  WxxLabel.m
//  DontTry
//
//  Created by weng xiangxun on 13-2-5.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxLabel.h"
#import <UIKit/UIKit.h>


@implementation WxxLabel

- (id)initWithFrame:(CGRect)frame font:(UIFont*)font
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = font;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text:(NSString*)text font:(UIFont*)font
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = text;
        self.font = font;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setText:(NSString *)text{
    [super setText:text];
//    [self resetFrame];
}

-(void)resetFrame{
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    self.numberOfLines = 0;
    NSLog(@"%@",self.text);
    float www = [self.text stringTextWidthfont:self.font];
    float hhh = [self.text stringTextHeight:www Content:self.text font:self.font];
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            www<self.frame.size.width?hhh:(www/self.frame.size.width)*hhh);
}

-(float)highHeight:(float)width{
    if (width>0) {
    }else{
        width = CGRectGetWidth(self.frame);
    }
//    CGSize size = CGSizeMake(width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self.text stringTextWidthFont:self.font maxWidth:width];
    return labelsize.height+self.frame.origin.y;
}

-(void)reset2Frame{
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    self.numberOfLines = 0;
    //设置一个行高上限
//    CGSize size = CGSizeMake(CGRectGetWidth(self.frame),2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self.text stringTextWidthFont:self.font maxWidth:CGRectGetWidth(self.frame)];
    self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), labelsize.width, labelsize.height);
}

-(void)reset2FrameWIthRight:(float)maxWidth rightOrg:(float)rightOrgx{
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    self.numberOfLines = 0;
    //设置一个行高上限
//    CGSize size = CGSizeMake(CGRectGetWidth(self.frame),2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self.text stringTextWidthFont:self.font maxWidth:CGRectGetWidth(self.frame)];
    if (labelsize.width < maxWidth) {
        self.frame = CGRectMake(maxWidth-rightOrgx-labelsize.width,CGRectGetMinY(self.frame), labelsize.width, labelsize.height);
    }else{
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), labelsize.width, labelsize.height);
    }
    
}

-(void)resetFrameToMaxHeight:(float)maxheight{
    
    float www = [self.text stringTextWidthfont:self.font];
    float hhh = [self.text stringTextHeight:www Content:self.text font:self.font];
    self.backgroundColor = [UIColor clearColor];
    
    float height = www<self.frame.size.width?hhh:(www/self.frame.size.width)*hhh;
    
    
    if (height> maxheight) {
        height = maxheight;
    }
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            maxheight);
    //    NSLog(@">>>>>>>>>%f",self.frame.size.width);
//    NSLog(@"%f>>>>>%f>>>>%f",www,self.frame.size.width,hhh);
    //    NSLog(@">>>>>>>>>%f",self.frame.size.height);
//    self.lineBreakMode = UILineBreakModeCharacterWrap;
     [self setLineBreakMode:NSLineBreakByWordWrapping];
    self.numberOfLines = 0;
}

//计算不换行的frame
-(void)resetLineFrame{
    float www = [self.text stringTextWidthfont:self.font];
    float hhh = [self.text stringTextHeight:www Content:self.text font:self.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,www,hhh);
}


@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
//-(void) drawTextInRect:(CGRect)rect {
//    
//    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
//
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

