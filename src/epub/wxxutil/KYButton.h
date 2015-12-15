//
//  KYButton.h
//  UIBezierPathSymbol_Demo
//
//  Created by Kjuly on 8/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBezierPath+Symbol.h"
#import "BlockUI.h"
@interface KYButton : UIButton
{
UIActivityIndicatorView *spinner;
}
@property (nonatomic, retain) UIColor * color;
@property (nonatomic, assign) CGFloat   scale;
@property (nonatomic, assign) CGFloat   thick;
-(void)touchBtn;


- (void)showActivity;
- (void) startSpinner;
- (void) stopSpinner;
@end
