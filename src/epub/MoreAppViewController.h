//
//  MoreAppViewController.h
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GoogleMobileAds/GADBannerView.h"


@interface MoreAppViewController : UITableViewController<SKStoreProductViewControllerDelegate>{
    GADBannerView *bannerView_;
} 
@end
