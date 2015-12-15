//
//  StoreTableViewCell.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14/10/28.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "StoreLoadTableViewCell.h"
#import "ResourceHelper.h"
@implementation StoreLoadTableViewCell

-(void)dealloc{
    [_loadBtn release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.ynLoadnew = NO;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 15, UIBounds.size.width-20, 38)];
        view.layer.cornerRadius = 3;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowRadius = 1;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.2;
        [self.contentView addSubview:view];
        
        self.loadBtn = [[[WxxButton alloc]initWithPoint:CGPointMake(10, 15) image:nil selectImg:nil str:@"加载下20条" width:UIBounds.size.width-20 height:38]autorelease];
        [self.loadBtn setTitleColor:WXXCOLOR(0, 0, 0, 0.54) forState:UIControlStateHighlighted];
        [self.contentView addSubview:self.loadBtn];
        [self.loadBtn receiveObject:^(id object) {
            if (self.ynLoadnew) {
                [self sendObject:@"1"];
            }else{
                [self sendObject:@"0"];
            }

        }];
//         @2x
        
    }
    return self;
}

-(void)setBtnTextToLoaded{
    self.ynLoadnew = YES;
    self.loadBtn.hidden = YES;
    self.contentView.alpha = 0;
    [self.loadBtn setTitle:@"到底部－点击刷新" forState:UIControlStateNormal];
}

-(void)setBtnTextTonext{
    self.ynLoadnew = NO;
    self.loadBtn.hidden = NO;
    self.contentView.alpha = 1;
    [self.loadBtn setTitle:@"加载下20条" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
