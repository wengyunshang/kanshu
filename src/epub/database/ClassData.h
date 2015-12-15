//
//  ClassData.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-6-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//
#import "WxxBaseData.h"
#import <Foundation/Foundation.h>
#define class_id @"class_id"
#define class_name @"class_name"
#define class_book @"class_book"
#define class_logo @"class_logo"
#define class_url @"class_url"
#define class_url2 @"class_url2"
#define class_title @"class_title"
@interface ClassData : WxxBaseData

+ (ClassData *)sharedClassData;
-(void)changeClassData:(NSString*)classId;
-(NSString*)getLogoPrefix:(NSString*)fileName;
-(NSString*)getBookPrefix:(NSString*)fileName;
-(NSString*)getgao7gao8LogoPrefix:(NSString*)fileName;
//gao7gao8 服务端的链接
-(NSString*)getgao7gao8BookPrefix:(NSString*)fileName;
@property (nonatomic,strong)NSString *cclass_id;
@property (nonatomic,strong)NSString *cclass_name;
@property (nonatomic,strong)NSString *cclass_book;
@property (nonatomic,strong)NSString *cclass_logo;
@property (nonatomic,strong)NSString *cclass_url;
@property (nonatomic,strong)NSString *cclass_url2;
@property (nonatomic,strong)NSString *cclass_title;

-(BOOL)ynHaveClass;
@end
