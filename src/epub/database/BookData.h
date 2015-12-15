//
//  BookData.h
//  epub
//
//  Created by weng xiangxun on 14-3-8.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxBaseData.h"
@class EVCircularProgressView;
#define book_name @"book_name"
#define book_price @"book_price"
#define book_author @"book_author"
#define book_local @"book_local"
#define class_id @"class_id"
#define book_url @"book_url"
#define book_coverurl @"book_coverurl"
#define book_time @"book_time"
#define book_file @"book_file"
#define book_id @"book_id"
#define book_down @"book_down"
#define book_introduction @"book_introduction"
#define book_size @"book_size"
#define book_new @"book_new"
#define book_downloadtime @"book_downloadtime" //下载时间，用来我的书架排序
#define book_doubanlogo @"book_doubanlogo" //豆瓣书本封面链接

typedef enum{
    downing, //下载中
    downbefor, //下载前
    downafter, //下载后
}bookDataDownType;

@interface BookData : WxxBaseData

@property (nonatomic,strong)EVCircularProgressView *progressView;
@property (nonatomic,assign)bookDataDownType downType;
@property (nonatomic,strong)NSString *bbook_introduction;
@property (nonatomic,strong)NSString *bbook_name;
@property (nonatomic,strong)NSString *bbook_down;
@property (nonatomic,strong)NSString *bbook_price;
@property (nonatomic,strong)NSString *bbook_author;
@property (nonatomic,strong)NSString *bclass_id;
@property (nonatomic,strong)NSString *bbook_url;
@property (nonatomic,strong)NSString *bbook_coverurl;
@property (nonatomic,strong)NSString *bbook_time;
@property (nonatomic,strong)NSString *bbook_file;
@property (nonatomic,strong)NSString *bbook_id;
@property (nonatomic,strong)NSString *bbook_size;
@property (nonatomic,strong)NSString *bbook_new;
@property (nonatomic,strong)NSString *bbook_downloadtime;
@property (nonatomic,strong)NSString *bbook_doubanlogo;
@property (nonatomic,strong)NSString *bbook_local;
-(void)updateSelf;
-(void)updateBook_newTo0;
-(void)updateBookDataByServer;
-(void)downFile;
-(EVCircularProgressView *)initProgreddView:(NSString *)priceStr;
@end
