//
//  TabViewController.m
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZYTabViewController.h"
#import "ResourceHelper.h"
#import <QuartzCore/QuartzCore.h> 
#import "UIView+Shadow.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#import "BlockUI.h"
#import "BlackView.h"
#import "StoreViewController.h"
#import "PenSoundDao.h"
#define TABVIEW_HEIGHT 52
@interface UIButton (UIButtonExt)
- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
@end

@implementation UIButton (UIButtonExt)
- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}
@end


@implementation ZYTabViewController

@synthesize viewControllers;
@synthesize contentView;
@synthesize tabView;
@synthesize tabItems;
@synthesize newImageV;
@synthesize selectedBgView;
@synthesize backgroundColor;

-(id) initWithControllers:(NSArray *)controllers tabItems:(NSArray *) items bg:(UIColor *)color{
    self = [super init];
    self.viewControllers = controllers;
    self.tabItems = items;
    self.backgroundColor = color;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabs:) name:@"hideTabs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabs:) name:@"showTabs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashNew) name:@"reflashNew" object:nil];
}

-(void)reflashNew{
    if ([[PenSoundDao sharedPenSoundDao]selectNewBookCount] > 1) {
        self.newImageV.hidden = NO;
    }
}
-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


-(void)build{
    self.contentView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-TABVIEW_HEIGHT)] autorelease];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.autoresizesSubviews =YES;
//    NSLog(@"%f",self.view.frame.size.height);
    self.tabView     = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - TABVIEW_HEIGHT, self.view.frame.size.width, TABVIEW_HEIGHT)];
    
    self.tabView.backgroundColor = [UIColor whiteColor];
//    self.tabView.layer.cornerRadius = 26;
//    self.tabView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123123.png"]];
    //    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:headView.bounds].CGPath;
//    self.tabView.layer.shadowOffset = CGSizeMake(0, -0);
//    self.tabView.layer.shadowRadius = 1;
//    self.tabView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.tabView.layer.shadowOpacity = 0.6;
    
    
    float buttonWidth = self.tabView.frame.size.width/self.tabItems.count;
    CGSize buttonSize = CGSizeMake(buttonWidth, TABVIEW_HEIGHT);
    
    
    self.lineView = [[[UIView alloc]initWithFrame:CGRectMake(1, 3, buttonWidth, self.tabView.frame.size.height-4)] autorelease];
    self.lineView.backgroundColor = [UIColor orangeColor];
    self.lineView.layer.cornerRadius = 24;
    self.lineView.layer.shadowOffset = CGSizeMake(0, 0);
    self.lineView.layer.shadowRadius = 1.5;
    
    self.lineView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lineView.layer.shadowOpacity = 0.2;
    [self.tabView addSubview:self.lineView];
    for(int i=0;i<self.tabItems.count;i++){
        float x = i*buttonWidth;
        NSDictionary *tabItem = [tabItems objectAtIndex:i];
//        NSString *text = [tabItem objectForKey:@"text"];
        NSString *imageNameNormal = [tabItem objectForKey:@"imageNormal"];
        NSString *imageNameSelected = [tabItem objectForKey:@"imageSelected"];
        NSString *titlete = [tabItem objectForKey:@"text"];
        UIColor *selectColor = [tabItem objectForKey:@"selectColor"];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, buttonSize.width,TABVIEW_HEIGHT)];
        UIImage *imageNormal   = [ResourceHelper loadImageByTheme:imageNameNormal];
        UIImage *imageSelected = [ResourceHelper loadImageByTheme:imageNameSelected];
        
        btn.tag = i;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:imageNormal forState:UIControlStateNormal];
        [btn setImage:imageSelected forState:UIControlStateHighlighted];
        [btn setImage:imageSelected forState:UIControlStateSelected];
        [btn setTitle:titlete forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];;
        
        [btn setTitleColor:WXXCOLOR(0, 0, 0, 0.87) forState:UIControlStateNormal];
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(multipleTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [btn addTarget:self action:@selector(multipleTap:withEvent:) forControlEvents:UIControlEventTouchDown];
        [btn centerImageAndTitle:5];
        [self.tabView addSubview:btn];
        
        
        
        if (i ==1) {
            
                UIImage *newimg = [ResourceHelper loadImageByTheme:@"new-icon2"];
                self.newImageV = [[[UIImageView alloc]initWithFrame:CGRectMake(78,2, newimg.size.width-8, newimg.size.height-8)] autorelease];
                self.newImageV.image = newimg;
                [btn addSubview:self.newImageV];
            self.newImageV.hidden = YES;
//            WxxLabel *nameLb = [[[WxxLabel alloc]initWithFrame:
//                                 CGRectMake(0,0,30,30) font:fontTTFToSize(15)] autorelease];
//            
//            nameLb.text = [NSString stringWithFormat:@".%d",[[PenSoundDao sharedPenSoundDao]selectNewBookCount]];
//            nameLb.backgroundColor = [UIColor clearColor];
//            [newImageV addSubview:nameLb];
        }
        [btn release];
    }
    
    
    
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabView.frame), 1)];
//    [topLine makeInsetShadowWithRadius:5.0 Alpha:0.8];
    [topLine makeInsetShadowWithRadius:1.0 Color:[UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:0.7] Directions:[NSArray arrayWithObjects:@"top", nil]];
    [self.tabView insertSubview:topLine belowSubview:self.lineView];
    [topLine release];
//
//    UIView *milLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.tabView.frame)/3, 0, 2, CGRectGetHeight(self.tabView.frame))];
//    //    [topLine makeInsetShadowWithRadius:5.0 Alpha:0.8];
//    [milLine makeInsetShadowWithRadius:1.0 Color:[UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1] Directions:[NSArray arrayWithObjects:@"left", nil]];
//    [self.tabView addSubview:milLine];
//    [milLine release];
//    
//    UIView *milLine2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.tabView.frame)/3*2, 0, 2, CGRectGetHeight(self.tabView.frame))];
//    //    [topLine makeInsetShadowWithRadius:5.0 Alpha:0.8];
//    [milLine2 makeInsetShadowWithRadius:1.0 Color:[UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1] Directions:[NSArray arrayWithObjects:@"left", nil]];
//    [self.tabView addSubview:milLine2];
//    [milLine2 release];
    
    
    [self.view addSubview:contentView];
    [self.view addSubview:tabView];
    
    UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 2, buttonSize.width, buttonSize.height-2)] autorelease];
    UIImageView *ind = [[UIImageView alloc] initWithImage:[ResourceHelper loadImageByTheme:@"tabind"]];
    ind.frame = CGRectMake((buttonSize.width-7)/2, 0, 7, 7);
    [bgView addSubview:ind];
    bgView.backgroundColor = [[[UIColor alloc] initWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1] autorelease];
    self.selectedBgView = bgView;
    UIView *tabViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabView.frame.size.width, 2)];
    tabViewHeader.backgroundColor = [[[UIColor alloc] initWithRed:251/255.f green:144/255.f blue:44/255.f alpha:1] autorelease];
    [self.tabView insertSubview:tabViewHeader atIndex:0];
    [self.tabView insertSubview:bgView atIndex:1];
    
    tabViewHeader.hidden = YES;
    bgView.hidden = YES;
    [tabViewHeader release];
    
    [contentView release];
    [tabView release];
    
    for(UIViewController *vc in viewControllers){
        vc.view.frame = contentView.bounds;
    }
    
    [self selectTab:0];

}
-(void)selectTab:(int)index{
    [self tabButtonPressed:[self.tabView.subviews objectAtIndex:(index+4)]];
}

-(void)tabButtonPressed:(id)sender{
  
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [BlackView alphaAnimationTo0:self.newImageV duration:0.8];
    }
    
    for(UIView *b in tabView.subviews){
        if([b isMemberOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)b;
            button.selected = NO;
        }
    }
    int index = btn.tag;
    
    btn.selected = YES;
    
    int buttonWidth = self.tabView.frame.size.width/self.tabItems.count;
    int x= index*buttonWidth;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	CGRect rect = [self.selectedBgView frame];
	rect.origin.x = x;
	[self.selectedBgView setFrame:rect];
	[UIView commitAnimations];
    
    if(self.contentView.subviews.count > 0)
       [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
    
    if([viewControllers objectAtIndex:index]!=nil){
	    [self.contentView addSubview:[[viewControllers objectAtIndex:index] view]];
        [[viewControllers objectAtIndex:index] viewWillAppear:YES];
    }
}



-(IBAction)multipleTap:(id)sender withEvent:(UIEvent*)event {
    
    
    UITouch* touch = [[event allTouches] anyObject];
    
    if (touch.tapCount == 2) {
        UIButton *btn = (UIButton *)sender;
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             CGRect rect = self.lineView.frame;
//                             rect.origin.x = btn.frame.origin.x;
//                             if (rect.origin.x <=0) {
//                                 rect.origin.x = 5;
//                             }else if(rect.origin.x <= UIBounds.size.width/3){
//                                 rect.origin.x = rect.origin.x -5;
//                             }
//                             self.lineView.frame = rect;
//                         }
//                         completion:^(BOOL finished){
//                         }];
        if (btn.tag == 1) {
            int index = btn.tag;
            if([viewControllers objectAtIndex:index]!=nil){
                
//                UINavigationController *svc = (UINavigationController*)[viewControllers objectAtIndex:index];
//                StoreViewController *sttt = (StoreViewController*)[svc.childViewControllers objectAtIndex:0];
//                [sttt loadBOOOK];
            }
        }
        
    }
    if (touch.tapCount == 1) {
        UIButton *btn = (UIButton *)sender;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect rect = self.lineView.frame;
                             rect.origin.x = btn.frame.origin.x;
                             if (rect.origin.x <=0) {
                                 rect.origin.x = 1;
                             }else if(rect.origin.x >= UIBounds.size.width/3){
                                 rect.origin.x = rect.origin.x -1;
                             }
                             self.lineView.frame = rect;
                         }
                         completion:^(BOOL finished){
                         }];
        if (btn.tag == 1) {
            [BlackView alphaAnimationTo0:self.newImageV duration:0.8];
        }
        
        for(UIView *b in tabView.subviews){
            if([b isMemberOfClass:[UIButton class]]){
                UIButton *button = (UIButton *)b;
                button.selected = NO;
//                button.alpha = 0.7;
            }
        }
        int index = btn.tag;
        btn.selected = YES;
//        btn.alpha = 1;
        int buttonWidth = self.tabView.frame.size.width/self.tabItems.count;
        int x= index*buttonWidth;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2];
        CGRect rect = [self.selectedBgView frame];
        rect.origin.x = x;
        [self.selectedBgView setFrame:rect];
        [UIView commitAnimations];
        
        if(self.contentView.subviews.count > 0)
            [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
        
        if([viewControllers objectAtIndex:index]!=nil){
            [self.contentView addSubview:[[viewControllers objectAtIndex:index] view]];
            [[viewControllers objectAtIndex:index] viewWillAppear:YES];
        }
    }
    
}

-(void)hideTabs:(NSNotification *)notification{
    if(!tabView.hidden){
        CATransition *transition = [CATransition animation]; 
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self; 
        [self.tabView.layer addAnimation:transition forKey:nil]; 
        tabView.hidden = YES;
    }
}
       
-(void)showTabs:(NSNotification *)notification{
    if(tabView.hidden){
        CATransition *transition = [CATransition animation]; 
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip" 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self; 
        [self.tabView.layer addAnimation:transition forKey:nil]; 
        tabView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"tab will appear");
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return NO;
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
//    return UIInterfaceOrientationIsLandscape( interfaceOrientation ); // 横屏
    
    return UIInterfaceOrientationIsPortrait( interfaceOrientation ); // 竖屏
    
}
#pragma mark -
#pragma mark Store Product View Controller Delegate Methods
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [super dealloc];
	[contentView release];
	[tabView release];
    [newImageV release];
    [viewControllers release];
    [tabItems release];
    [selectedBgView release];
    [backgroundColor release];
}


@end
