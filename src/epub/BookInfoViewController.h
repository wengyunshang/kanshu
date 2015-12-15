//
//  BookInfoViewController.h
//  PandaBook
//
//  Created by weng xiangxun on 15/3/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookData;
@interface BookInfoViewController : UIViewController<UIScrollViewDelegate>
-(void)setBookdata:(BookData *)bookdata;
@end
