//
//  StoreClassTableView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14/11/23.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "StoreClassTableView.h"
#import "StoreClassCell.h"
#import "PenSoundDao.h"
#import "ClassData.h"
#import "BlackView.h"
#import "BlockUI.h"
#import "UIView+Blur.h"
@interface StoreClassTableView()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *classArrDic;
@end
@implementation StoreClassTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self blurScreen:YES];
        
        [self inittableView];
        [self loadArray];
        UIView* view = [self viewWithTag:10000];
        UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap)];
        [view addGestureRecognizer:panRecognizer];//关键语句，给self.view添加一个手势监测；
        panRecognizer.numberOfTapsRequired = 1;
        [panRecognizer release];
    }
    return self;
}

-(void)touchTap{
    [self show];
}

-(void)loadArray{
    self.classArrDic = [[PenSoundDao sharedPenSoundDao]selectClassList];
    [self.tableView reloadData];
}

-(void)inittableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-150-1, -CGRectGetHeight(self.frame)-100, 150, CGRectGetHeight(self.frame)-100) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 10;
    //设置那个圆角的有多圆
    _tableView.layer.borderWidth = 0.5;
    //设置边框的宽度，当然可以不要
    _tableView.layer.borderColor = [[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:0.5] CGColor];
    //设置边框的颜色
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:_tableView];
    [self bringSubviewToFront:_tableView];
    //    [_tableView setTableHeaderView:[self initHeadView]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classArrDic count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cate_cell";
    StoreClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[StoreClassCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                     reuseIdentifier:CellIdentifier] autorelease];

        //        [cell setSeparatorInset:UIEdgeInsetsMake(-10, 0, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ClassData *classData = [self.classArrDic objectAtIndex:indexPath.row];
    cell.textLabel.text = classData.cclass_name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassData *classData = [self.classArrDic objectAtIndex:indexPath.row];
    NSLog(@"adfasdfsd");
    [self sendObject:classData.cclass_id];
    [self show];
}


-(void)show{
    if (_tableView.frame.origin.y<0) {
        UIView* view = [self viewWithTag:10000];
        view.hidden = NO;
        [BlackView orgYAnimation:_tableView orgY:0 duration:0.5];
        self.hidden = NO;
    }else{
        UIView* view = [self viewWithTag:10000];
        view.hidden = YES;
//        [BlackView orgYAnimation:_tableView orgY:-CGRectGetHeight(self.frame)-100 duration:0.5];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect detailRect = _tableView.frame;
            detailRect.origin.y = -CGRectGetHeight(self.frame)-100;
            [_tableView setFrame:detailRect];
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    
    
}
-(void)hide{
    
}

@end
