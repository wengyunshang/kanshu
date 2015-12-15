//
//  StoreTableVeiwCell.h
//  epub
//
//  Created by weng xiangxun on 14-3-2.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WxxImageView.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#import "EVCircularProgressView.h"
@class BookData;
@class YLLabel;
@interface StoreTableVeiwCell : UITableViewCell

@property (nonatomic,strong)WxxImageView *bookImgV;
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookIntroduction; //介绍

@property (nonatomic,strong)UIImageView *newImageV;//new
@property (nonatomic,strong)WxxLabel *bookAuthorLb;
@property (nonatomic,strong)WxxLabel *bookSize;
@property (nonatomic,strong)WxxLabel *bookIdLb;
@property (nonatomic,strong)WxxButton *buyBtn;
@property (nonatomic,assign)int highHeight;//点击后的文本高度  用来计算点击后cell总高度
-(void)setCellInfo:(BookData*)bookData row:(NSString*)row;
-(void)highCell;
-(void)lowCell;
@end
