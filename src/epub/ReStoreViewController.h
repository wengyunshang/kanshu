//
//  StoreViewController.h
//  epub
//
//  Created by zhiyu on 13-6-8.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMobileAds/GADBannerView.h"
@interface ReStoreViewController : UITableViewController{
    GADBannerView *bannerView_;
}
-(void)setBookArr:(NSMutableArray *)bookArrDicar;
@end
