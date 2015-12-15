//
//  SetView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-30.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "SetView.h"

@implementation SetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//-(void)showLine{
//    if (!self.lineView) {
//        self.lineView = [[[EvSetingProgressView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
//        [self addSubview:self.lineView];
//    }
//    [self.lineView showLine];
//
//}
//
//-(void)removeLayers{
//    [self.lineView removeLayers];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
