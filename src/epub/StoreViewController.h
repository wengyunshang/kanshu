//
//  StoreViewController.h
//  epub
//
//  Created by zhiyu on 13-6-8.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMobileAds/GADBannerView.h"
@interface StoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    GADBannerView *bannerView_;
}
-(void)setClassId:(NSString *)classId;

-(void)loadBOOOK;
-(void)intiRefreshBtn:(NSString*)img;
- (id)initWithClassId:(NSString*)classId;
@end
