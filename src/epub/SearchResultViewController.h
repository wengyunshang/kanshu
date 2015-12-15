//
//  SearchResultViewController.h
//  PandaBook
//
//  Created by weng xiangxun on 15/4/11.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMobileAds/GADBannerView.h"
@interface SearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>{
GADBannerView *bannerView_;
}
-(void)setDicInfo:(id)respone;
@end
