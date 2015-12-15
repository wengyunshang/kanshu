//
//  KWPopoverView.h
//  KWPopoverViewDemo
//
//  Created by zzl on 14-4-10.
//  Copyright (c) 2014年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWPopoverView : UIView
// [KWPopoverView showPopoverAtPoint:point1 inView:self.view withContentView:_contentView];
+ (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;

@end
