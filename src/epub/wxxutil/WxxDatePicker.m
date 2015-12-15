//
//  WxxDatePicker.m
//  driftbottle
//
//  Created by weng xiangxun on 13-8-9.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "WxxDatePicker.h"

@implementation WxxDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor blackColor];
//        [self initToolbar];
//        [self initDatePicker];
//        frame.size.height = 40+self.datePickerView.frame.size.height;
//        frame.size.width = UIBounds.size.width;
//        frame.origin.y = UIBounds.size.height - frame.size.height;
//        self.frame = frame;
        
    }
    return self;
}

-(void)initToolbar{
    
    CGFloat width =  self.frame.size.width;
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    toolBar.barStyle = UIBarButtonItemStyleBordered;
    [toolBar sizeToFit];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;//这句作用是切换时宽度自适应.
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonPress:)];
    [toolBar setItems:[NSArray arrayWithObject:barItem]];
    [self addSubview:toolBar];
    [toolBar release];
}
-(void)initDatePicker:(UIView *)view{
    
    self.datePickerView = [[[UIDatePicker alloc] initWithFrame: CGRectZero] autorelease];
    self.datePickerView.backgroundColor = [UIColor whiteColor];
	self.datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	self.datePickerView.datePickerMode = UIDatePickerModeDate;
    self.datePickerView.frame = CGRectMake(0, UIBounds.size.height - self.datePickerView.frame.size.height,
                                           self.datePickerView.frame.size.width,
                                           self.datePickerView.frame.size.height);
	[view addSubview:self.datePickerView];
}

-(void)showDatePicker{
    
    
}

-(void)cancelDatePicker{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [_datePickerView release];
    [super dealloc];
}

@end
