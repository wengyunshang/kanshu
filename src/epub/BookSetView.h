//
//  BookSetView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookSetView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableview;
-(void)hideSelf;
-(void)showSelf;
@end
