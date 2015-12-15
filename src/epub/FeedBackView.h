//
//  FeedBackView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/8/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end
