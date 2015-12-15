//
//  WxxConstants.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-17.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxConstants.h"

@implementation WxxConstants

+(BOOL)isiphone{
    if([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPhone){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isipad{
    if([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPad){
        return YES;
    }else{
        return NO;
    }
}

@end
