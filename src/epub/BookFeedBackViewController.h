//
//  BookFeedBackViewController.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/11/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMobileAds/GADInterstitial.h"
@class BookData;
@interface BookFeedBackViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,GADInterstitialDelegate>{
    GADInterstitial *interstitial_;
}
@property(nonatomic, retain) GADInterstitial *interstitial;
 
-(void)setBookData:(BookData *)bookData;
@end
