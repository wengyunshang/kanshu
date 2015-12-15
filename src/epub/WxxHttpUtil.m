//
//  WxxHttpUtil.m
//  driftbottle
//
//  Created by weng xiangxun on 13-7-11.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxHttpUtil.h"
#import "JSONKit.h"
#import "OpenUDID.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <net/if.h>
#import "UserData.h"
#import "CommonCrypto/CommonDigest.h"
#define KYDIDFA @"KYDIDFA"
#include <net/if_dl.h>
//#define baseURL @"http://localhost/driftbottleSVN/indexlocalhost.php"

//#define utilopenid @"AA6B9B1E33F5064937B62DB8AA80D2C223"
//#define utilopenid @"AA6B9B1E33F5064937B62DB8AA80D2C224"
//#define utilopenid @"AA6B9B1E33F5064937B62DB8AA80D2C225"
//#define utilopenid [OpenUDID value]//

//[[NSUserDefaults standardUserDefaults]objectForKey:OPENID]
@implementation WxxHttpUtil

+(WxxHttpUtil *)sharedWxxHttpUtil{
    static WxxHttpUtil *_wxxHttpUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_wxxHttpUtil) {
            _wxxHttpUtil = [[WxxHttpUtil alloc]init];
        }
    });
    return _wxxHttpUtil;
}

//      ***********        发送图片例子   **********************

//        //        //网络请求
//        UIImage *m_imgFore = [UIImage imageNamed:@"done_press.png"];
//        NSData *imagedata=UIImagePNGRepresentation(m_imgFore);
//        //JEPG格式
//
//        [SVHTTPRequest POST:[WXXHTTPUTIL sendImageUrl]
//                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:
////                             @"samvermette", @"screen_name",
//                             imagedata,@"newimage",
//                             nil]
//                 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//                     NSLog(@"%@",[response objectForKey:@"name"]);
////                     id result = [WXXHTTPUTIL parseJSONData:response];
////                     NSLog(@"返回结果:%@",response);
//        }];

//        NSDictionary *dicddd = [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"samvermette", @"screen_name",
//                             imagedata, @"newimage",
//                                nil];
//        NSLog(@"%@",[dicddd objectForKey:@"screen_name"]);
//
//        [dicddd.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"xxxxxxxxxxxxxx%@",obj);
//
//            if([obj isKindOfClass:[NSData class]]){
//                NSLog(@"nsdata");
//
//            }else if(![obj isKindOfClass:[NSString class]] && ![obj isKindOfClass:[NSNumber class]]){
//                NSLog(@"string");
//
//            }else if([obj isKindOfClass:[NSString class]]){
//                NSLog(@"nothing");
//            }
//
//        }];
//        [NSDictionary dictionaryWithObjectsAndKeys:
//         @"samvermette", @"screen_name",
//         @"original", @"size",
//         nil]

//上传图片
-(NSString*)getBookList{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getBookListByClassId",wxxbaseURL];
}

//getBigClassListToClassId

//子分类
-(NSString*)getBigClassList{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getBigClassToClassId",wxxbaseURL];
}

//分类
-(NSString*)getClassList{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getclassList",wxxbaseURL];
}


//根据id获取book
-(NSString*)getbook4Id{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getBook4Id",wxxbaseURL];
}

//搜索
-(NSString*)getSearchBookList{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getSearchBookList",wxxbaseURL];
}

//登录(第三方数据)
-(NSString*)getLoginToThree{
    
    return [NSString stringWithFormat:@"%@?c=user&a=getLoginToThree",wxxbaseURL];

}

//更新金币
-(NSString*)updateCoin{
//    ,@"user_openId",
    return [NSString stringWithFormat:@"%@?c=user&a=updateCoin&user_openId=%@",wxxbaseURL,[UserData sharedUserData].uuser_openId];
}

-(NSString*)sendErrortoServer{
    
    return [NSString stringWithFormat:@"%@?c=main&a=createNewError",wxxbaseURL];
}

//获取更改的书籍信息 服务端用时间对比
-(NSString*)getBookListByUpdate{
    
    return [NSString stringWithFormat:@"%@?c=book&a=getBookListByUpdate",wxxbaseURL];
}
//提交评论
-(NSString*)sendFeedbackOne{
    
    return [NSString stringWithFormat:@"%@?c=feedback&a=createFeedBack",wxxbaseURL];
}
//获取评论列表
-(NSString*)getFeedBackList4BookId{
    
    return [NSString stringWithFormat:@"%@?c=feedback&a=getFeedBackList4BookId",wxxbaseURL];
}

//查询制定ID集合等用户列表
-(NSString*)getFindUser4IdS{
    
    return [NSString stringWithFormat:@"%@?c=user&a=findUser4IdS",wxxbaseURL];
}


//获取app信息
-(NSString*)getAppBaseInfo{
    
    return @"http://huuua.com/ostory/app.php?1=1";
}
//更多app
-(NSString*)getMoreAppLsit{
    
    return @"http://huuua.com/ostory/more_app.php?1=1";
}




#define openUdid [OpenUDID value]//
-(NSString*)sendDevice2Server{
    return [NSString stringWithFormat:@"%@?openudid=%@",@"http://huuua.com/ostory/device.php",openUdid];
}


-(NSString*)getAdINfoList{
    return [NSString stringWithFormat:@"%@?1=1",@"http://huuua.com/ostory/ad.php"];
}

-(NSString*)sendTouchAd:(NSString*)adId{
    return [NSString stringWithFormat:@"%@?id=%@",@"http://huuua.com/ostory/click_ad.php",adId];
}

//验证设备唯一码是否注册过
-(NSString*)sendDeviceUDID{
    NSString *macStr   = [self macString];
    NSString *openudid = [self getOpenUdid];
    NSString *idfu     = [self idfvString];
    NSString *idfa     = [self idfaString];
    
    NSString *useragentStr = [NSString stringWithFormat:@"mac=%@&idfa=%@&idfu=%@&openudid=%@",macStr,idfa,idfu,openudid];
    return [NSString stringWithFormat:@"%@?c=user&a=checkUserNewuser&us_openid=%@",wxxbaseURL,useragentStr];
}



/**
 *json解析加入容错处理
 */
- (id)parseJSONData:(NSData *)data
{
    if (!data || [data length]<=0) {
        NSLog(@"返回空数据");
        return nil;
    }
    NSError *error = nil;
    NSError *parseError = nil;
	id result =[data objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&parseError];
	
	if (parseError && (error != nil))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  parseError, @"error",
                                  @"Data parse error", NSLocalizedDescriptionKey, nil];
        error = [self errorWithCode:200
                            userInfo:userInfo];
	}
    if (error) {
        
        NSLog(@"弹出错误提示");
        return nil;
    }
	
	return result;
}

//时间比较大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

-(NSString*)getNowDate{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSLog(@"时间:%@",[dateformatter stringFromDate:senddate]);
    return [dateformatter stringFromDate:senddate];
}

-(NSString*)getYYYYMMDD{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:senddate];
}

//传入时间和当前时间差
- (int)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
//    if (cha/3600<1) {86594
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
//    }
//    if (cha/3600>1&&cha/86400<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
////        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
//    }
//    if (cha/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
////        timeString=[NSString stringWithFormat:@"%@天前", timeString];
//    }
    [date release];
    return [timeString intValue];
}


- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    
    return [NSError errorWithDomain:kWxxErrorDomain code:code userInfo:userInfo];
}

//mac地址
- (NSString *)macString {
    int     mib[6];size_t  len;char *buf;unsigned char *ptr;struct if_msghdr *ifm;struct sockaddr_dl  *sdl;
    mib[0] = CTL_NET;mib[1] = AF_ROUTE;mib[2] = 0;mib[3] = AF_LINK;mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) ==0) {printf("Error: if_nametoindex error\n");return NULL;}
    if (sysctl(mib, 6, NULL, &len,NULL,0) <0) {printf("Error: sysctl, take 1\n");return NULL;}
    if ((buf = (char*)malloc(len)) == NULL) {printf("Could not allocate memory. error!\n");return NULL;}
    if (sysctl(mib,6, buf, &len,NULL,0) <0) {printf("Error: sysctl, take 2");free(buf);return NULL;}
    ifm = (struct if_msghdr*)buf;sdl = (struct sockaddr_dl*)(ifm + 1);ptr = (unsigned char*)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);return macString;
}
//openid
-(NSString*)getOpenUdid{return openUdid;}
//adtrackid
- (NSString *)getAdtID {
    NSString *idfa = [[NSUserDefaults standardUserDefaults] valueForKey:KYDIDFA];
    if (idfa != nil && ![idfa isEqualToString:@""]){return idfa;}else{NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];[[NSUserDefaults standardUserDefaults] setValue:idfa forKeyPath:KYDIDFA];return idfa;}
}
- (NSString *)idfaString {NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];[adSupportBundle load];if (adSupportBundle == nil) {return @"";}else{Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");if(asIdentifierMClass == nil){return @"";}else{
    //for no arc
    //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
    //for arc
    ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
    if (asIM == nil) {return @"";}else{if(asIM.advertisingTrackingEnabled){                    return [asIM.advertisingIdentifier UUIDString];}else{return [asIM.advertisingIdentifier UUIDString];}}}}
}
- (NSString *)idfvString{if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {return [[UIDevice currentDevice].identifierForVendor UUIDString];}return @"";}

@end
