//
//  WxxPopView.m
//  ZWYPopKeyWords
//
//  Created by weng xiangxun on 14/12/23.
//  Copyright (c) 2014年 ZWY. All rights reserved.
//

#import "WxxPopView.h"
#import "UIView+Blur.h"
#import "WxxLabel.h"
#import "YLLabel.h"
@interface WxxPopView()
@property (nonatomic,strong)WxxLabel *contentLb;
@end
@implementation WxxPopView
#pragma mark -
#pragma mark Singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(WxxPopView);

-(void)dealloc{

    if (_contentLb) {
        [_contentLb release];
        _contentLb = nil;
    }
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake((UIBounds.size.width-250)/2, (UIBounds.size.height-65)/2, 250, 65)];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 6.0;
//        [self blurScreen:YES];
        UIView *black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        black.backgroundColor = [UIColor blackColor];
        black.alpha = 0.87;
        [self addSubview:black];
        [black release];
        
        
        self.contentLb = [[WxxLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_contentLb release];
        [_contentLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:17.0]];
        _contentLb.textColor = [UIColor whiteColor];
        
        
        
//        [_contentLb resetFrame:UIBounds.size.width-109];
        
        [self addSubview:_contentLb];
        
//        _contentLb = [[WxxLabel alloc]initWithFrame:CGRectMake(10,10,CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-20)];
//        [self.contentLb setTextColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0]];
//        [self.contentLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:16]];
//        [self addSubview:self.contentLb];
        self.alpha = 0;
    }
    return self;
}



-(void)showPopText:(NSString*)str time:(float)time{
    [self.contentLb setText:str];
    [self.contentLb resetLineFrame];
    
    CGRect rect = self.contentLb.frame;
    rect.origin.x = (self.frame.size.width - rect.size.width)/2;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.contentLb.frame = rect;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
    }];
    [self performSelector:@selector(hidePopView:) withObject:nil afterDelay:time];
}

-(void)showPopText:(NSString*)str{
    [self.contentLb setText:str];
    [self.contentLb resetLineFrame];
    
    CGRect rect = self.contentLb.frame;
    rect.origin.x = (self.frame.size.width - rect.size.width)/2;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.contentLb.frame = rect;
    
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0;
        }completion:^(BOOL finished) {
        }];
    [self performSelector:@selector(hidePopView:) withObject:nil afterDelay:2];
}

-(void)hidePopView:(id*)object{
    
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        }completion:^(BOOL finished) {
        }];
    //    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //    scaleAnimation.springBounciness = 15;
    //    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    //    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.4, 0.4)];
    //    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
-(void)showText:(NSString*)string{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string message:nil
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    alert.backgroundColor = [UIColor blackColor];
    
    [alert show];
    [alert release];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 1.0;
//    }completion:^(BOOL finished) {
//    }];
//    
////    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
////    scaleAnimation.springBounciness = 15;
////    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.2)];
////    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
////    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
//    [self.contentLb setText:string];
//    [self.contentLb resetLineFrame];
//    CGRect rect = self.contentLb.frame;
//    rect.origin.x = (self.frame.size.width - self.contentLb.frame.size.width)/2;
//    rect.origin.y = (self.frame.size.height - self.contentLb.frame.size.height)/2;
//    self.contentLb.frame = rect;
    
    [self performSelector:@selector(hideSelf:) withObject:alert afterDelay:1.5];
}

-(void)showText:(NSString *)string yesBtn:(NSString*)yesStr{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string
                                                   delegate:self cancelButtonTitle:yesStr otherButtonTitles:nil];
    //    alert.backgroundColor = [UIColor blackColor];
    
    [alert show];
    [alert release];
    
//    [self performSelector:@selector(hideSelf:) withObject:alert afterDelay:1.5];

}


-(void)hideSelf:(UIAlertView*)alert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 0.0;
//    }completion:^(BOOL finished) {
//    }];
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.springBounciness = 15;
//    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.4, 0.4)];
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
