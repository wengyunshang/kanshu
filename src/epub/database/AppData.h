//
//  AppData.h
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxBaseData.h"
#import <Foundation/Foundation.h>
#define app_id @"ID"  //appid
#define app_guid @"GUID"  //guid
#define app_apptype @"AppType" //app类型
#define app_appname @"AppName" //app名字
#define app_version @"Version" //版本号
#define app_appkey @"AppKey"  //appkey
#define app_remark @"Remark"  //介绍

#define app_createtime @"CreateTime" //时间
#define app_pubname @"pubName"    //发行名字
#define app_platform @"platform"  //平台
#define app_appstoreid @"AppStoreId" //appstoreid
#define app_notice @"notice"   //公告
#define app_notice_is_open @"notice_is_open"//公告是否开启
#define app_is_pub @"is_pub" //是否上架
#define app_down_url @"down_url" //下载地址
#define app_admob_id @"admob_id" //admobid
#define app_admob_is_open @"admob_is_open" //是否开启admob
#define app_ad_is_open @"ad_is_open" //是否开启广告
#define app_is_more_app @"is_more_app"  //是否开启更多app
@interface AppData : WxxBaseData
+ (AppData *)sharedAppData;
@property (nonatomic,strong)NSString *capp_id;
@property (nonatomic,strong)NSString *capp_guid;
@property (nonatomic,strong)NSString *capp_apptype;
@property (nonatomic,strong)NSString *capp_appname;
@property (nonatomic,strong)NSString *capp_version;
@property (nonatomic,strong)NSString *capp_appkey;
@property (nonatomic,strong)NSString *capp_remark; 
@property (nonatomic,strong)NSString *capp_createtime;
@property (nonatomic,strong)NSString *capp_pubname;
@property (nonatomic,strong)NSString *capp_platform;
@property (nonatomic,strong)NSString *capp_appstoreid;
@property (nonatomic,strong)NSString *capp_notice;
@property (nonatomic,strong)NSString *capp_notice_is_open;
@property (nonatomic,strong)NSString *capp_is_pub;
@property (nonatomic,strong)NSString *capp_down_url;
@property (nonatomic,strong)NSString *capp_admob_id;
@property (nonatomic,strong)NSString *capp_admob_is_open;
@property (nonatomic,strong)NSString *capp_ad_is_open;
@property (nonatomic,strong)NSString *capp_is_more_app;
- (void)setWithDictionary:(NSDictionary*)dic;
-(int)getIsmoreApp;
-(int)getAdmoveIsOpen;
-(NSString*)getAdmobId;
-(int)getSiayuAdIsOpen;
-(int)getIsPub;
@end
