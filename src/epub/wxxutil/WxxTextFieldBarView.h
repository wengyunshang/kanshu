//
//  WxxTextFieldBarView.h
//  driftbottle
//
//  Created by weng xiangxun on 13-8-29.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WxxTextField.h"
#import "WxxButton.h"
#import "BlockUI.h"
typedef enum {
    WxxTextFieldBarViewType1 = 0, //键盘
    WxxTextFieldBarViewType2,     //工具
    WxxTextFieldBarViewTypeContent,//内容
}WxxTextFieldBarViewType;


@interface WxxTextFieldBarView : UIView<UITextFieldDelegate>{
    CGFloat _selfOrgy; //初始化位置
    void(^_wxxTextFieldBlock)(WxxTextFieldBarViewType);
    WxxTextFieldBarViewType tfbType;
    BOOL ynShowKeyBorder;//是不是处于编辑
}

- (id)initWithFrame:(CGRect)frame receiveObject:(void(^)(WxxTextFieldBarViewType))function;
@property (nonatomic,strong)WxxTextField *textField; //输入框
@property (nonatomic,strong)WxxButton *topbtn; //状态按钮   键盘状态／工具状态
@property (nonatomic,strong)NSString *bottleId; //瓶子id
@property (nonatomic,strong)UIView *topView; //顶部输入框view
@property (nonatomic,strong)UIView *toolView; //底部工具栏
-(void)showKeyBorder;
-(void)hideKeyborder;
-(void)setSelfOrgy:(float)orgy;
@end
