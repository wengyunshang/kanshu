//
//  HttpServerViewController.m
//  epub
//
//  Created by zhiyu on 13-6-4.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "HttpServerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ResourceHelper.h"
#import "BlackView.h"
@interface HttpServerViewController ()
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UILabel *openLb;
@property (nonatomic,strong)UILabel *tipLb;
@end

@implementation HttpServerViewController
@synthesize backView;
@synthesize httpServer;
@synthesize text;
@synthesize url;
@synthesize wifi;

#define PORT 8000

- (void)dealloc {
    self.closeBtn = nil;
    self.openLb = nil;
    self.tipLb = nil;
    [httpServer release];
    [backView release];
    [wifi release];
    [text release];
    [url release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.hidden = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    
    UIButton *stop = [[UIButton alloc] initWithFrame:CGRectMake(120, self.view.bounds.size.height/2+140, 80, 80)];
    [stop setImage:[ResourceHelper loadImageByTheme:@"close_wifi"] forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
    [stop release];
    
    float height = 300;
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, UIBounds.size.height, UIBounds.size.width, height)];
    [backView release];
    self.backView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9];
    [self.view addSubview:self.backView];
    
    self.openLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 20)];
    [self.openLb release];
    [self.openLb setTextAlignment:NSTextAlignmentCenter];
    self.openLb.font = [UIFont systemFontOfSize:15];
    [self.openLb setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    [self.backView addSubview:self.openLb];
    
    self.tipLb = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.openLb.frame)+10, self.view.frame.size.width, 20)];
    [self.tipLb release];
    [self.tipLb setTextAlignment:NSTextAlignmentCenter];
    self.tipLb.font = [UIFont systemFontOfSize:13];
    [self.tipLb setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    self.tipLb.text = @"上传过程中请勿离开本界面或锁屏";
    [self.backView addSubview:self.tipLb];
    
    self.wifi = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-79)/2, CGRectGetMaxY(self.tipLb.frame)+20, 79, 56)];
    [wifi release];
    [wifi setImage:[ResourceHelper loadImageByTheme:@"v3_sj_wifi_off"] forState:UIControlStateNormal];
    [wifi setImage:[ResourceHelper loadImageByTheme:@"v3_sj_wifi"] forState:UIControlStateHighlighted];
    [wifi setUserInteractionEnabled:NO];
    
    self.text = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wifi.frame)+30, self.view.frame.size.width, 20)];
    [text release];
    [text setTextAlignment:NSTextAlignmentCenter];
    text.font = [UIFont systemFontOfSize:14];
    [text setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    
    self.url = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.text.frame)+10, self.view.frame.size.width, 20)];
    [url release];
    [url setTextAlignment:NSTextAlignmentCenter];
    
    
    [self.backView addSubview:text];
    [self.backView addSubview:url];
    [self.backView addSubview:wifi];
    
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(self.backView.frame)-50, UIBounds.size.width-10, 45)];
    self.closeBtn.backgroundColor = [UIColor blackColor];
    self.closeBtn.layer.cornerRadius = 4;
    self.closeBtn.layer.masksToBounds = YES;
    [self.closeBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.closeBtn];
    
}

-(void)switchAction:(id)sender
{
    UISwitch *s = (UISwitch*)sender;
    BOOL isButtonOn = [s isOn];
    if(isButtonOn){
        [self startServer];
    }else{
        [self stopServer];
    }
}

-(void)closeSelf{
    
    __block CGRect backrect = self.backView.frame;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         backrect.origin.y = UIBounds.size.height;
                         [self.backView setFrame:backrect];
                     }
                     completion:^(BOOL finished){
                         self.view.hidden = YES;
                     }];
}

-(void) startServer{
    [wifi setHighlighted:YES];
    self.view.hidden = NO;
     __block CGRect backrect = self.backView.frame;
    [UIView animateWithDuration:0.5
                     animations:^{

                         backrect.origin.y = UIBounds.size.height - backrect.size.height;
                         [self.backView setFrame:backrect];
                     }
                     completion:^(BOOL finished){
//                         [UIView animateWithDuration:1.0
//                                          animations:^{
//                                              CGRect detailRect = v.frame;
//                                              detailRect.origin.x = orgx2;
//                                              [v setFrame:detailRect];
//                                          }
//                                          completion:^(BOOL finished){
//                                              ;
//                                          }];
                     }];
//    [UIView beginAnimations:@"animationID" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
//    self.view.hidden = NO;
//    [UIView commitAnimations];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ip = [GetAddress localWiFiIPAddress];
    
    if(ip == NULL){
        text.text = NSLocalizedString(@"server_network_err", nil);
        url.text = @"";
        [wifi setHighlighted:NO];
        return;
    }
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    self.httpServer = [[HTTPServer alloc] init];
    [httpServer release];
    
    [httpServer setType:@"_http._tcp."];
    [httpServer setPort:PORT];
    
    [httpServer setDocumentRoot:documentsDirectory];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    NSError *error = nil;
    if(![httpServer start:&error])
    {
        self.openLb.text = @"WiFi连接失败";
        url.textColor = [UIColor grayColor];
        self.openLb.textColor = [UIColor redColor];
        text.text = NSLocalizedString(@"server_server_err", nil);
        [wifi setHighlighted:NO];
    }else{
        url.textColor = [UIColor colorWithRed:16/255.0 green:168/255.0 blue:248/255.0 alpha:1];
        self.openLb.text = @"WiFi已成功连接";
        self.openLb.textColor = [UIColor colorWithRed:16/255.0 green:168/255.0 blue:248/255.0 alpha:1];
        text.text = NSLocalizedString(@"server_upload_info", nil);
        url.text = [NSString stringWithFormat:@"http://%@:%d",ip,PORT];
    }
}

-(void)stopServer{
    [httpServer stop:NO];
    [wifi setHighlighted:NO];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    self.view.hidden = YES;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
