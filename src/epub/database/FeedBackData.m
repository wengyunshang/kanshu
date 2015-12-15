//
//  FeedBackData.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/11/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "FeedBackData.h"

@implementation FeedBackData
-(void)dealloc{
    
    [_ffeed_callid release];
    [_ffeed_id release];
    [_fuser_openId release];
    [_ffeed_start release];
    [_ffeed_text release];
    [_ffeed_time release];
    [_fbook_id release];
    [super dealloc];
}


+ (id)initWithDictionary:(NSDictionary*)dic{
    FeedBackData *dbbdata = [[[FeedBackData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.fuser_openId     = [dic objectForKey:user_openId];
        self.ffeed_callid       = [dic objectForKey:feed_callid];
        self.ffeed_id     = [dic objectForKey:feed_id];
        self.ffeed_start     = [dic objectForKey:feed_start];
        self.ffeed_text     = [dic objectForKey:feed_text];
        self.ffeed_time     = [dic objectForKey:feed_time];
        self.fbook_id     = [dic objectForKey:book_id];
        
    }
    return self;
}



-(void)updateSelf{
    
    //    [[PenSoundDao sharedPenSoundDao] update:self];
}

//保存本实体到本地
-(void)saveSelfToDB{
    
    [[PenSoundDao sharedPenSoundDao]saveFeedBack:self];
}
@end
