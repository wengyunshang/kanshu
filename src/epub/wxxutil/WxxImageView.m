//
//  WxxImageView.m
//  driftbottle
//
//  Created by weng xiangxun on 13-8-12.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxImageView.h"
#import "SDImageView+SDWebCache.h"
#import "UIImageView+Curled.h"
#import "BlockUI.h"
@implementation WxxImageView
-(void)dealloc{
    [_url2 release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame imgUrl:(NSString*)imgurl downImageFinish:(void(^)(CGSize))function
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImageWithUrlString:imgurl];
        _downLoadFinish = [function copy];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //拉伸
        UIImage * newBgImage =[image stretchableImageWithLeftCapWidth:4 topCapHeight:20] ;
        
        self.image = newBgImage;
        
        
    }
    return self;
}


-(void)setImageWithUrlString:(NSString *)imgurl downImageFinish:(void(^)(CGSize))function{
    [self setImageWithUrlString:imgurl];
    _downLoadFinish = [function copy];
}

-(void)setImageWithUrlString:(NSString*)urlstr{
    NSURL *url=[NSURL URLWithString:urlstr];
    [self setImageWithURL:url];
}

-(void)setImage:(UIImage *)image{
//    NSLog(@"设置图片");
    if (_downLoadFinish) {
        _downLoadFinish(image.size);
    }
//    [self setContentMode:UIViewContentModeScaleToFill];
//    image = [self setImage:image borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0];
    [super setImage:image];
}

 
-(void)resetFrame:(CGRect)rect{
    self.frame = rect;
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
