//
//  StoreTableViewCell.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14/10/28.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WxxButton.h"
@interface StoreLoadTableViewCell : UITableViewCell
@property (nonatomic,strong)WxxButton *loadBtn;
@property (nonatomic,assign)BOOL ynLoadnew;
-(void)setBtnTextToLoaded;
-(void)setBtnTextTonext;
@end
