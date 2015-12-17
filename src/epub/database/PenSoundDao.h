//
//  PenSoundDao.h
//  LearningMachine0.1
//
//  Created by Jenson on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "BlockUI.h"
@class BookData;
@class ClassData;
@class FeedBackData;
@class UserData;
@class BigClassData;
@class HistoryData;
@interface PenSoundDao : BaseDao {
    
}
@property (nonatomic,assign)int limitNum;//当前界面跳到的位置
@property (nonatomic,assign)int limitMaxNum;//当前界面最大数字
+ (PenSoundDao *)sharedPenSoundDao;
-(void)updateBookBigData:(BigClassData*)bkData;
//
////增加
//-(void)insertUserData:(UserData*)usData;
////查询
//-(NSMutableArray *)selectUserData;
////更新
//-(void)updateUserData:(UserData*)usData;
////删除
//-(void)deleteUserData;
-(BigClassData*)selectBigClass4Sonid:(NSString*)sonid;
-(void)saveHistory:(HistoryData*)dbbData;
-(HistoryData*)selectHistory:(NSString*)bookId;
-(void)setMaxNum:(NSString*)classId;
-(void)saveBigClass:(BigClassData*)dbbData;
//保存聊天内容
-(void)saveBook:(BookData*)dbbData;
-(void)saveUser:(UserData*)dbbData;
//-(NSMutableArray*)selectBookList:(NSString*)ynDown;
-(void)delBook4Id:(NSString*)bookId;
-(NSString*)selectMaxBook_id:(NSString*)classId;
-(void)updateBookData:(BookData*)bkData;
//-(void)updateBookData:(BookData*)bkData;
-(void)updateBookData:(NSString*)bk_id  book_newarg:(NSString*)bk_new;
-(int)selectNewBookCount;
-(NSMutableArray*)selectMyBookList:(NSString*)ynDown;
-(ClassData*)selectClass:(NSString*)classId;
-(void)saveClass:(ClassData*)dbbData;
-(void)updateBookDataByServer:(BookData*)bkData;
//-(void)initClassInfo;
-(NSMutableArray*)selectClassList;
-(NSMutableArray*)selectBookList:(NSString*)ynDown limit:(int)limitnum classId:(NSString*)classId;
-(void)saveFeedBack:(FeedBackData*)dbbData;
-(NSMutableArray*)selectBookList0price;
-(NSMutableArray*)selectFeedBackByBookId:(NSString*)bookId;
-(NSString*)selectUserIds:(NSString*)bookId;
-(UserData*)selectUser:(NSString*)user_openIdarg;
-(NSMutableArray*)selectBigClassList:(NSString*)fatherId;
-(void)addDelBookIdToArr:(NSString*)bookId;
-(void)removeDelBookIdFromArr:(NSString*)bookId;
-(void)deleteSelectedBookArr;
//-(NSMutableArray *)selectBottleContent4Id:(NSString*)bottleId;
//-(NSString*)selectMaxBottleTime;
//-(void)saveStarData:(StarData*)starData;
//-(void)saveUserData:(UserData*)userData;
//-(StarData *)selectStarInfo4Openid:(NSString*)openId;
//-(UserData *)selectUserData4openId:(NSString*)usopenid;
//-(void)setUserSecret:(NSString*)secretStr;
//-(void)setUserEmail:(NSString*)email;
//-(BOOL)checkUserSecret:(NSString*)secretStr;
//-(NSArray*)selectCategoryList;
//-(void)isnertNewCategory:(NSString*)cateName;
//-(NSMutableArray*)selectPassInfoList;
//-(void)isnertNewPassinfo:(NSString*)passName passAccount:(NSString*)passAccount passPassword:(NSString*)passWord;
//-(void)delPassInfo:(int)passId;
//-(void)updatePassinfo:(NSString*)passName passAccount:(NSString*)passAccount passPassword:(NSString*)passWord passId:(int)passId;
//-(NSString*)selectUserEmail;
//-(UserData*)selectUseSecret;
//-(void)updateEmail:(NSString*)email secret:(NSString*)secret;
@end
