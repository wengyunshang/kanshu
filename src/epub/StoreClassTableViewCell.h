//
//  StoreClassTableViewCell.h
//  PandaBook
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BigClassData;
@class ClassData;
@interface StoreClassTableViewCell : UITableViewCell
-(void)setInfo:(BigClassData*)data;

-(ClassData*)getClassData;
@end
