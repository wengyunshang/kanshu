//
//  BookInfoView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/7/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookData;
@interface BookInfoView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
//-(UIView *)initBookInfo:(BookData*)bookdata;
- (id)initWithFrame:(CGRect)frame bookData:(BookData *)bookData;
@end
