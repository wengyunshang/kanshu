//
//  BookSetView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BookSetView.h"
#import "ResourceHelper.h"
#import "BookSetCell.h"
#import "BlockUI.h"
#import "BlackView.h"
@implementation BookSetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

//        self.layer.cornerRadius = 6;
//        self.layer.masksToBounds = YES;
        self.tableview = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        self.tableview.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.9];
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableview];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BookSetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BookSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg"]];
        [cell receiveObject:^(id object) {
            [self sendObject:object];
        }];
    }
    switch (indexPath.row) {
        case 0:
            [cell getFont];
            break;
        case 1:
            [cell getOrg];
            break;
        case 2:
            [cell getTTF];
            break;
        default:
            break;
    } 
   
    return cell;
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* myView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)] autorelease];
//    //    [myView setClipsToBounds:NO];
//    myView.backgroundColor = [UIColor clearColor];
//    //    myView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"head_bg"]];
//    
//    //    [myView.layer setShadowColor:[UIColor blackColor].CGColor];
//    //    [myView.layer setShadowOpacity:1];
//    //    [myView.layer setShadowRadius:2];
//    //    [myView.layer setShadowOffset:CGSizeMake(0, 0)];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
//    titleLabel.textColor=[UIColor blackColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = NSLocalizedString(@"chapters",nil);
//    [myView addSubview:titleLabel];
//    [titleLabel release];
//    return myView;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    
//    UITableViewCell *cell =[self.chapTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0]];
//    //    NSLog(@"%d----%d",indexPath.row,indexPath.section);
//    [cell setSelected:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChapters" object:indexPath];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)hideSelf{
    //    [self.arrowView rightArrow];
    
    //    [BlackView orgXAnimation:self orgx:UIBounds.size.height duration:0.5];
    [BlackView orgYAnimation:self orgY:UIBounds.size.height duration:0.5];
}
-(void)showSelf{
    //    [self.arrowView leftArrow];
    
    [BlackView orgYAnimation:self orgY:UIBounds.size.height-self.frame.size.height duration:0.5];
}
@end
