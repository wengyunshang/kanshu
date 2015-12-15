//
//  WxxAdView.m
//  epub
//
//  Created by weng xiangxun on 14-3-28.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxAdView.h" 
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#define KYDIDFA @"KYDIDFA"
#import "WxxImageView.h"
#import "EncryptHelper.h"
#import "ResourceHelper.h"
#import "BlockUI.h"
#import "SDImageView+SDWebCache.h"
#import "BlackView.h"
#import "WxxButton.h"
#import "SVHTTPRequest.h"
#define openUdid [OpenUDID value]//

@interface WxxAdView()
//广告id，广告需要图片、跳转连接
@property (nonatomic,strong)NSString *wxxAdId;
@property (nonatomic,strong)NSString *wxxAdImgUrl;
@property (nonatomic,strong)NSString *wxxAdUrl;
@property (nonatomic,assign)float wxxorgx;
@property (nonatomic,assign)float wxxwidth;
//view
@property (nonatomic,strong)WxxImageView *wxxAdImgV;
@property (nonatomic,strong)WxxButton *closeBtn;
@property (nonatomic,strong)WxxButton *downloadBtn;


@property (nonatomic,strong)NSArray *adArray;//广告列表
@end

@implementation WxxAdView
#pragma mark -
#pragma mark Singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(WxxAdView);
-(void)dealloc{
    [_downloadBtn release];
    [_adArray release];
    [_wxxAdImgV release];
    [_wxxAdId release];
    [_closeBtn release];
    [_wxxAdUrl release];
    [_wxxAdImgUrl release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    int adwidth = CGRectGetWidth(UIBounds);
    int adheight = CGRectGetHeight(UIBounds);
    int adorgx = 0;
    int adorgy = 0;
    self = [super initWithFrame:CGRectMake(adorgx, adorgy, adwidth, adheight)];
    if (self) {
        self.wxxorgx = adorgx;
        self.wxxwidth = adwidth;
        self.backgroundColor = [UIColor clearColor];
        UIView *backV = [[UIView alloc]initWithFrame:self.frame];
        backV.backgroundColor = [UIColor blackColor];
        backV.alpha = 0.6;
        [self addSubview:backV];
        [backV release];
        
        [self getAdServerInfoList]; //获取广告列表
        
        self.wxxAdImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-280)/2,
                                                                        (CGRectGetHeight(self.frame)-260)/2,
                                                                        280,
                                                                        260)] autorelease];
        self.wxxAdImgV.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap)];
        [self.wxxAdImgV addGestureRecognizer:panRecognizer];//关键语句，给self.view添加一个手势监测；
        panRecognizer.numberOfTapsRequired = 1;
        [panRecognizer release];
        self.wxxAdImgV.tag = -1;//默认广告array下标 -1
        [self addSubview:self.wxxAdImgV];
        [self.wxxAdImgV receiveObject:^(id object) {
            //向服务端发送点击事件
            [self touchTap];
        }];
       
        
//
        //关闭按钮
        UIImage *closeImg = [ResourceHelper loadImageByTheme:@"Close-icon"];//[UIImage imageNamed:@"close-icon.png"];
        self.closeBtn = [[[WxxButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.wxxAdImgV.frame)-closeImg.size.width,
                                                                    CGRectGetMinY(self.wxxAdImgV.frame),
                                                                    closeImg.size.width,
                                                                    closeImg.size.height)] autorelease];
        [self.closeBtn setImage:closeImg forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
        
        [self.closeBtn receiveObject:^(id object) {
            [self hideWxxAdView];
        }];

        //下载按钮
        UIImage *downImg = [ResourceHelper loadImageByTheme:@"App-Appstore-icon"];//[UIImage imageNamed:@"close-icon.png"];
        self.downloadBtn = [[[WxxButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.wxxAdImgV.frame),
                                                                    CGRectGetMaxY(self.wxxAdImgV.frame)-downImg.size.height,
                                                                    downImg.size.width,
                                                                    downImg.size.height)] autorelease];
        [self.downloadBtn setImage:downImg forState:UIControlStateNormal];
        [self addSubview:self.downloadBtn];
        [self.downloadBtn receiveObject:^(id object) {
           
            //向服务端发送点击事件
            [self touchTap];
        }];
        //默认隐藏本view
        [self hideWxxAdView];
    }
    return self;
}

-(void)touchTap{
    //打开广告链接
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.adArray objectAtIndex:self.wxxAdImgV.tag] objectForKey:@"url"]]];
    //向服务端发送点击事件
    [self touchAdViewSendInfo];
}

-(void)hideWxxAdView{
    [BlackView orgXAnimation:self orgx:self.wxxwidth];
}

-(void)showWxxAdView{
    //如果有广告才显示
    if ([self.adArray count]>0) {
        [self changeAdViewImage]; //加载广告图片
        [BlackView orgXAnimation:self orgx:self.wxxorgx]; //滑出广告view
    }
}

//广告图片显示
-(void)changeAdViewImage{
    if ([self.adArray count]>0) {
        if (self.wxxAdImgV.tag+1 >= [self.adArray count]) {
            self.wxxAdImgV.tag = 0; //越界判断, 广告循环
        }else{
            self.wxxAdImgV.tag ++;
        }
//        NSLog(@"%d",self.wxxAdImgV.tag);
//        NSLog(@"%@",[[self.adArray objectAtIndex:self.wxxAdImgV.tag] objectForKey:@"img"]);
        [self.wxxAdImgV
         setImageWithURL:[NSURL URLWithString:[[self.adArray objectAtIndex:self.wxxAdImgV.tag] objectForKey:@"img"]]
            refreshCache:NO]; //图标, 不刷新，省流量
        
    }
}


//一、设备报道接口：
//url:http://ostory.duapp.com/device.php
//参数：
//id:appid
//mac:mac地址
//idfa:idfa
//idfu:idfu
//openudid:openudid
//hash:md5(appid+mac+idfa+idfu+openudid+appkey)
//
//返回值：无
// app启动注册设备信息给广告商
-(void)sendDeveceInfo2Server{
    NSString *macStr   = [self macString];
    NSString *openudid = [self getOpenUdid];
    NSString *idfu     = [self idfvString];
    NSString *idfa     = [self idfaString];
    NSString *md5strs  = [NSString stringWithFormat:@"%@%@%@%@%@%@",saiyuappid,macStr,idfa,idfu,openudid,saiyuappkey];
    NSString *md5Str   = [EncryptHelper md5:md5strs];

    [SVHTTPRequest GET:[WXXHTTPUTIL sendDevice2Server]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        saiyuappid,@"id",
                        macStr,@"mac",
                        idfa,@"idfa",
                        idfu,@"idfu",
                        md5Str,@"hash",nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                NSLog(@"设备注册成功%@",response);
    }];
}

//二、广告接口
//url:http://ostory.duapp.com/ad.php
//参数：
//id:appid
//
//返回值：
//[{"id":广告id,"img":图片地址,"url":链接地址}
//{"id":广告id,"img":图片地址,"url":链接地址}
//{"id":广告id,"img":图片地址,"url":链接地址}
//{"id":广告id,"img":图片地址,"url":链接地址}]
//请求广告列表
-(void)getAdServerInfoList{
//    mac,idfa,idfu,openudid
    NSString *macStr   = [self macString];
    NSString *openudid = [self getOpenUdid];
    NSString *idfu     = [self idfvString];
    NSString *idfa     = [self idfaString];

    NSString *useragentStr = [NSString stringWithFormat:@"mac=%@&idfa=%@&idfu=%@&openudid=%@",macStr,idfa,idfu,openudid];
    NSLog(@"-----%@",useragentStr);
    [SVHTTPRequest setDefaultUserAgent:useragentStr];
    [SVHTTPRequest GET:[WXXHTTPUTIL getAdINfoList]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        saiyuappid,@"id", nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                NSLog(@"设备注册成功%@",response);
                if (response) {
                    self.adArray = response;//广告列表
                }
    }];
}

//点击广告时候：请求http://ostory.duapp.com/click_ad.php?id=广告接口返回的id
//ong  23:34:52
//user_agent发送四个设备标识
//点击广告，发送到服务端
-(void)touchAdViewSendInfo{
    NSString *macStr   = [self macString];
    NSString *openudid = [self getOpenUdid];
    NSString *idfu     = [self idfvString];
    NSString *idfa     = [self idfaString];
    NSString *md5strs  = [NSString stringWithFormat:@"%@%@%@%@%@%@",saiyuappid,macStr,idfa,idfu,openudid,saiyuappkey];
    NSString *md5Str   = [EncryptHelper md5:md5strs];
    NSString *useragentStr = [NSString stringWithFormat:@"hash=%@&mac=%@&idfa=%@&app_id=%@&idfu=%@&openudid=%@",md5Str,macStr,idfa,saiyuappid,idfu,openudid];
    NSString *adId     = [[self.adArray objectAtIndex:self.wxxAdImgV.tag] objectForKey:@"id"]; //广告id
    
    [SVHTTPRequest setDefaultUserAgent:useragentStr];
    [SVHTTPRequest GET:[WXXHTTPUTIL sendTouchAd:adId]
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                NSLog(@"点击广告成功%@",response);
            }];
    
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
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];if (asIM == nil) {return @"";}else{if(asIM.advertisingTrackingEnabled){                    return [asIM.advertisingIdentifier UUIDString];}else{return [asIM.advertisingIdentifier UUIDString];}}}}
}
- (NSString *)idfvString{if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {return [[UIDevice currentDevice].identifierForVendor UUIDString];}return @"";}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
