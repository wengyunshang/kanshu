//
//  StoreClassViewController.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreClassViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
-(void)getDataList;
@end
