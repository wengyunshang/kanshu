//
//  ToolBarView.m
//  epub
//
//  Created by weng xiangxun on 14-3-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ToolBarView.h"
#import "ResourceHelper.h"
#import "BlockUI.h"
#import "BookLightView.h"
#import "BookSetView.h"
#define toolbarHeight 50
@interface ToolBarView()
@property (nonatomic,retain)BookLightView *bookLightView;//亮度
@property (nonatomic,retain)UIView *toolView;
@property (nonatomic,retain)BookSetView *bookSetView;

@property (nonatomic,retain)UIButton *chapterListButton;
@property (nonatomic,retain)UIButton *fontbtn;
@property (nonatomic,retain)UIButton *lightbtn;
@end

@implementation ToolBarView
@synthesize chapterListButton,fontbtn,lightbtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
//        UIImageView *lineImgv = [[UIImageView alloc]initWithImage:[ResourceHelper loadImageByTheme:@"bottom_bar_shadow"]];
//        lineImgv.frame = CGRectMake((CGRectGetWidth(self.frame)-lineImgv.image.size.width)/2, 0, lineImgv.image.size.width, lineImgv.image.size.height);
//        [self addSubview:lineImgv];
//        [lineImgv release];
        
        [self initToolView];
        
//        self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.height), 0, self.frame.size.height, self.frame.size.height)];
////        self.settingsButton.backgroundColor = [UIColor redColor];
//        [settingsButton release];
//        [settingsButton setImage:[ResourceHelper loadImageByTheme:@"v3_reading_dict_setting"] forState:UIControlStateNormal];
//        [settingsButton setImage:[ResourceHelper loadImageByTheme:@"v3_reading_dict_setting"] forState:UIControlStateHighlighted];
//        [settingsButton addTarget:self action:@selector(popSetView) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:settingsButton];
        
        
    }
    return self;
}

-(void)initToolView{
    self.toolView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, toolbarHeight)] autorelease];
    self.toolView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
    [self addSubview:self.toolView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.toolView.frame.size.height, self.toolView.frame.size.height)];
    [backBtn setImage:[ResourceHelper loadImageByTheme:@"v3_reading_menu_back_normal"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    float width = 27;
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake((backBtn.frame.size.width-width)/2, (backBtn.frame.size.width-width)/2, width, width)];
    borderView.layer.cornerRadius = borderView.frame.size.width/2;
    borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    borderView.layer.borderWidth = 1;
    [self.toolView addSubview:borderView];
    [borderView release];
    [self.toolView addSubview:backBtn];
    [backBtn release];
    //目录
    self.chapterListButton = [[UIButton alloc] init];
    [chapterListButton setImage:[ResourceHelper loadImageByTheme:@"v3_reading_menu_catalog"] forState:UIControlStateNormal];
    [self.toolView addSubview:chapterListButton];
    [chapterListButton release];
    //字体
    self.fontbtn = [[UIButton alloc] init];
    
    [fontbtn setImage:[ResourceHelper loadImageByTheme:@"v3_reading_menu_font"] forState:UIControlStateNormal];
    [self.toolView addSubview:fontbtn];
    [fontbtn release];
    //亮度
    self.lightbtn = [[UIButton alloc] init];
    [lightbtn setImage:[ResourceHelper loadImageByTheme:@"v3_reading_menu_light"] forState:UIControlStateNormal];
    [self.toolView addSubview:lightbtn];
    [lightbtn release];
    
    [chapterListButton addTarget:self action:@selector(chaptBtn) forControlEvents:UIControlEventTouchUpInside];
    [fontbtn addTarget:self action:@selector(fontBtn) forControlEvents:UIControlEventTouchUpInside];
    [lightbtn addTarget:self action:@selector(lightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    chapterListButton.translatesAutoresizingMaskIntoConstraints = NO;
    fontbtn.translatesAutoresizingMaskIntoConstraints = NO;
    lightbtn.translatesAutoresizingMaskIntoConstraints = NO;
    //        backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    //        fontbtn.backgroundColor = [UIColor redColor];
    //        chapterListButton.backgroundColor = [UIColor redColor];
    //        lightbtn.backgroundColor = [UIColor redColor];
    
    float btnwidth = self.toolView.frame.size.height;
     
    [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lightbtn(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(lightbtn)]];
    [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[fontbtn(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(fontbtn)]];
    [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chapterListButton(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(chapterListButton)]];
    [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backBtn(height)]-0-|" options:0 metrics:@{@"height":@(btnwidth)} views:NSDictionaryOfVariableBindings(backBtn)]];
    
    [self.toolView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[chapterListButton(width)]-orgx-[fontbtn(width)]-orgx-[lightbtn(width)]-orgx-|" options:0 metrics:@{@"width":@(btnwidth),@"orgx":@(15)} views:NSDictionaryOfVariableBindings(lightbtn,fontbtn,chapterListButton)]];
    self.chapterListButton.alpha = 0.5;
    self.lightbtn.alpha = 0.5;
    self.fontbtn.alpha = 0.5;
}

//字体界面
-(void)initBookSetView{
    if (!self.bookSetView) {
        self.bookSetView = [[BookSetView alloc]initWithFrame:CGRectMake(0, UIBounds.size.height, UIBounds.size.width, 240)];
        [self insertSubview:self.bookSetView belowSubview:self.toolView];
        //        [KWPopoverView showPopoverAtPoint:CGPointMake(200, 400) inView:self.view withContentView:btt];
        [self.bookSetView receiveObject:^(id object) {
            
            setSelectType type = (setSelectType)object;
            
//            [self setViewBackGroundColor:type];
        }];
    }
    [self.bookSetView showSelf];
}
-(void)initLightView{
    
    if (!self.bookLightView) {
        self.bookLightView = [[BookLightView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, toolbarHeight+toolbarHeight*2)];
        [_bookLightView release];
        [self insertSubview:self.bookLightView belowSubview:self.toolView];
    }
    [self.bookLightView showSelf];
//    [self hideToolbar];
}

-(void)back{
    [self sendObject:setToolBack];
}
-(void)fontBtn{
//    [self sendObject:setToolFont];
    self.chapterListButton.alpha = 0.5;
    self.lightbtn.alpha = 0.5;
    self.fontbtn.alpha = 1;
    [self initBookSetView];
    [self.bookLightView hideSelf];
}
-(void)lightBtn{
//[self sendObject:setToolLight];
    self.chapterListButton.alpha = 0.5;
    self.lightbtn.alpha = 1;
    self.fontbtn.alpha = 0.5;
    [self initLightView];
    [self.bookSetView hideSelf];
}
-(void)chaptBtn{
    [self.bookLightView hideSelf];
    [self.bookSetView hideSelf];
    self.chapterListButton.alpha = 0.5;
    self.lightbtn.alpha = 0.5;
    self.fontbtn.alpha = 0.5;
    [self sendObject:setToolChapter];
    
}


-(void)hideSelf{
    self.hidden = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    self.toolView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, toolbarHeight);
    [UIView commitAnimations];
}
-(void)showSelf{
    self.hidden = NO;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    self.toolView.frame = CGRectMake(0, self.frame.size.height-toolbarHeight, self.frame.size.width, toolbarHeight);
    [UIView commitAnimations];
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
