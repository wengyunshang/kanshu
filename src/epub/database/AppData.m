//
//  AppData.m
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "AppData.h"

@implementation AppData
 
static AppData *_sharedAppData = nil;
/**
 数据库采用单例模式: 不必每个地方去管理
 */
+ (AppData *)sharedAppData{
	if (!_sharedAppData) {
        _sharedAppData = [[self alloc] init];
    }
    return _sharedAppData;
}
-(void)dealloc{
    [_capp_id release];
    [_capp_guid release];
    [_capp_apptype release];
    [_capp_appname release];
    [_capp_version release];
    [_capp_appkey release];
    [_capp_remark release];
    [_capp_createtime release];
    [_capp_pubname release];
    [_capp_platform release];
    [_capp_appstoreid release];
    [_capp_notice release];
    [_capp_notice_is_open release];
    [_capp_is_pub release];
    [_capp_down_url release];
    [_capp_admob_id release];
    [_capp_admob_is_open release];
    [_capp_ad_is_open release];
    [_capp_is_more_app release];
    [super dealloc];
}


+ (id)initWithDictionary:(NSDictionary*)dic{
    AppData *dbbdata = [[[AppData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.capp_id= [dic objectForKey:app_id];
        self.capp_guid= [dic objectForKey:app_guid];
        self.capp_apptype= [dic objectForKey:app_apptype];
        self.capp_appname= [dic objectForKey:app_appname];
        self.capp_version= [dic objectForKey:app_version];
        self.capp_appkey= [dic objectForKey:app_appkey];
        self.capp_remark= [dic objectForKey:app_remark];
        self.capp_createtime= [dic objectForKey:app_createtime];
        self.capp_pubname= [dic objectForKey:app_pubname];
        self.capp_platform= [dic objectForKey:app_platform];
        self.capp_appstoreid= [dic objectForKey:app_appstoreid];
        self.capp_notice= [dic objectForKey:app_notice];
        self.capp_notice_is_open= [dic objectForKey:app_notice_is_open];
        self.capp_is_pub= [dic objectForKey:app_is_pub];
        self.capp_down_url= [dic objectForKey:app_down_url];
        self.capp_admob_id= [dic objectForKey:app_admob_id];
        self.capp_admob_is_open= [dic objectForKey:app_admob_is_open];
        self.capp_ad_is_open= [dic objectForKey:app_ad_is_open];
        self.capp_is_more_app= [dic objectForKey:app_is_more_app];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary*)dic
{
     self.capp_id= [dic objectForKey:app_id];
        self.capp_guid= [dic objectForKey:app_guid];
        self.capp_apptype= [dic objectForKey:app_apptype];
        self.capp_appname= [dic objectForKey:app_appname];
        self.capp_version= [dic objectForKey:app_version];
        self.capp_appkey= [dic objectForKey:app_appkey];
        self.capp_remark= [dic objectForKey:app_remark];
        self.capp_createtime= [dic objectForKey:app_createtime];
        self.capp_pubname= [dic objectForKey:app_pubname];
        self.capp_platform= [dic objectForKey:app_platform];
        self.capp_appstoreid= [dic objectForKey:app_appstoreid];
        self.capp_notice= [dic objectForKey:app_notice];
        self.capp_notice_is_open= [dic objectForKey:app_notice_is_open];
        self.capp_is_pub= [dic objectForKey:app_is_pub];
        self.capp_down_url= [dic objectForKey:app_down_url];
        self.capp_admob_id= [dic objectForKey:app_admob_id];
        self.capp_admob_is_open= [dic objectForKey:app_admob_is_open];
        self.capp_ad_is_open= [dic objectForKey:app_ad_is_open];
        self.capp_is_more_app= [dic objectForKey:app_is_more_app];
 
}

-(int)getIsmoreApp{
    if (self.capp_is_more_app) {
        return [self.capp_is_more_app intValue];
    }
    return 10;
}
-(NSString*)getAdmobId{
    if (self.capp_admob_id) {
        return self.capp_admob_id;
    }
    return nil;
}

-(int)getIsPub{
    //    if (!self.capp_admob_id || [self.capp_admob_id length]<5) {
    //        return 10;
    //    }
    if (self.capp_is_pub) {
        return [self.capp_is_pub intValue];
    }
    return 10;
}

-(int)getAdmoveIsOpen{
//    if (!self.capp_admob_id || [self.capp_admob_id length]<5) {
//        return 10;
//    }
    if (self.capp_admob_is_open) {
        return [self.capp_admob_is_open intValue];
    }
    return 10;
}

-(int)getSiayuAdIsOpen{

    if (self.capp_ad_is_open) {
        return [self.capp_ad_is_open intValue];
    }
    return 0;
}

//-(void)updateSelf{
//
//    [[PenSoundDao sharedPenSoundDao] updateBookData:self];
//}

//保存本实体到本地
-(void)saveSelfToDB{
    
//    [[PenSoundDao sharedPenSoundDao]saveClass:self];
}
@end
