//
//  ChapterListView.m
//  epub
//
//  Created by weng xiangxun on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ChapterListView.h"
#import "WxxButton.h"
#import "BlackView.h"
#import "WxxImageView.h"
#import "ArrowView.h"
#import "BlockUI.h"
#import "ResourceHelper.h"
#import "StoreTableVeiwCell.h"
#import "BookViewController.h"
#import "WxxTableView.h"
#import "ResourceHelper.h"
#import "HistoryData.h"
@interface ChapterListView()
//@property (nonatomic,retain)ArrowView *arrowView;
@property (nonatomic,retain)UIButton *backBtn;
-(void)hideSelf;
-(void)showSelf;
@end
@implementation ChapterListView
@synthesize bookViewController;
-(void)dealloc{
//    [_arrowView release];
//    _arrowView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        [self initTouch];
//        [self initArrowView];
        [self initTableView];
       
        float btnWidth = 80;
        self.backBtn = [[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-btnWidth)/2, (self.frame.size.height-btnWidth/2-5), btnWidth, btnWidth)] autorelease];
        self.backBtn.layer.cornerRadius = btnWidth/2;
        self.backBtn.layer.masksToBounds = YES;
        self.backBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        [self addSubview:self.backBtn];
        [self.backBtn addTarget:self action:@selector(hideChapter) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *img = [ResourceHelper loadImageByTheme:@"v3_sc_arrow_back"];
        UIImageView *arrowImgv = [[[UIImageView alloc]initWithFrame:CGRectMake((_backBtn.frame.size.width-img.size.width)/2, (_backBtn.frame.size.height-img.size.height)/2-6, img.size.width, img.size.height)] autorelease];
        arrowImgv.image = img;
        [self.backBtn addSubview:arrowImgv];
        CGAffineTransform rotate = CGAffineTransformMakeRotation( 270.0 / 180.0 * 3.14 );
        [arrowImgv setTransform:rotate];
 
        
        UIImageView *arrowImgv2 = [[[UIImageView alloc]initWithFrame:CGRectMake((_backBtn.frame.size.width-img.size.width)/2, (_backBtn.frame.size.height-img.size.height)/2-16, img.size.width, img.size.height)] autorelease];
        arrowImgv2.image = img;
        [self.backBtn addSubview:arrowImgv2];
        CGAffineTransform rotate2 = CGAffineTransformMakeRotation( 270.0 / 180.0 * 3.14 );
        [arrowImgv2 setTransform:rotate2];
    }
    return self;
}


//************************touch*******************
-(void)initTouch{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
}

/* 识别侧滑 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
//	[self drawImageForGestureRecognizer:gestureRecognizer atPoint:location underAdditionalSituation:nil];
    
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self hideSelf];
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        location.x -= 220.0;
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        location.x -= 220.0;
    }
    else{
        [self showSelf];
    }
    
//	[UIView animateWithDuration:0.5 animations:^{
////        self.imageView.alpha = 0.0;
////        self.imageView.center = location;
//    }];
}
//************************箭头*******************
//-(void)initArrowView{
//    self.arrowView = [[[ArrowView alloc]initWithParent:CGRectGetWidth(self.frame) height:CGRectGetHeight(self.frame)] autorelease];
//
//    [self addSubview:self.arrowView];
//    [self.arrowView receiveObject:^(id object) {
//        if (CGRectGetMinX(self.frame)<0) {
//            [self showSelf];
//            
//        }else{
//            [self hideSelf];
//            
//        }
//    }];
//}
-(void)hideSelf{
//    [self.arrowView rightArrow];
    NSLog(@"%f",CGRectGetMinX(self.frame));
//    [BlackView orgXAnimation:self orgx:UIBounds.size.height duration:0.5];
    [BlackView orgYAnimation:self orgY:UIBounds.size.height duration:0.5];
}
-(void)showSelf{
//    [self.arrowView leftArrow];
    [self loadChapters];
    [BlackView orgYAnimation:self orgY:UIBounds.size.height-self.frame.size.height duration:0.5];
}
-(void)hideChapter{
//    [BlackView orgXAnimation:self orgx:-CGRectGetWidth(self.frame) duration:0.5];
  [BlackView orgYAnimation:self orgY:UIBounds.size.height duration:0.5];
//    [BlackView orgYAnimation:self orgY:UIBounds.size.height-self.frame.size.height duration:0.5];
}
-(void)showChapter{
//    [self.arrowView rightArrow];
    [self.chapTableView reloadData];
    [self initReadCell];
    [BlackView orgYAnimation:self orgY:UIBounds.size.height-self.frame.size.height duration:0.5];
//    [BlackView orgXAnimation:self orgx:-CGRectGetWidth(self.frame)+CGRectGetWidth(self.arrowView.frame) duration:0.5];
}
-(void)loadChapters{
    
    [self.chapTableView reloadData];

}

//- (void)reloadData {
//    
//    NSLog(@"BEGIN reloadData");
//    
//    [super reloadData];
//    
//    NSLog(@"END reloadData");
//    
//}
-(void)initReadCell{
    if (!bookViewController.bookLoader) {
        return;
    }
    HistoryData *hisData = bookViewController.historyData;
//    NSMutableDictionary *last = (NSMutableDictionary *)[ResourceHelper getUserDefaults:bookViewController.bookLoader.filePath];
    if(hisData!=nil){
//        int currentSpineIndex = [[last objectForKey:@"currentSpineIndex"] intValue];
        
        [self.chapTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[hisData.hcurrentSpineIndex intValue] inSection:0]
                              atScrollPosition:UITableViewScrollPositionMiddle animated: NO];
        
//        currentPageInSpineIndex = [[last objectForKey:@"currentPageInSpineIndex"] intValue];
    }
}



-(void)initTableView{
    
    self.chapTableView = [[[WxxTableView alloc]initWithFrame:CGRectMake(0,0.4,
                                                                        CGRectGetWidth(self.frame),
                                                                        CGRectGetHeight(self.frame)-0.8)] autorelease];
    self.chapTableView.dataSource = self;
//    self.chapTableView.layer.borderColor = [[UIColor colorWithRed:31/255.0 green:131/255.0 blue:211/255.0 alpha:1.0] CGColor];
    self.chapTableView.delegate = self;
//    self.chapTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_pane_bg.png"]];
//    self.chapTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.chapTableView.layer setBorderColor:[[UIColor colorWithRed:120/255.f green:123/255.f blue:118/255.f alpha:1] CGColor]];
//    [self.chapTableView.layer setBorderWidth:0.4f];
//    self.chapTableView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.chapTableView];
    [self.chapTableView receiveObject:^(id object) {
        
        [self initReadCell];
    }];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        [self.chapTableView setContentInset:UIEdgeInsetsMake(20, self.chapTableView.contentInset.left, self.chapTableView.contentInset.bottom, self.chapTableView.contentInset.right)];
//    }
    
}

//-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
//    
//    [cell setBackgroundColor:[UIColor clearColor]];
//
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [bookViewController.bookLoader.spineArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg"]];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
        cell.textLabel.highlightedTextColor=[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        
        //        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        //        [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
        //
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = backView;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]];
        [backView release];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    HistoryData *hisData = bookViewController.historyData;
    //    NSMutableDictionary *last = (NSMutableDictionary *)[ResourceHelper getUserDefaults:bookViewController.bookLoader.filePath];
    cell.textLabel.text = [[bookViewController.bookLoader.spineArray objectAtIndex:[indexPath row]] title];
    if(hisData!=nil){
    
        int currentSpineIndex = [hisData.hcurrentSpineIndex intValue];
        if (indexPath.row == currentSpineIndex) {
            [self.chapTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            cell.textLabel.textColor = [UIColor redColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}


//去掉UItableview headerview黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)] autorelease];
//    [myView setClipsToBounds:NO];
//    myView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
//    myView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"head_bg"]];
    myView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
    //    [myView.layer setShadowColor:[UIColor blackColor].CGColor];
    //    [myView.layer setShadowOpacity:1];
    //    [myView.layer setShadowRadius:2];
    //    [myView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"chapters",nil);
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self.chapTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0]];
//    NSLog(@"%d----%d",indexPath.row,indexPath.section);
    [cell setSelected:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChapters" object:indexPath];
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












