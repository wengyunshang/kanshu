//
//  WxxBaseData.h
//  driftbottle
//
//  Created by weng xiangxun on 13-9-29.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PenSoundDao.h"
@interface NSObject(objNull)
-(BOOL)isNull;
@end
@implementation NSObject(objNull)
//是否为null
-(BOOL)isNull
{
	if(!self)
		return YES;
	if(self==[NSNull null])
		return YES;
	return NO;
}
@end
@interface WxxBaseData : NSObject
- (id)initWithDictionary:(NSDictionary*)dic;
-(void)saveSelfToDB;
-(void)updateSelf;
+ (id)initWithDictionary:(NSDictionary*)dic;
@end
