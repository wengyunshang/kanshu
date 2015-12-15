//
//  ArrowView.m
//  epub
//
//  Created by weng xiangxun on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ArrowView.h"
#import "WxxImageView.h"
#import "BlockUI.h"
#import "ResourceHelper.h"
@interface ArrowView()
@property(nonatomic,retain) WxxImageView *arrowImgv;
@end

@implementation ArrowView

-(void)dealloc{
    [_arrowImgv release];
    _arrowImgv = nil;
    [super dealloc];
}

- (id)initWithParent:(float)parentWidth height:(float)height
{
    
    UIImage *arrbackImg = [ResourceHelper loadImageByTheme:@"chapterArrowBack"];
    self = [super initWithFrame:CGRectMake(parentWidth-arrbackImg.size.width, 0, arrbackImg.size.width, arrbackImg.size.height)];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
//        UIImage * newBgImage =[arrbackImg stretchableImageWithLeftCapWidth:21 topCapHeight:14] ;
//        
//        WxxImageView *arrowBack = [[WxxImageView alloc]initWithImage:newBgImage];
//        arrowBack.frame = CGRectMake(0, 0, arrbackImg.size.width, height);
//        [self addSubview:arrowBack];
//        [arrowBack release];
//        
//        
//        UIImage *img = [ResourceHelper loadImageByTheme:@"nav_pane_handle_arrow"];
//        self.arrowImgv = [[[WxxImageView alloc]initWithFrame:CGRectMake(2, (CGRectGetHeight(self.frame)-img.size.height)/2, img.size.width, img.size.height)] autorelease];
//        self.arrowImgv.image = img;
//        [self addSubview:self.arrowImgv];
        
        UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
        [self addGestureRecognizer:panRecognizer];//关键语句，给self.view添加一个手势监测；
        panRecognizer.numberOfTapsRequired = 1;
        [panRecognizer release];
    }
    return self;
}

-(void) makeRotation:(UIImageView *)image lorr:(int)i
{
    // 旋转
    if (i==0) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation( 0.0 / 180.0 * 3.14 );
        [image setTransform:rotate];
        
    }else{
        CGAffineTransform rotate = CGAffineTransformMakeRotation( 180.0 / 180.0 * 3.14 );
        [image setTransform:rotate];
    }
    
}

-(void)leftArrow{
//    [self makeRotation:self.arrowImgv lorr:1];
}
-(void)rightArrow{
//    [self makeRotation:self.arrowImgv lorr:0];
   
}

-(void)touchTap:(id)sender{
//    NSLog(@"touch,,,");
    [self sendObject:nil];
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



