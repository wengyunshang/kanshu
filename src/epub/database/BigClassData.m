//
//  BigClassData.m
//  PandaBook
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BigClassData.h"

@implementation BigClassData
-(void)dealloc{
   
    [_bbig_id release];
    [_bfather_id release];
    [_bson_id release];
    [_bclass_logo release];
    [_bclass_price release];
    [super dealloc];
}
+ (id)initWithDictionary:(NSDictionary*)dic{
    BigClassData *dbbdata = [[[BigClassData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.bbig_id = [dic objectForKey:big_id];
        self.bfather_id = [dic objectForKey:father_id];
        self.bson_id = [dic objectForKey:son_id];
        self.bclass_logo = [dic objectForKey:class_logo];
        self.bclass_price = [dic objectForKey:class_price];
//        self.uuser_email       = [dic objectForKey:user_email];
//        self.uuser_gold     = [dic objectForKey:user_gold];
//        self.uuser_id     = [dic objectForKey:user_id];
//        self.uuser_logo     = [dic objectForKey:user_logo];
//        self.uuser_name     = [dic objectForKey:user_name];
//        self.uuser_openId     = [dic objectForKey:user_openId];
        
    }
    return self;
}

-(void)updateSelf{ 
    [[PenSoundDao sharedPenSoundDao] updateBookBigData:self];
}

//保存本实体到本地
-(void)saveSelfToDB{
    
    [[PenSoundDao sharedPenSoundDao]saveBigClass:self];
}
@end
