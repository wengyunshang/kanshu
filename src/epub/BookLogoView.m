//
//  BookLogoView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-26.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BookLogoView.h"
#import "ResourceHelper.h"
#import "BlackView.h"
#import "WxxLabel.h"
@implementation BookLogoView
#pragma mark -
#pragma mark Singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(BookLogoView);

-(void)dealloc{
//    [_tipLb release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
//        NSString *pngstr = @"Default.png";
//        if (UIBounds.size.height == 568) {
//            pngstr = @"Default-568h.png";
//        }
//        
//        // Initialization code
//        UIImage *image = [UIImage imageNamed:pngstr];//[ResourceHelper loadImageByTheme:@"Logo"];
//        UIImageView *logoImgv = [[UIImageView alloc]initWithImage:image];
//        logoImgv.frame = CGRectMake((CGRectGetWidth(self.frame)-image.size.width)/2, (CGRectGetHeight(self.frame)-image.size.height)/2, image.size.width, image.size.height);
//        [self addSubview:logoImgv];
//        [logoImgv release];
        
        if (!self.lineView) {
                self.lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-52, UIBounds.size.width, 1)] autorelease];
                [self addSubview:self.lineView];
            }
        [self.lineView showLine];
        
//        [self performSelector:@selector(hideSelf) withObject:nil afterDelay:3.0];
//        [self showTip];
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)showTip{
    self.tipLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(0,
                                                               CGRectGetMinY(self.lineView.frame)-30,
                                                               UIBounds.size.width, 30) font:fontTTFToSize(19)] autorelease];
    self.tipLb.text =@"loading...?   yes,it is.";
    self.tipLb.textColor = [UIColor blackColor];
    self.tipLb.textAlignment = NSTextAlignmentCenter;
//    self.tipLb.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.tipLb];
}

-(void)performSelectorHideSelf{
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:2.0];
}
-(void)hideSelf{
    [UIView animateWithDuration:1
                     animations:^{
                         self.alpha = 0.1;
                     }
                     completion:^(BOOL finished){
//                         [self.lineView release];
//                         self.lineView = nil;
                         [self removeFromSuperview];
//                         self.hidden = YES;
                     }];
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
