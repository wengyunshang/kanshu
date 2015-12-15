//
//  FeedBackData.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/11/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//
#import "WxxBaseData.h"
#import <Foundation/Foundation.h>
#define feed_id @"feed_id"
#define feed_text @"feed_text"
#define book_id @"book_id"
#define user_openId @"user_openId"
#define feed_callid @"feed_callid"
#define feed_time @"feed_time"
#define feed_start @"feed_start"
@interface FeedBackData : WxxBaseData
@property (nonatomic,strong)NSString *ffeed_id;
@property (nonatomic,strong)NSString *fuser_openId;
@property (nonatomic,strong)NSString *ffeed_text;
@property (nonatomic,strong)NSString *fbook_id;
@property (nonatomic,strong)NSString *ffeed_callid;
@property (nonatomic,strong)NSString *ffeed_time;
@property (nonatomic,strong)NSString *ffeed_start;
@end
