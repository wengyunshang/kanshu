//
//  WxxIapStore.m
//  driftbottle
//
//  Created by weng xiangxun on 13-11-18.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxIapStore.h"
#import "BlockUI.h"

@interface WxxIapStore()
@property (nonatomic,assign)int price;
@property (nonatomic,assign)int bookId;

@end

@implementation WxxIapStore

static WxxIapStore *_sharedWxxIapStore = nil;
/**
 数据库采用单例模式: 不必每个地方去管理
 */
+ (WxxIapStore *)sharedWxxIapStore{
    if (!_sharedWxxIapStore) {
        _sharedWxxIapStore = [[self alloc] init];
        // 监听购买结果
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedWxxIapStore];
    }
    return _sharedWxxIapStore;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        self.ynDown = false;
    }
    return self;
}

//步骤1购买
-(void)buyGood:(int)price{
    self.price = price;
    if (price==0) {
        [self sendObject:BUYSECCUSS];
        return;
    }
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}
//先用bookId 购买，如果没查到bookId的价格iap,就用price购买一次性的
-(void)buyGoodPrice:(int)price  bookId:(int)bookid{
    self.price = price;
    self.bookId = bookid;
    if (price==0) {
        [self sendObject:BUYSECCUSS];
        return;
    }
//    com.wxx.zhangailin.6
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}


-(void)restore{
    // Assign an observer to monitor the transaction status.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // Request to restore previous purchases.
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
//步骤2
- (void)getProductInfo {
    
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    //内购id格式必须为： bundleid+价格  如： com.wxx.epub.6
    NSSet * set = [NSSet setWithArray:@[[NSString stringWithFormat:@"%@.%d",bundleid,self.price]]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

//步骤3
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        [self sendObject:BUYERROR];
        return;
    }
    
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// 步骤4
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"交易中");

                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    NSLog(@"");
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
 
    [self sendObject:@"1"];
}
 

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
NSLog(@"");
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
//    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
    }
    [self sendObject:BUYSECCUSS];
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
//        NSLog(@"购买失败%@----%@",transaction.error.domain,transaction.error.code);
         [self sendObject:BUYERROR];
    } else {
        NSLog(@"用户取消交易");
         [self sendObject:BUYERROR];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSArray *array = queue.transactions;
    if ([array count]==0) {
        NSLog(@"没有已购买项目。");
        [self sendObject:@"1"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL("提示") message:LOCAL("没有已购买项目") delegate:Nil cancelButtonTitle:LOCAL("确定") otherButtonTitles:Nil, nil];
//        [alertView show];
    }else{
//        for (int i =0 ; i<[array count]; i++) {
//            SKPaymentTransaction *skPay = array[i];
//             
            [self sendObject:array];
//        }
    }
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



@end
