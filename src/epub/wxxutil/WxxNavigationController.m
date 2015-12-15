//
//  WxxNavigationController.m
//  driftbottle
//
//  Created by weng xiangxun on 13-8-12.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxNavigationController.h"

@interface WxxNavigationController ()

@end


@implementation UINavigationController(wxxNavigationController)
-(void)setNewSSs{
    NSLog(@"aaaaaaaaaaaa");
}
//设置navigationitem的右边按钮
-(void)setRightNavBarBtnWithTitle:(NSString*)title action:(SEL)action backImg:(NSString*)img{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:action];//初始化
    [temporaryBarButtonItem setBackgroundImage:[UIImage imageNamed:img]
                                      forState:UIControlStateNormal
                                    barMetrics:UIBarMetricsDefault];//图片
    self.navigationController.navigationItem.rightBarButtonItem = temporaryBarButtonItem;//右边按钮
    self.navigationController.title = @"标题";
    [temporaryBarButtonItem release];
}
//设置navigationitem的左边按钮
-(void)setLeftNavBarBtnWithTitle:(NSString*)title action:(SEL)action backImg:(NSString*)img{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:action];//初始化
    [temporaryBarButtonItem setBackgroundImage:[UIImage imageNamed:img]
                                      forState:UIControlStateNormal
                                    barMetrics:UIBarMetricsDefault];//图片
    
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;//右边按钮
    [temporaryBarButtonItem release];
}

@end

@implementation WxxNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_bg_black/header_bg"] forBarMetrics:UIBarMetricsDefault];
//        self.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_bg_black/header_bg"] forBarMetrics:UIBarMetricsDefault];
        //        self.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

-(void)addNewView:(UIView*)vvview{
    [self.navigationController.view addSubview:vvview];
}
-(UIView*)getNavigationView{
    return self.navigationController.view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
