//
//  ArrowView.h
//  epub
//
//  Created by weng xiangxun on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrowView : UIView
- (id)initWithParent:(float)parentWidth height:(float)height;
-(void)leftArrow;
-(void)rightArrow;
@end
