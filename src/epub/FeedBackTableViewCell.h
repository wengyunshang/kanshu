//
//  FeedBackTableViewCell.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/9/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedBackData;
@interface FeedBackTableViewCell : UITableViewCell
-(void)setFeedInfo:(FeedBackData*)feeddata;
@end
