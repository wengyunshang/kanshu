//
//  ToolBarView.h
//  epub
//
//  Created by weng xiangxun on 14-3-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarViewDelegate <NSObject>

-(void)setSeelctType:(setSelectType)type;
-(void)hideToolBarView;
@end


@interface ToolBarView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,assign)id<ToolBarViewDelegate> delegate;
-(void)hideSelf;
-(void)showSelf;

@end
