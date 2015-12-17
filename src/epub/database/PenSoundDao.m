
//  PenSoundDao.m
//  LearningMachine0.1
//
//  Created by Jenson on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved. 
#import "PenSoundDao.h" 
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "BookData.h"
#import "FeedBackData.h"
#import "UserData.h"
#import "BigClassData.h"
#import "ClassData.h"
#import "HistoryData.h"
#define BOOK @"book"
#define BOOKBIGCLASS @"bookbigclass"
#define CLASS @"bookclass"
#define USER @"user"
#define HISTORY @"history"
#define FEEDBACK @"feedback"


@interface PenSoundDao()
@property (nonatomic,retain)NSMutableArray *delBookIdArr;//要删除的bookid列表
@end

@implementation PenSoundDao
static PenSoundDao *_sharedPenSoundDao = nil; 
/**
 数据库采用单例模式: 不必每个地方去管理
 */
+ (PenSoundDao *)sharedPenSoundDao{
    if (!_sharedPenSoundDao) {
        _sharedPenSoundDao = [[self alloc] init];
        
    }
    return _sharedPenSoundDao;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setMaxNum:bookClass];
        self.limitNum = self.limitMaxNum;
    }
    return self;
}


-(void)addDelBookIdToArr:(NSString*)bookId{
    if (!self.delBookIdArr) {
        self.delBookIdArr = [[[NSMutableArray alloc]init] autorelease];
    }

    [self.delBookIdArr addObject:bookId];
    NSLog(@"%ld",[self.delBookIdArr count]);
}

-(void)removeDelBookIdFromArr:(NSString*)bookId{
    if (self.delBookIdArr) {
        [self.delBookIdArr removeObject:bookId];
        if ([self.delBookIdArr count]<=0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideDeleteView" object:nil];
        }
    }
    
    NSLog(@"%ld",[self.delBookIdArr count]);
}

//删除选中的书籍
-(void)deleteSelectedBookArr{
    
    for (int i=0; i<[self.delBookIdArr count]; i++) {
        
        [super getDOCDatabase:DBNAME];
        
        NSString *bookId = [self.delBookIdArr objectAtIndex:i];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET book_down = '%@',book_downloadtime = '%@' WHERE book_id = '%@'",
                         BOOK,
                         @"0",//设置为未下载
                         timeSp, //本字段不加密，排序用
                         bookId];
        
        [db executeUpdate:sql];
        if ([db hadError]) {
            //NSLog(@"更新错误 请到这里(updateScore:)断点测试");
        }
        [super closeDatabase];

    }
    
}

-(void)setMaxNum:(NSString*)classId{
    self.limitMaxNum = [self selectBookCount:classId];
    self.limitNum = self.limitMaxNum;
}

//初始化类别表
//-(void)initClassInfo{
//    [super getDOCDatabase:DBNAME];
//   
//    NSString *sql = @"INSERT INTO `bookclass` (`class_id`, `class_name`, `class_book`, `class_logo`, `class_time`, `class_url`, `class_url2`) VALUES (3, '小说', 'book', 'logo', '2014-03-03', '123', ''),(5, 'appstore', 'book', 'logo', '2014-04-08', '', ''),(6, '古典文学', 'book', 'logo', '2014-04-11', '', ''),(7, '佛经', 'book', 'logo', '2014-04-16', 'http://pkg.gao7gao8.com/epub', 'http://fojing.qiniudn.com'),(11, '穿越小说', 'book', 'logo', '2014-06-11', 'http://pkg.gao7gao8.com/epub', 'http://wxxbook.qiniudn.com'),(12, '英文书', 'book', 'logo', '2014-06-26', '', ''),(13, '古文', 'book', 'logo', '2014-06-28', 'http://pkg.gao7gao8.com/epub', 'http://xstory.qiniudn.com'),(14, '耽美小说', 'book', 'logo', '2014-07-03', '', ''),(15, '豆瓣高分图书', 'book', 'logo', '2014-07-06', '', '');";
//   
//    [db executeUpdate:sql];
//    if ([db hadError]) {
//        NSLog(@"添加错误 请到这里(initClassInfo:)断点测试");
//    }
//    [super closeDatabase];
//}
//查询瓶子列表
-(BigClassData*)selectBigClass4Sonid:(NSString*)sonid{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where son_id = '%@'",BOOKBIGCLASS,sonid];//连表查询
    
    NSLog(@"sql:%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    
    BigClassData *dbData = [[[BigClassData alloc]init] autorelease];
    while ([rs next]) {
        
        dbData.bbig_id      = [rs stringForColumn:big_id];
        dbData.bclass_buy     = [rs stringForColumn:class_buy];
        dbData.bclass_logo    = [rs stringForColumn:class_logo];
        dbData.bclass_price     = [rs stringForColumn:class_price];
        dbData.bfather_id     = [rs stringForColumn:father_id];
        dbData.bson_id     = [rs stringForColumn:son_id];
    }
    [super closeDatabase];
    return dbData;
}


-(NSMutableArray*)selectBigClassList:(NSString*)fatherId{
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where father_id = '%@'",BOOKBIGCLASS,fatherId];// 
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
    
    while ([rs next]) {
        BigClassData *dbData = [[BigClassData alloc]init];
        dbData.bbig_id = [rs stringForColumn:big_id];
        dbData.bfather_id = [rs stringForColumn:father_id];
        dbData.bson_id = [rs stringForColumn:son_id];
        dbData.bclass_logo = [rs stringForColumn:class_logo];
        dbData.bclass_price = [rs stringForColumn:class_price];
        dbData.bclass_buy = [rs stringForColumn:class_buy];
        [infoArr addObject:dbData];
        [dbData release];
        
    }
    [super closeDatabase];
    return infoArr;
}

-(void)updateBookBigData:(BigClassData*)bkData{
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET big_id = '%@',father_id = '%@',son_id = '%@',class_logo = '%@',class_price='%@' WHERE big_id = '%@'",
                     BOOKBIGCLASS,
                     bkData.bbig_id,bkData.bfather_id,bkData.bson_id,bkData.bclass_logo,bkData.bclass_price,bkData.bbig_id];
    if (bkData.bclass_buy) {
        sql = [NSString stringWithFormat:@"UPDATE %@ SET big_id = '%@',father_id = '%@',son_id = '%@',class_logo = '%@',class_price='%@',class_buy='%@' WHERE big_id = '%@'",
                         BOOKBIGCLASS,
                         bkData.bbig_id,bkData.bfather_id,bkData.bson_id,bkData.bclass_logo,bkData.bclass_price,bkData.bclass_buy,bkData.bbig_id];
    }
    
    
    [db executeUpdate:sql];
    if ([db hadError]) {
        NSLog(@"更新错误 请到这里(updateScore:)断点测试");
    }
    [super closeDatabase];
}

-(void)saveBigClass:(BigClassData*)dbbData{

    [super getDOCDatabase:DBNAME];

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (big_id,father_id,son_id,class_logo,class_price) VALUES ('%@','%@','%@','%@','%@')",BOOKBIGCLASS,
                     dbbData.bbig_id,
                     dbbData.bfather_id,
                     dbbData.bson_id,
                     dbbData.bclass_logo,
                     dbbData.bclass_price
                     ];
    NSLog(@"%@",sql);
    [db executeUpdate:sql];
    if ([db hadError]) {
        [dbbData updateSelf];
        NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
    }
    [super closeDatabase];
    
}


//书本内容保存
-(void)saveBook:(BookData*)dbbData{
    NSLog(@"书籍id%@",dbbData.bbook_id);
    [super getDOCDatabase:DBNAME];
    if (!dbbData.bbook_down) {
        dbbData.bbook_down = 0;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (book_id,book_author,book_coverurl,book_file,book_name,book_price,book_time,book_url,class_id,book_size,book_introduction,book_down,book_new,book_doubanlogo,book_local) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",BOOK,
                     dbbData.bbook_id,
                     dbbData.bbook_author,
                     dbbData.bbook_coverurl,
                     dbbData.bbook_file,
                     dbbData.bbook_name,
                     dbbData.bbook_price,
                     dbbData.bbook_time,
                     dbbData.bbook_url,
                     dbbData.bclass_id,
                     dbbData.bbook_size,
                     dbbData.bbook_introduction,
                     dbbData.bbook_down,
                     dbbData.bbook_new,
                     dbbData.bbook_doubanlogo,
                     dbbData.bbook_local];
    NSLog(@"%@",sql);
    [db executeUpdate:sql];
    if ([db hadError]) {
        NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
    }
    [super closeDatabase];
    
    [self setMaxNum:bookClass]; //保存书后重新设置最大书籍
}





//检查新书数量
-(int)selectNewBookCount{
    //    SELECT *
    //    FROM bottle where bo_time = (select max(bo_time) from bottle)
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(book_new) FROM %@ WHERE book_new = '%@'",BOOK,@"1"];
    
	FMResultSet *rs = [db executeQuery:sql];
    
	NSString *bookcount = nil;
	while ([rs next]) {
        
        bookcount = [rs stringForColumn:@"COUNT(book_new)"];
    }
	[super closeDatabase];
    if (bookcount) {
        return [bookcount intValue];
    }
    return 0;
}


//删除书本
-(void)delBook4Id:(NSString*)bookId{
    
    [super getDOCDatabase:DBNAME];
    
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@ WHERE book_id = '%@'",BOOK,bookId];
    
	[db executeUpdate:sql];
	if ([db hadError]) {
		NSLog(@"删除错误 请到这里(deleteUserData:)断点测试");
	}
	[super closeDatabase];
    
}


//
-(NSString*)selectMaxBook_id:(NSString*)classId{
//    SELECT *
//    FROM bottle where bo_time = (select max(bo_time) from bottle)
    
    [super getDOCDatabase:DBNAME];
// where book_down = '%@'  ,noDown)
    NSString *sql = [NSString stringWithFormat:@"select max(book_id) from %@ where class_id = '%@'",BOOK,classId];
    
	FMResultSet *rs = [db executeQuery:sql];
    
	NSString *bookId = nil;
	while ([rs next]) {
	
        bookId = [rs stringForColumn:@"max(book_id)"];
    }
	[super closeDatabase];
    
    return bookId;
}


-(BOOL)ynhaveHistory:(NSString *)bookId{
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where bookId = '%@'",HISTORY,bookId];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSString *bookIds = nil;
    while ([rs next]) {
        
        bookIds = [rs stringForColumn:@"count(*)"];
    }
    [super closeDatabase];
    if ([bookIds intValue]>0) {
        return YES;
    }
    return NO;
}

-(void)saveHistory:(HistoryData*)dbbData{
//#define currentSpineIndex @"currentSpineIndex"
//#define currentPageInSpineIndex @"currentPageInSpineIndex"
//#define currentTextSize @"currentTextSize"
//#define hsbookId @"bookId"
    //是否存在
    if ([self ynhaveHistory:dbbData.hbookId]) {
        [super getDOCDatabase:DBNAME];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET currentSpineIndex = '%@', currentPageInSpineIndex = '%@',currentTextSize = '%@' WHERE bookId = '%@'",
                         HISTORY,
                         dbbData.hcurrentSpineIndex,
                         dbbData.hcurrentPageInSpineIndex,
                         dbbData.hcurrentTextSize,
                         dbbData.hbookId];
        [db executeUpdate:sql];
        if ([db hadError]) {
            //NSLog(@"更新错误 请到这里(updateScore:)断点测试");
        }
        [super closeDatabase];
    }else{
        [super getDOCDatabase:DBNAME];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (currentSpineIndex,currentPageInSpineIndex,currentTextSize,bookId) VALUES ('%@','%@','%@','%@')",HISTORY,
                         dbbData.hcurrentSpineIndex,
                         dbbData.hcurrentPageInSpineIndex,
                         dbbData.hcurrentTextSize,
                         dbbData.hbookId];
        
        NSLog(@"%@",sql);
        [db executeUpdate:sql];
        if ([db hadError]) {
            NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
        }
        [super closeDatabase];
    }
}

//查询瓶子列表
-(HistoryData*)selectHistory:(NSString*)bookId{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where bookId = '%@'",HISTORY,bookId];//连表查询
    
    NSLog(@"sql:%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    
    HistoryData *dbData = [[[HistoryData alloc]init] autorelease];
    while ([rs next]) {
        
        dbData.hbookId      = [rs stringForColumn:hsbookId];
        dbData.hcurrentPageInSpineIndex     = [rs stringForColumn:hscurrentPageInSpineIndex];
        dbData.hcurrentSpineIndex    = [rs stringForColumn:hscurrentSpineIndex];
        dbData.hcurrentTextSize     = [rs stringForColumn:hscurrentTextSize];

    }
    [super closeDatabase];
    return dbData;
}

-(void)saveUser:(UserData*)dbbData{
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (user_id,user_email,user_gold,user_logo,user_name,user_openId) VALUES ('%@','%@','%@','%@','%@','%@')",USER,
                     dbbData.uuser_id,
                     dbbData.uuser_email,
                     dbbData.uuser_gold,
                     dbbData.uuser_logo,
                     dbbData.uuser_name,
                     dbbData.uuser_openId];
    NSLog(@"%@",sql);
    [db executeUpdate:sql];
    if ([db hadError]) {
        NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
    }
    [super closeDatabase];
}
//查询瓶子列表
-(UserData*)selectUser:(NSString*)user_openIdarg{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where user_openId = '%@'",USER,user_openIdarg];//连表查询
    
    NSLog(@"sql:%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    
    UserData *dbData = [[[UserData alloc]init] autorelease];
    while ([rs next]) {
        
        dbData.uuser_id      = [rs stringForColumn:user_id];
        dbData.uuser_name     = [rs stringForColumn:user_name];
        dbData.uuser_logo    = [rs stringForColumn:user_logo];
        dbData.uuser_openId     = [rs stringForColumn:user_openId];
        dbData.uuser_email     = [rs stringForColumn:user_email];
        dbData.uuser_gold     = [rs stringForColumn:user_gold];
    }
    [super closeDatabase];
    return dbData;
}

-(void)saveFeedBack:(FeedBackData*)dbbData{
    
    [super getDOCDatabase:DBNAME];
 
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (feed_id,feed_text,book_id,feed_callid,feed_time,feed_start,user_openId) VALUES ('%@','%@','%@','%@','%@','%@','%@')",FEEDBACK,
                     dbbData.ffeed_id,
                     dbbData.ffeed_text,
                     dbbData.fbook_id,
                     dbbData.ffeed_callid,
                     dbbData.ffeed_time,
                     dbbData.ffeed_start,
                     dbbData.fuser_openId];
    NSLog(@"%@",sql);
    [db executeUpdate:sql];
    if ([db hadError]) {
        NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
    }
    [super closeDatabase];
}



//查询书籍等评论等用户不存在用户表中等ids(拿来去服务端获取用户信息)
-(NSString*)selectUserIds:(NSString*)bookId{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT user_openId FROM %@ where book_id = '%@' AND user_openId not in (select user_openId from %@) GROUP BY user_openId",FEEDBACK,bookId,USER];//连表查询
    
    NSLog(@"sql:%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    
   
    NSMutableString *string1 = [[[NSMutableString alloc] initWithString:@""] autorelease];
   
    while ([rs next]) {
        NSLog(@"%@",[rs stringForColumn:user_openId]);
        [string1 appendString:[NSString stringWithFormat:@",'%@'",[rs stringForColumn:user_openId]]];
    }
    [super closeDatabase];
    NSString *s = [NSString stringWithString:string1];
    if ([s length]<= 0) {
        return nil;
    }
    return [[NSString stringWithString:string1] substringFromIndex:1];
}

//查询书籍等评论列表
-(NSMutableArray*)selectFeedBackByBookId:(NSString*)bookId{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where book_id = '%@' ORDER BY feed_time",FEEDBACK,bookId];//连表查询
    
    NSLog(@"sql:%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
    
    while ([rs next]) {
        FeedBackData *dbData = [[FeedBackData alloc]init];
        dbData.fbook_id      = [rs stringForColumn:book_id];
        dbData.ffeed_callid     = [rs stringForColumn:feed_callid];
        dbData.ffeed_id    = [rs stringForColumn:feed_id];
        dbData.ffeed_start     = [rs stringForColumn:feed_start];
        dbData.ffeed_text     = [rs stringForColumn:feed_text];
        dbData.ffeed_time = [rs stringForColumn:feed_time];
        dbData.fuser_openId = [rs stringForColumn:user_openId];
        [infoArr addObject:dbData];
        [dbData release];
        
    }
    [super closeDatabase];
    return infoArr;
}

//////更新信息
//-(void)updateBookData:(BookData*)bkData{
//    
//	[super getDOCDatabase:DBNAME];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    bkData.bbook_downloadtime = timeSp;//更新时间，我的书架排序用 //时间戳的值
//    
//	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET book_new = '%@',book_down = '%@',book_file = '%@',book_downloadtime = '%@' WHERE book_id = '%@'",
//                     BOOK,
//                     bkData.bbook_new),
//                     bkData.bbook_down),
//                     bkData.bbook_file),
//                     bkData.bbook_downloadtime, //本字段不加密，排序用
//                     bkData.bbook_id];
//    
//	[db executeUpdate:sql];
//	if ([db hadError]) {
//		//NSLog(@"更新错误 请到这里(updateScore:)断点测试");
//	}
//	[super closeDatabase];
//}


-(BOOL)ynhaveClass:(NSString *)classId{
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where class_id = '%@'",classId,classId];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSString *bookIds = nil;
    while ([rs next]) {
        
        bookIds = [rs stringForColumn:@"count(*)"];
    }
    [super closeDatabase];
    if ([bookIds intValue]>0) {
        return YES;
    }
    return NO;
}

-(void)saveClass:(ClassData*)dbbData{
    
    if ([self ynhaveClass:dbbData.cclass_id]) {
        [super getDOCDatabase:DBNAME];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET class_name = '%@', class_book = '%@',class_logo = '%@',class_url = '%@',class_url2 = '%@',class_title = '%@' WHERE class_id = '%@'",
                         CLASS,
                         dbbData.cclass_name,
                         dbbData.cclass_book,
                         dbbData.cclass_logo,
                         dbbData.cclass_url,
                         dbbData.cclass_url2,
                         dbbData.cclass_title,
                         dbbData.cclass_id];
        [db executeUpdate:sql];
        if ([db hadError]) {
            //NSLog(@"更新错误 请到这里(updateScore:)断点测试");
        }
        [super closeDatabase];
    }else{
        [super getDOCDatabase:DBNAME];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (class_id,class_name,class_book,class_logo,class_url,class_url2,class_title) VALUES ('%@','%@','%@','%@','%@','%@','%@')",CLASS,
                         dbbData.cclass_id,
                         dbbData.cclass_name,
                         dbbData.cclass_book,
                         dbbData.cclass_logo,
                         dbbData.cclass_url,
                         dbbData.cclass_url2,
                         dbbData.cclass_title];
        NSLog(@"%@",sql);
        [db executeUpdate:sql];
        if ([db hadError]) {
            NSLog(@"添加错误 请到这里(isnertNewCategory:)断点测试");
        }
        [super closeDatabase];
    }
    
    
}


//查询瓶子列表
-(ClassData*)selectClass:(NSString*)classId{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where class_id = '%@'",CLASS,classId];//连表查询
    
    NSLog(@"sql:%@",sql);
	FMResultSet *rs = [db executeQuery:sql];
    
	 ClassData *dbData = [[[ClassData alloc]init] autorelease];
	while ([rs next]) {
		
        dbData.cclass_id      = [rs stringForColumn:class_id];
        dbData.cclass_name     = [rs stringForColumn:class_name];
        dbData.cclass_book    = [rs stringForColumn:class_book];
        dbData.cclass_logo     = [rs stringForColumn:class_logo];
        dbData.cclass_url     = [rs stringForColumn:class_url];
		dbData.cclass_url2     = [rs stringForColumn:class_url2];
        dbData.cclass_title =[rs stringForColumn:class_title];
	}
	[super closeDatabase];
	return dbData;
}

-(NSMutableArray*)selectClassList{
    [super getDOCDatabase:DBNAME];
    
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录  ORDER BY book_price
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",CLASS];//连表查询limitNum
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
    
    while ([rs next]) {
        ClassData *dbData = [[ClassData alloc]init];
        dbData.cclass_id      = [rs stringForColumn:class_id];
        dbData.cclass_name     = [rs stringForColumn:class_name];
        dbData.cclass_book    = [rs stringForColumn:class_book];
        dbData.cclass_logo     = [rs stringForColumn:class_logo];
        dbData.cclass_url     = [rs stringForColumn:class_url];
        dbData.cclass_url2     = [rs stringForColumn:class_url2];
        dbData.cclass_title =[rs stringForColumn:class_title];
        [infoArr addObject:dbData];
        [dbData release];
    }
    [super closeDatabase];
    return infoArr;
}



////更新信息
-(void)updateBookData:(BookData*)bkData{
    
	[super getDOCDatabase:DBNAME];
	
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    bkData.bbook_downloadtime = timeSp;//更新时间，我的书架排序用 //时间戳的值
    
	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET book_new = '%@',book_down = '%@',book_file = '%@',book_downloadtime = '%@' WHERE book_id = '%@'",
                     BOOK,
                     bkData.bbook_new,
                     bkData.bbook_down,
                     bkData.bbook_file,
                     bkData.bbook_downloadtime, //本字段不加密，排序用
                     bkData.bbook_id];
    
	[db executeUpdate:sql];
	if ([db hadError]) {
		//NSLog(@"更新错误 请到这里(updateScore:)断点测试");
	}
	[super closeDatabase];
}

////更新信息
-(void)updateBookData:(NSString*)bk_id  book_newarg:(NSString*)bk_new{
    
	[super getDOCDatabase:DBNAME];
	
	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET book_new = '%@' WHERE book_id = '%@'",
                     BOOK,
                     bk_new,
                     bk_id];
    
	[db executeUpdate:sql];
	if ([db hadError]) {
		//NSLog(@"更新错误 请到这里(updateScore:)断点测试");
	}
	[super closeDatabase];
}

//服务端返回的更新信息
-(void)updateBookDataByServer:(BookData*)bkData{
    
	[super getDOCDatabase:DBNAME];
	
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    bkData.bbook_downloadtime = timeSp;//更新时间，我的书架排序用 //时间戳的值
    
	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET book_id = '%@',book_author = '%@',book_coverurl = '%@',book_file = '%@',book_name = '%@',book_price = '%@',book_time = '%@',book_url = '%@',class_id = '%@',book_size = '%@',book_introduction = '%@',book_down = '%@',book_new = '%@', book_doubanlogo='%@' WHERE book_id = '%@'",
                     BOOK,
                     bkData.bbook_id,
                     bkData.bbook_author,
                     bkData.bbook_coverurl,
                     bkData.bbook_file,
                     bkData.bbook_name,
                     bkData.bbook_price,
                     bkData.bbook_time,
                     bkData.bbook_url,
                     bkData.bclass_id,
                     bkData.bbook_size,
                     bkData.bbook_introduction,
                     bkData.bbook_down,
                     bkData.bbook_new,
                     bkData.bbook_doubanlogo,
                     bkData.bbook_id];
    
	[db executeUpdate:sql];
	if ([db hadError]) {
		//NSLog(@"更新错误 请到这里(updateScore:)断点测试");
	}
	[super closeDatabase];
}


//查询我的书架
-(NSMutableArray*)selectMyBookList:(NSString*)ynDown{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where book_down = '%@' ORDER BY book_downloadtime",BOOK,ynDown];//连表查询
    
    NSLog(@"sql:%@",sql);
	FMResultSet *rs = [db executeQuery:sql];
    
	NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
	
	while ([rs next]) {
		BookData *dbData = [[BookData alloc]init];
        dbData.bbook_url      = [rs stringForColumn:book_url];
        dbData.bbook_time     = [rs stringForColumn:book_time];
        dbData.bbook_price    = [rs stringForColumn:book_price];
        dbData.bbook_name     = [rs stringForColumn:book_name];
        dbData.bbook_file     = [rs stringForColumn:book_file];
        dbData.bbook_coverurl = [rs stringForColumn:book_coverurl];
        dbData.bbook_author   = [rs stringForColumn:book_author];
        dbData.bclass_id      = [rs stringForColumn:class_id];
        dbData.bbook_local    = [rs stringForColumn:book_local];
        dbData.bbook_id       = [rs stringForColumn:book_id];
        dbData.bbook_down     = [rs stringForColumn:book_down];
        dbData.bbook_size     = [rs stringForColumn:book_size];
        dbData.bbook_introduction = [rs stringForColumn:book_introduction];
        dbData.bbook_new = [rs stringForColumn:book_new];
        dbData.bbook_doubanlogo = [rs stringForColumn:book_doubanlogo];
        dbData.downType = downbefor;//未下载(store列表使用)
        [infoArr addObject:dbData];
		[dbData release];
		
	}
	[super closeDatabase];
	return infoArr;
}
//检查新书数量
-(int)selectBookCount:(NSString*)classId{
    
    [super getDOCDatabase:DBNAME];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(book_new) FROM %@ WHERE class_id = '%@' and book_down = '%@'",BOOK,classId,noDown];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSString *bookcount = nil;
    while ([rs next]) {
        
        bookcount = [rs stringForColumn:@"COUNT(book_new)"];
    }
    [super closeDatabase];
    if (bookcount) {
        return [bookcount intValue];
    }
    return 0;
}
/**
 *  ynDown:是否已下载
 *
 */
-(NSMutableArray*)selectBookList:(NSString*)ynDown limit:(int)limitnum classId:(NSString*)classId{
    [super getDOCDatabase:DBNAME];
    
    self.limitNum -= limitnum; //下次查询的起点 每次刷新都累减20条，
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录  ORDER BY book_price
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where class_id = '%@' and book_down = '%@' LIMIT %d,%d",BOOK,classId,ynDown,self.limitNum,self.limitMaxNum - self.limitNum];//连表查询limitNum
//    sql	NSString *	@"SELECT * FROM book where class_id = 'MTY=' and book_down = 'MA==' LIMIT 10,20"	0x00000001742a8d60
	FMResultSet *rs = [db executeQuery:sql];

	NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
	
	while ([rs next]) {
		BookData *dbData = [[BookData alloc]init];
        dbData.bbook_url      = [rs stringForColumn:book_url];
        dbData.bbook_time     = [rs stringForColumn:book_time];
        dbData.bbook_price    = [rs stringForColumn:book_price];
        dbData.bbook_name     = [rs stringForColumn:book_name];
        dbData.bbook_file     = [rs stringForColumn:book_file];
        dbData.bbook_coverurl = [rs stringForColumn:book_coverurl];
        dbData.bbook_author   = [rs stringForColumn:book_author];
        dbData.bclass_id      = [rs stringForColumn:class_id];
        dbData.bbook_id       = [rs stringForColumn:book_id];
        dbData.bbook_local    = [rs stringForColumn:book_local];
        dbData.bbook_down     = [rs stringForColumn:book_down];
        dbData.bbook_size     = [rs stringForColumn:book_size];
        dbData.bbook_introduction = [rs stringForColumn:book_introduction];
        dbData.bbook_new = [rs stringForColumn:book_new];
        dbData.bbook_doubanlogo = [rs stringForColumn:book_doubanlogo];
        dbData.downType = downbefor;//未下载(store列表使用)
        [infoArr addObject:dbData];
		[dbData release];
		
	}
	[super closeDatabase];
	return infoArr;
}

//查询0元未下载产品
-(NSMutableArray*)selectBookList0price{
    [super getDOCDatabase:DBNAME];
    // 获取表种 bottle_id过滤，且时间为最新的一条数据,   查询我发送的和捞到的瓶子的最新一条记录  ORDER BY book_price
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where book_down = '%@' and book_price = '%@'",BOOK,noDown,@"0"];//连表查询
    NSLog(@"%@",sql);
	FMResultSet *rs = [db executeQuery:sql];
    
	NSMutableArray *infoArr = [[[NSMutableArray alloc]init] autorelease];
	
	while ([rs next]) {
		BookData *dbData = [[BookData alloc]init];
        dbData.bbook_url      = [rs stringForColumn:book_url];
        dbData.bbook_time     = [rs stringForColumn:book_time];
        dbData.bbook_price    = [rs stringForColumn:book_price];
        dbData.bbook_name     = [rs stringForColumn:book_name];
        dbData.bbook_file     = [rs stringForColumn:book_file];
        dbData.bbook_coverurl = [rs stringForColumn:book_coverurl];
        dbData.bbook_author   = [rs stringForColumn:book_author];
        dbData.bclass_id      = [rs stringForColumn:class_id];
        dbData.bbook_id       = [rs stringForColumn:book_id];
        dbData.bbook_down     = [rs stringForColumn:book_down];
        dbData.bbook_size     = [rs stringForColumn:book_size];
        dbData.bbook_introduction = [rs stringForColumn:book_introduction];
        dbData.bbook_new = [rs stringForColumn:book_new];
        dbData.bbook_doubanlogo = [rs stringForColumn:book_doubanlogo];
        dbData.downType = downbefor;//未下载(store列表使用)
        [infoArr addObject:dbData];
		[dbData release];
		
	}
	[super closeDatabase];
	return infoArr;
}


@end

