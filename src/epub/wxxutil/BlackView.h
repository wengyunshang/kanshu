//
//  BlackView.h
//  MIMIGOU
//
//  Created by xiangxun weng on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <QuartzCore/QuartzCore.h>
@interface BlackView : UIView
{ 
}
 
+ (BlackView *)sharedBlackView;   
+(void)orgXAnimation:(UIView *)v  orgx:(float)orgx;
+(void)orgYAnimation:(UIView *)v  orgY:(float)orgy duration:(float)dur;
+(void)sharke :(UIView *)vv num:(float)num;
+(void)orgXAnimation:(UIView *)v  orgx:(float)orgx duration:(float)dur;
+(void)orgXYAnimation:(UIView *)v  orgx:(float)orgx orgy:(float)orgy duration:(float)dur;
+(void)alphaAnimation:(UIView *)v  orgx:(float)orgx  duration:(float)dur;
+(void)orgXAnimation:(UIView *)v  orgx:(float)orgx orgy:(float)orgy;
+(void)orgXAnimation:(UIView *)v orgx:(float)orgx OrgX2:(float)orgx2;
+(void)layerAlpha:(UIView*)v;
+(void)scaleAnimation:(UIView *)v;
+(void)sizeHeightAnimation:(UIView *)v  sizeH:(float)sizeH;
+(void)sizeHeightAnimation:(UIView *)v  sizeH:(float)sizeH orgY:(float)orgy;
+(void)sharke :(UIView *)vv num:(float)num movewidth:(float)movewidth dur:(float)dur;
+(void)orgXAnimationRepeat:(UIView *)v selfOrgx:(float)selfOrgx  orgx:(float)orgx duration:(float)dur;
+(void)alphaAnimationTo0:(UIView *)v  duration:(float)dur;
@end
