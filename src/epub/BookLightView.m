//
//  BookLightView.m
//  PandaBook
//
//  Created by linxiaolong on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "BookLightView.h"
#import "BlackView.h"
#import "EvRoundProgressView.h"
#import "ResourceHelper.h"
#import "BlockUI.h"
#define slideHeight 50
#define btnLength 40
@implementation BookLightView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.9];
        
        //        self.layer.cornerRadius = 6;
        //        self.layer.masksToBounds = YES;
        [self getLight];
        [self getColorBtn];
    }
    return self;
}

//亮度
-(void)getLight{
    
    UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(30, 0, self.frame.size.width-60, slideHeight)];
    [self addSubview:slide];
    [slide addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slide release];
}

-(void)getColorBtn{
    
    float orgx = 30;
    float orgy = slideHeight;
    UIColor *gragcolor = [UIColor grayColor];
    
    EvRoundProgressView *evrp = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(orgx,orgy,btnLength, btnLength)
                                                            progressColor:gragcolor
                                                                backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_green"]]];
    [self addSubview:evrp];
    [evrp receiveObject:^(id object) {
        //        NSLog(@"黑色");
        [self sendObject:[NSNumber numberWithInt: setSelectVirescence]];
    }];
    
    //setSelectNight
    EvRoundProgressView *evrp1 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_night"]]];
    [self addSubview:evrp1];
    [evrp1 receiveObject:^(id object) {
        //        NSLog(@"点击色彩");
        [self sendObject:[NSNumber numberWithInt: setSelectNight]];
    }];
    
    
    EvRoundProgressView *evrp2 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp1.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_sepia"]]];
    [self addSubview:evrp2];
    [evrp2 receiveObject:^(id object) {
        [self sendObject:[NSNumber numberWithInt: setSelectSepia]];
    }];
    
    //    淡白
    EvRoundProgressView *evrp4 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp2.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background"]]];
    [self addSubview:evrp4];
    [evrp4 receiveObject:^(id object) {
        [self sendObject:[NSNumber numberWithInt: setSelectgrayWhite]];
    }];
    
    
    EvRoundProgressView *evrp5 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp4.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor whiteColor]];
    [self addSubview:evrp5];
    [evrp5 receiveObject:^(id object) {
        //        NSLog(@"点击色彩");
        [self sendObject:[NSNumber numberWithInt: setSelectWhite]];
    }];
    
    
    [evrp release];
    [evrp1 release];
    [evrp2 release];
    //
    [evrp4 release];
    [evrp5 release];
}

-(void)sliderValueChanged:(UISlider* )slider {
    //    NSLog(@"Slider value=%f", slider.value);
    [[UIScreen mainScreen] setBrightness:slider.value];
}

-(void)hideSelf{
    //    [self.arrowView rightArrow];
    
    //    [BlackView orgXAnimation:self orgx:UIBounds.size.height duration:0.5];
    [BlackView orgYAnimation:self orgY:UIBounds.size.height duration:0.5];
}
-(void)showSelf{
    //    [self.arrowView leftArrow];
    
    [BlackView orgYAnimation:self orgY:UIBounds.size.height-self.frame.size.height duration:0.5];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
