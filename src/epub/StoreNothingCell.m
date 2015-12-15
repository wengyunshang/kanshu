//
//  StoreNothingCell.m
//  PandaBook
//
//  Created by weng xiangxun on 15/3/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "StoreNothingCell.h"

@implementation StoreNothingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, UIBounds.size.width-10, 105)];
        view.layer.cornerRadius = 3;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowRadius = 1;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.2;
        [self.contentView addSubview:view];
        [view release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
