//
//  WxxTableView.m
//  epub
//
//  Created by weng xiangxun on 14-3-28.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxTableView.h"
#import "BlockUI.h"
@implementation WxxTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadData {

    NSLog(@"BEGIN reloadData");

    [super reloadData];
    [self sendObject:nil];
    NSLog(@"END reloadData");

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
