//
//  SettingsViewController.h
//  epub
//
//  Created by zhiyu on 13-6-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"
#import <StoreKit/StoreKit.h>
#import "GoogleMobileAds/GADBannerView.h"
#import "JMStaticContentTableViewController.h"
#import "HttpServerViewController.h"
@interface SettingsViewController : JMStaticContentTableViewController<UMFeedbackDataDelegate,SKStoreProductViewControllerDelegate>
{
    UMFeedback *_umFeedback;
    GADBannerView *bannerView_;
}
//@property (nonatomic,retain) HttpServerViewController *httpServerViewController;
@property(nonatomic, strong) UMFeedback *umFeedback;

@end
