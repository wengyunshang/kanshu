//
//  ChapterListView.h
//  epub
//
//  Created by weng xiangxun on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockUI.h"
@class BookViewController;
@class WxxTableView;
@interface ChapterListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)WxxTableView *chapTableView;
@property(nonatomic, assign) BookViewController* bookViewController;

-(void)hideChapter;
-(void)showChapter;
-(void)initReadCell;
@end
