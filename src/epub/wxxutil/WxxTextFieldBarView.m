//
//  WxxTextFieldBarView.m
//  driftbottle
//
//  Created by weng xiangxun on 13-8-29.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxTextFieldBarView.h"
#import "BlackView.h"
#import "WxxHttpUtil.h"
@interface WxxTextFieldBarView()
-(void)initTextFiled;
@end

#define topViewHeight 40
@implementation WxxTextFieldBarView

-(void)dealloc{
    [_textField release];
    [_topView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame receiveObject:(void(^)(WxxTextFieldBarViewType))function
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        _selfOrgy = CGRectGetMinY(self.frame); //无键盘时的位置
        _wxxTextFieldBlock = function;         //block
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];//键盘监听
        
        [self initTopView];//顶部
    }
    return self;
}
-(void)setSelfOrgy:(float)orgy{
    _selfOrgy = orgy;
}
-(void)initTopView{
    if (!self.topView) {
        self.topView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), topViewHeight)] autorelease];
        [self addSubview:self.topView];
        self.toolView.backgroundColor = [UIColor redColor];
    }
    [self initTextFiled]; //输入框
}

//改变为键盘状态
-(void)setTopBtnBackImg{
    tfbType = WxxTextFieldBarViewType1;
//    [self.topbtn setBackgroundImage:[UIImage imageNamed:@"toolview_nor"] forState:UIControlStateNormal];
//    [self.topbtn setBackgroundImage:[UIImage imageNamed:@"toolview_press"] forState:UIControlStateHighlighted];
}

//输入框
-(void)initTextFiled{
    if (!self.textField) {
        self.textField = [[[WxxTextField alloc]initWithFrame:CGRectMake(2, 2, UIBounds.size.width-4, 38)] autorelease];
        self.textField.delegate = self;
        self.textField.placeholder = @"点击输入评论";
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.returnKeyType = UIReturnKeySend;
        self.textField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.topView addSubview:self.textField];
    }
}


//重置toolview的frame
-(void)restToolViewFrame:(CGFloat)height{
//    CGRect rect = self.toolView.frame;
//    rect.size.height = height;
//    self.toolView.frame = rect;
    
    CGRect selfrect = self.frame;
    selfrect.size.height = CGRectGetHeight(self.topView.frame)+CGRectGetHeight(self.toolView.frame);
    self.frame = selfrect;
}

//键盘按确定, 战胜困难，战胜思维懒惰
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.textField.text length]<=0) {
        showAlert(@"提示", @"发送空内容是耍流氓的行为哦");
        return false;
    }
    [self showContent];//显示聊天内容
    [self hideKeyborder]; //隐藏键盘
    
    return YES;
}

//显示聊天内容
-(void)showContent{
//    if ([self.textField.text length]<=5) {
//        //请至少输入5个文字
//        showAlert(@"提示", @"请输入5个字以上");
//        return;
//    }
    
    //聊天内容
    [self sendObject:self.textField.text];
    //清空输入框
    
    self.textField.text = @"";
}




//键盘改变状态
- (void)keyboardWillShow:(NSNotification *)notification
{
    ynShowKeyBorder = YES;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f",_selfOrgy - kbSize.height);
    
    [BlackView orgYAnimation:self orgY:UIBounds.size.height - kbSize.height-40 duration:0.2];    //自适应代码
    [self restToolViewFrame:kbSize.height];//根据键盘高度设置toolview高度
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   [self setTopBtnBackImg];
}

//显示键盘
-(void)showKeyBorder{
    [BlackView orgYAnimation:self orgY:200 duration:0.5];
}

//隐藏键盘
-(void)hideKeyborder{
    if (ynShowKeyBorder) {
        ynShowKeyBorder = NO;
        [self.textField resignFirstResponder];
        [BlackView orgYAnimation:self orgY:_selfOrgy duration:0.2];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
