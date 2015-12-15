//
//  StoreHeadView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-8-24.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCircularProgressView.h"
@class BookData;
@interface StoreHeadView : UIView
- (id)initWithFrame:(CGRect)frame num:(NSString*)num;
-(void)setBookInfo:(BookData*)bookData;;
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch;
@end
