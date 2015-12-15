//
//  WebStoreViewController.h
//  PandaBook
//
//  Created by weng xiangxun on 15/5/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebStoreViewController : UIViewController<UIWebViewDelegate>
-(void)loadUrl:(NSString*)urlarg;
-(void)loadUrlToArg:(NSString*)arg;
@end
