//
//  WxxIapStore.h
//  driftbottle
//
//  Created by weng xiangxun on 13-11-18.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#define BUYSECCUSS @"success" //购买chenggong
#define BUYERROR   @"error"   //购买失败
@interface WxxIapStore : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>{

}
@property (nonatomic,assign)BOOL ynDown; //是否正在下载， 一次只能下载一本
+ (WxxIapStore *)sharedWxxIapStore;
-(void)buyGood:(int)price;
-(void)restore;
@end
