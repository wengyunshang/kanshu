//
//  ClassData.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-6-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//
//user_id
// user_name
//user_openId
//user_gold
//user_email
//user_logo
#import "WxxBaseData.h"
#import <Foundation/Foundation.h>
#define user_id @"user_id"
#define user_name @"user_name"
#define user_openId @"user_openId"
#define user_gold @"user_gold"
#define user_email @"user_email"
#define user_logo @"user_logo"
@interface UserData : WxxBaseData

+ (UserData *)sharedUserData;
@property (nonatomic,strong)NSString *uuser_id;
@property (nonatomic,strong)NSString *uuser_name;
@property (nonatomic,strong)NSString *uuser_openId;
@property (nonatomic,strong)NSString *uuser_gold;
@property (nonatomic,strong)NSString *uuser_email;
@property (nonatomic,strong)NSString *uuser_logo;
-(void)updateGold:(NSString*)goldNum;
-(BOOL)ynLogin;
@end
