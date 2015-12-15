//
//  ClassData.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-6-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "UserData.h"
#import "SVHTTPRequest.h"
@implementation UserData


static UserData *_sharedUserData = nil;
/**
 数据库采用单例模式: 不必每个地方去管理
 */
+ (UserData *)sharedUserData{
    if (!_sharedUserData) {
        _sharedUserData = [[self alloc]init];
    }
    return _sharedUserData;
}


-(void)dealloc{
    
    [_uuser_email release];
    [_uuser_gold release];
    [_uuser_id release];
    [_uuser_logo release];
    [_uuser_name release];
    [_uuser_openId release];
    [super dealloc];
}



+ (id)initWithDictionary:(NSDictionary*)dic{
    UserData *dbbdata = [[[UserData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.uuser_email       = [dic objectForKey:user_email];
        self.uuser_gold     = [dic objectForKey:user_gold];
        self.uuser_id     = [dic objectForKey:user_id];
        self.uuser_logo     = [dic objectForKey:user_logo];
        self.uuser_name     = [dic objectForKey:user_name];
        self.uuser_openId     = [dic objectForKey:user_openId];
        
    }
    return self;
}



-(BOOL)ynLogin{
    
    NSLog(@"adfasdfasdfasdf");
    
    if (self.uuser_openId) {
        return YES;
    }
    return NO;
}

-(void)updateGold:(NSString*)goldNum{
    //更新用户的书币
    [SVHTTPRequest GET:[WXXHTTPUTIL updateCoin]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys: goldNum,@"user_gold",nil] //购买的书币
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                if (response) {
                    self.uuser_gold = goldNum;
                    [self updateSelf];
                }
    }];
    
}

-(void)updateSelf{

//    [[PenSoundDao sharedPenSoundDao] update:self];
}

//保存本实体到本地
-(void)saveSelfToDB{
    
    [[PenSoundDao sharedPenSoundDao]saveUser:self];
}
@end
