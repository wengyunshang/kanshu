//
//  BookTableViewCell.h
//  epub
//
//  Created by weng xiangxun on 14-3-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WxxImageView.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#import "BlockUI.h"
@class BookData;
@interface BookTableViewCell : UITableViewCell
 
-(void)setCellInfo:(BookData*)bookData;

-(void)setBookData1:(BookData*)bookdata;
-(void)setBookData2:(BookData*)bookdata;
-(void)setBookData3:(BookData*)bookdata;

-(void)showDelBtn;
-(void)hideDelBtn;

-(void)setBookSelected;
@end
