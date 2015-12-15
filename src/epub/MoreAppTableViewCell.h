//
//  MoreAppTableViewCell.h
//  bingyuhuozhige
//
//  Created by zhangcheng on 14-7-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WxxImageView.h"
#import "WxxLabel.h"
#import "WxxButton.h" 
@class AppData;
@class YLLabel;
@class EVCircularProgressView;

@interface MoreAppTableViewCell : UITableViewCell
@property (nonatomic,strong)WxxImageView *appImgV;
@property (nonatomic,strong)WxxLabel *appTitleLb;
@property (nonatomic,strong)YLLabel *appIntroduction; //介绍
@property (nonatomic,strong)EVCircularProgressView *progressView;
@property (nonatomic,strong)WxxButton *buyBtn;
@property (nonatomic,assign)int highHeight;//点击后的文本高度  用来计算点击后cell总高度
-(void)setCellInfo:(AppData*)appData;
-(void)highCell;
-(void)lowCell;
@end
