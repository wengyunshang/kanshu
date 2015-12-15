//
//  EvSetingProgressView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-30.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    btnSet,
    btnTtfSize,
    btnTtfSizeAdd,
    btnColor,
    btnLight,
    btNothing,
}btnType;
@interface EvSetingProgressView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIColor *progressTintColor;
 - (void)showLine;
-(void)removeLayers;
@end
