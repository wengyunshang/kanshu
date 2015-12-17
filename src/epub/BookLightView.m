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
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.98];
        
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
    float alp = 0.4;
    EvRoundProgressView *evrp = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(orgx,orgy,btnLength, btnLength)
                                                            progressColor:gragcolor
                                                                backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_green"]]];
    [self addSubview:evrp];
    
    //setSelectNight
    EvRoundProgressView *evrp1 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_night"]]];
    [self addSubview:evrp1];
    
    EvRoundProgressView *evrp2 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp1.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_sepia"]]];
    [self addSubview:evrp2];
    //    淡白
    EvRoundProgressView *evrp4 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp2.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background"]]];
    [self addSubview:evrp4];
    
    EvRoundProgressView *evrp5 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp4.frame)+5,orgy,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor whiteColor]];
    [self addSubview:evrp5];
    
    [evrp receiveObject:^(id object) {
        evrp.alpha = 1;
        
        evrp1.alpha = alp;
        evrp2.alpha = alp;
        evrp4.alpha = alp;
        evrp5.alpha = alp;
        //        NSLog(@"黑色");
        [self sendObject:setSelectVirescence];
    }];
    [evrp1 receiveObject:^(id object) {
        evrp.alpha = alp;
        evrp1.alpha = 1;
        evrp2.alpha = alp;
        evrp4.alpha = alp;
        evrp5.alpha = alp;
        //        NSLog(@"点击色彩");
        [self sendObject:setSelectNight];
    }];
    [evrp2 receiveObject:^(id object) {
        evrp.alpha = alp;
        evrp1.alpha = alp;
        evrp2.alpha = 1;
        evrp4.alpha = alp;
        evrp5.alpha = alp;
        [self sendObject:setSelectSepia];
    }];
    [evrp4 receiveObject:^(id object) {
        evrp.alpha = alp;
        evrp1.alpha = alp;
        evrp2.alpha = alp;
        evrp4.alpha = 1;
        evrp5.alpha = alp;
        [self sendObject:setSelectgrayWhite];
    }];
    [evrp5 receiveObject:^(id object) {
        evrp.alpha = alp;
        evrp1.alpha = alp;
        evrp2.alpha = alp;
        evrp4.alpha = alp;
        evrp5.alpha = 1;
        //        NSLog(@"点击色彩");
        [self sendObject:setSelectWhite];
    }];
    
    evrp.alpha = alp;
    evrp1.alpha = alp;
    evrp2.alpha = alp;
    evrp4.alpha = alp;
    evrp5.alpha = alp;
    [evrp release];
    [evrp1 release];
    [evrp2 release];
    //
    [evrp4 release];
    [evrp5 release];
    
//    evrp.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    
    NSString * type = [[NSUserDefaults standardUserDefaults] objectForKey:selectTypeKey];
    
    switch ([type integerValue]) {
        case setSelectVirescence:
            evrp.alpha = 1;
            break;
        case setSelectNight:
            evrp1.alpha = 1;
            break;
        case setSelectSepia:
            evrp2.alpha = 1;
            break;
        case setSelectgrayWhite:
            evrp4.alpha = 1;
            break;
        case setSelectWhite:
            evrp5.alpha = 1;
            break;
        default:
            break;
    }
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
