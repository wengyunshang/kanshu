//
//  AboutViewController.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-2.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "AboutViewController.h"
#import "ResourceHelper.h"
#import "AppDelegate.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize interstitial = interstitial_;

- (void)dealloc {
    if (interstitial_) {
        interstitial_.delegate = nil;
        [interstitial_ release];
    }
   
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        self.view.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(58, 50, 160, 160)];
        view.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"logobg"]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 210, 160, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
        label.text = [NSString stringWithFormat:@"%@%@",@"Version: ",(NSString *)[[[NSBundle mainBundle] infoDictionary] valueForKey:kCFBundleVersionKey]];
        
        UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(60, 250, 210, 200)];
        txtView.text = @"商务合作： wengxianxun@hotmail.com";
        txtView.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:txtView];
        [self.view addSubview:view];
        [self.view addSubview:label];
        
        [txtView release];
        [view release];
        [label release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (booktype==BTjinyong) {
//        [self showInterstitial:nil];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    // Alert the error.
    UIAlertView *alert = [[[UIAlertView alloc]
                           initWithTitle:@"GADRequestError"
                           message:[error localizedDescription]
                           delegate:nil cancelButtonTitle:@"Drat"
                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}


- (IBAction)showInterstitial:(id)sender {
   
    self.interstitial = [[[GADInterstitial alloc] init] autorelease];
    self.interstitial.delegate = self;
    
    // Note: Edit InterstitialExampleAppDelegate.m to update
    // INTERSTITIAL_AD_UNIT_ID with your interstitial ad unit id.
    AppDelegate *appDelegate =
    (AppDelegate *)
    [UIApplication sharedApplication].delegate;
    self.interstitial.adUnitID = appDelegate.interstitialAdUnitID;
    
    [self.interstitial loadRequest: [appDelegate createRequest]];
  
}

- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     nil];
    return request;
}
@end
