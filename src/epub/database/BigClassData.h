//
//  BigClassData.h
//  PandaBook
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WxxBaseData.h"
#define big_id @"big_id"
#define father_id @"father_id"
#define son_id @"son_id"
#define class_logo @"class_logo"
#define class_price @"class_price"
#define class_buy @"class_buy"
@interface BigClassData : WxxBaseData
@property (nonatomic,strong)NSString *bbig_id;
@property (nonatomic,strong)NSString *bfather_id;
@property (nonatomic,strong)NSString *bson_id;
@property (nonatomic,strong)NSString *bclass_logo;
@property (nonatomic,strong)NSString *bclass_price;
@property (nonatomic,strong)NSString *bclass_buy;
@end
