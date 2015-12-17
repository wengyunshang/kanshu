//
//  BookButton.h
//  PandaBook
//
//  Created by weng xiangxun on 15/3/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WxxButton.h"
@class WxxImageView;
@class WxxLabel;
@class BookData;
@interface BookButton : UIButton<UIAlertViewDelegate>
@property (nonatomic,strong)WxxImageView *bookImgV;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookAuthorLb;
@property (nonatomic,strong)BookData *bookdata;
@property (nonatomic,strong)WxxButton *deleteBtn;
@property (nonatomic,strong) UIView *content;
@property (nonatomic,strong) UIView *cover;
-(void)reflashDataInfo;
-(void)showDeleteBtn;
-(void)hideDeleteBtn;
-(void)setBookSelected;
- (void)setupBookCoverImage:(UIImage *)image;
@end
