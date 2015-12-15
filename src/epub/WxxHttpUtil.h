//
//  WxxHttpUtil.h
//  driftbottle
//
//  Created by weng xiangxun on 13-7-11.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WxxHttpUtil : NSObject
+(WxxHttpUtil *)sharedWxxHttpUtil;

-(NSString*)getBookList;
-(NSString*)sendDevice2Server;
-(NSString*)getAdINfoList;
-(NSString*)sendDeviceUDID;
-(NSString*)getBigClassList;
-(NSString*)getbook4Id;
-(NSString*)getSearchBookList;
-(NSString*)getLoginToThree;
-(NSString*)getFeedBackList4BookId;
-(NSString*)sendFeedbackOne;
-(NSString*)updateCoin;
-(NSString*)getFindUser4IdS;
-(NSString*)sendTouchAd:(NSString*)adId;
- (id)parseJSONData:(NSData *)data;
-(NSString*)getClassList;
//时间差
- (int)intervalSinceNow: (NSString *) theDate;
-(NSString*)getYYYYMMDD;
//时间比较大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDa;
-(NSString*)getNowDate;
//-(NSString*)sendUserOpenid:(NSString *)usOpenid;
-(NSString*)getBookListByUpdate;
-(NSString*)getAppBaseInfo;
-(NSString*)getMoreAppLsit;
-(NSString*)sendErrortoServer;
@end
