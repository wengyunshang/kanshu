//
//  WxxNavigationController.h
//  driftbottle
//
//  Created by weng xiangxun on 13-8-12.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

//增加便捷按钮方法
@interface UINavigationController(wxxNavigationController)
-(void)setLeftNavBarBtnWithTitle:(NSString*)title action:(SEL)action backImg:(NSString*)img;
-(void)setNewSSs;
-(void)setRightNavBarBtnWithTitle:(NSString*)title action:(SEL)action backImg:(NSString*)img;
@end


@interface WxxNavigationController : UINavigationController

-(void)addNewView:(UIView*)vvview;
-(UIView*)getNavigationView;

+(void)setRightNavBarBtnWithNV:(id*)nv Title:(NSString*)title action:(SEL)action backImg:(NSString*)img;
+(void)setLeftNavBarBtnWithNV:(UINavigationController*)nv Title:(NSString*)title action:(SEL)action backImg:(NSString*)img;
@end