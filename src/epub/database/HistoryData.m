//
//  HistoryData.m
//  PandaBook
//
//  Created by weng xiangxun on 15/4/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "HistoryData.h"

@implementation HistoryData

-(void)dealloc{
    
    [_hbookId release];
    [_hcurrentPageInSpineIndex release];
    [_hcurrentSpineIndex release];
    [_hcurrentTextSize release];
    [super dealloc];
}



+ (id)initWithDictionary:(NSDictionary*)dic{
    HistoryData *dbbdata = [[[HistoryData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.hbookId       = [dic objectForKey:hsbookId];
        self.hcurrentPageInSpineIndex     = [dic objectForKey:hscurrentPageInSpineIndex];
        self.hcurrentSpineIndex     = [dic objectForKey:hscurrentSpineIndex];
        self.hcurrentTextSize     = [dic objectForKey:hscurrentTextSize];
        
    }
    return self;
}



-(void)updateSelf{
    
    //    [[PenSoundDao sharedPenSoundDao] update:self];
}

//保存本实体到本地
-(void)saveSelfToDB{
    
    [[PenSoundDao sharedPenSoundDao]saveHistory:self];
}
@end
