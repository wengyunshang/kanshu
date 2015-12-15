//
//  AboutViewController.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-2.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMobileAds/GADInterstitial.h"
@interface AboutViewController : UIViewController<GADInterstitialDelegate>
{
    GADInterstitial *interstitial_;
}
@property(nonatomic, retain) GADInterstitial *interstitial;
@end
