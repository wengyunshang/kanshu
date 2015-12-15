//
//  BookSetCell.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-11.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BookSetCell.h"
#import "BlockUI.h"
#import "EvRoundProgressView.h"
#import "ResourceHelper.h"
#import "ResourceHelper.h"
#import "WxxLabel.h"
#import "WxxButton.h"
#define btnLength 40
#define cellHeight 60


@interface BookSetCell()
@property (nonatomic,retain)WxxLabel *titleLabel;
@end

@implementation BookSetCell

-(void)dealloc{
    [_titleLabel release];
    _titleLabel = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        if (!self.titleLabel) {
            self.titleLabel = [[[WxxLabel alloc]initWithFrame:CGRectMake(13, 0, 60, cellHeight) font:[UIFont systemFontOfSize:14]] autorelease];
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.text = @"ZITI";
            self.titleLabel.alpha = 0.8;
            [self.contentView addSubview:self.titleLabel];
        }
    }
    return self;
}

-(void)getTTF{
    self.titleLabel.text = @"字体";
    float btnHeight = 30;
    float btnWidth = 45;
    
    WxxButton *songBtn = [[WxxButton alloc] initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5,(cellHeight-btnHeight)/2, btnWidth, btnHeight)];
    songBtn.layer.cornerRadius = songBtn.frame.size.height/2;
    songBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    songBtn.backgroundColor = [UIColor clearColor];
    songBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [songBtn setTitle:@"宋体" forState:UIControlStateNormal];
    songBtn.titleLabel.textColor = [UIColor whiteColor];
    songBtn.layer.borderWidth = 1;
    [self.contentView addSubview:songBtn];
    [songBtn release];
}

//字体
-(void)getFont{
    self.titleLabel.text = @"字号";
    
    float btnHeight = 30;
    float btnWidth = 70;
    WxxButton *smallBtn = [[WxxButton alloc] initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5,(cellHeight-btnHeight)/2, btnWidth, btnHeight)];
    smallBtn.layer.cornerRadius = smallBtn.frame.size.height/2;
    smallBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    smallBtn.backgroundColor = [UIColor clearColor];
    smallBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [smallBtn setTitle:@"小" forState:UIControlStateNormal];
    smallBtn.titleLabel.textColor = [UIColor whiteColor];
    smallBtn.layer.borderWidth = 1;
    [self.contentView addSubview:smallBtn];
    [smallBtn release];
    smallBtn.alpha = 0.5;
    
//    UILabel *fontLb = [[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(smallBtn.frame)+15, 0, 30, cellHeight)] autorelease];
//    fontLb.text = @"20";
//    fontLb.textColor = [UIColor whiteColor];
//    [self.contentView addSubview:fontLb];
    
    
    WxxButton *bigBtn = [[WxxButton alloc] initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(smallBtn.frame)+15,(cellHeight-btnHeight)/2, btnWidth, btnHeight)];
    bigBtn.layer.cornerRadius = smallBtn.frame.size.height/2;
    bigBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    bigBtn.backgroundColor = [UIColor clearColor];
    bigBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bigBtn setTitle:@"大" forState:UIControlStateNormal];
    bigBtn.titleLabel.textColor = [UIColor whiteColor];
    bigBtn.layer.borderWidth = 1;
    [self.contentView addSubview:bigBtn];
    [bigBtn release];
    bigBtn.alpha = 0.5;
    
    
    [smallBtn receiveObject:^(id object) {
        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            bigBtn.alpha = 0.5;
            smallBtn.alpha = 0.4;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                smallBtn.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }];
        [self sendObject:setSelectDelFont];
    }];
    [bigBtn receiveObject:^(id object) {
        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            smallBtn.alpha = 0.5;
            bigBtn.alpha = 0.4;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                bigBtn.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }];
        [self sendObject:setSelectAddFont];
    }];
//    [smallBtn addTarget:self action:@selector(smallFont) forControlEvents:UIControlEventTouchUpInside];
//    [bigBtn addTarget:self action:@selector(bigFont) forControlEvents:UIControlEventTouchUpInside];
//    EvRoundProgressView *addFont = [[EvRoundProgressView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-btnLength)/2-40,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:[UIColor whiteColor] backColor:nil];
//    [addFont createAdd];
//    [self.contentView addSubview:addFont];
//    [addFont receiveObject:^(id object) {
////        NSLog(@"字体变大");
////        [addFont createBtn];
//        [self sendObject:setSelectAddFont];
//    }];
//    [addFont release];
//    
//    EvRoundProgressView *delFont = [[EvRoundProgressView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-btnLength)/2+40,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:[UIColor whiteColor] backColor:nil];
//    [delFont createDel];
//    [self.contentView addSubview:delFont];
//    [delFont receiveObject:^(id object) {
////        NSLog(@"字体变小");
////        [delFont createBtn];
//        [self sendObject:setSelectDelFont];
//    }];
//    
//    [delFont release];
}

-(void)smallFont{
    
}
-(void)bigFont{
    
}

//板式
-(void)getOrg{
    self.titleLabel.text = @"板式";
    float btnWidth = 30;
    WxxButton *paiban1 = [[WxxButton alloc]initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, (cellHeight-btnWidth)/2, btnWidth, btnWidth)];
    paiban1.layer.borderWidth = 1;
    paiban1.layer.borderColor = [UIColor whiteColor].CGColor;
    paiban1.layer.cornerRadius = btnWidth/2;
    [paiban1 setImage:[ResourceHelper loadImageByTheme:@"v3_yuedu_paiban1"] forState:UIControlStateNormal];
    [self.contentView addSubview:paiban1];
    
    WxxButton *paiban2 = [[WxxButton alloc]initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(paiban1.frame)+15, (cellHeight-btnWidth)/2, btnWidth, btnWidth)];
    paiban2.layer.borderWidth = 1;
    paiban2.layer.borderColor = [UIColor whiteColor].CGColor;
    paiban2.layer.cornerRadius = btnWidth/2;
    [paiban2 setImage:[ResourceHelper loadImageByTheme:@"v3_yuedu_paiban2"] forState:UIControlStateNormal];
    [self.contentView addSubview:paiban2];
    
    WxxButton *paiban3 = [[WxxButton alloc]initWithTouchLightFrame:CGRectMake(CGRectGetMaxX(paiban2.frame)+15, (cellHeight-btnWidth)/2, btnWidth, btnWidth)];
    paiban3.layer.borderWidth = 1;
    paiban3.layer.borderColor = [UIColor whiteColor].CGColor;
    paiban3.layer.cornerRadius = btnWidth/2;
    [paiban3 setImage:[ResourceHelper loadImageByTheme:@"v3_yuedu_paiban3"] forState:UIControlStateNormal];
    [self.contentView addSubview:paiban3];
    paiban1.alpha = 0.5;
    paiban2.alpha = 0.5;
    paiban3.alpha = 0.5;
    [paiban1 addTarget:self action:@selector(paiban1) forControlEvents:UIControlEventTouchUpInside];
    [paiban2 addTarget:self action:@selector(paiban2) forControlEvents:UIControlEventTouchUpInside];
    [paiban3 addTarget:self action:@selector(paiban3) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *bodyFontor = [[NSUserDefaults standardUserDefaults]objectForKey:bodyFontOrg];
    if ([bodyFontor isEqualToString:@"1.6"]) {
        paiban1.alpha = 1.0;
    }
    if ([bodyFontor isEqualToString:@"1.9"]) {
        paiban2.alpha = 1.0;
    }
    if ([bodyFontor isEqualToString:@"2.2"]) {
        paiban3.alpha = 1.0;
    }
 
    [paiban1 receiveObject:^(id object) {
        [self sendObject:setSelectLineOrg1];
        paiban1.alpha = 1;
        paiban2.alpha = 0.5;
        paiban3.alpha = 0.5;
    }];
    [paiban2 receiveObject:^(id object) {
        [self sendObject:setSelectLineOrg2];
        paiban1.alpha = 0.5;
        paiban2.alpha = 1;
        paiban3.alpha = 0.5;
    }];
    [paiban3 receiveObject:^(id object) {
        [self sendObject:setSelectLineOrg3];
        paiban1.alpha = 0.5;
        paiban2.alpha = 0.5;
        paiban3.alpha = 1;
    }];
    
}

-(void)paiban1{
    [self sendObject:setSelectLineOrg1];
}
-(void)paiban2{
    [self sendObject:setSelectLineOrg2];
}
-(void)paiban3{
    [self sendObject:setSelectLineOrg3];
}

//颜色
-(void)getColor{
    self.titleLabel.text = @"背景";
    UIColor *gragcolor = [UIColor grayColor];
    EvRoundProgressView *evrp = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame),                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:gragcolor backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_green"]]];
    [self.contentView addSubview:evrp];
    [evrp receiveObject:^(id object) {
//        NSLog(@"黑色");
        [self sendObject:setSelectVirescence];
    }];
    
    //setSelectNight
    EvRoundProgressView *evrp1 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp.frame)+5,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength)
                                                             progressColor:gragcolor
                                                                 backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_night"]]];
    [self.contentView addSubview:evrp1];
    [evrp1 receiveObject:^(id object) {
//        NSLog(@"点击色彩");
        [self sendObject:setSelectNight];
    }];
    
    
//    reading_background_sepia@2x
    EvRoundProgressView *evrp2 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp1.frame)+5,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:gragcolor backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background_sepia"]]];
    [self.contentView addSubview:evrp2];
    [evrp2 receiveObject:^(id object) {
//        NSLog(@"点击色彩");
        [self sendObject:setSelectSepia];
    }];
//
//    EvRoundProgressView *evrp3 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-btnLength)/2-100,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:[UIColor orangeColor] backColor:[UIColor orangeColor]];
//    [self.contentView addSubview:evrp3];
//    [evrp3 receiveObject:^(id object) {
//        NSLog(@"点击色彩");
//        [self sendObject:setSelectOrage];
//    }];
    
//    淡白
    EvRoundProgressView *evrp4 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp2.frame)+5,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:gragcolor backColor:[UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"reading_background"]]];
    [self.contentView addSubview:evrp4];
    [evrp4 receiveObject:^(id object) {
        [self sendObject:setSelectgrayWhite];
    }];
    
    
    EvRoundProgressView *evrp5 = [[EvRoundProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(evrp4.frame)+5,                                                                                     (cellHeight-btnLength)/2,btnLength, btnLength) progressColor:gragcolor backColor:[UIColor whiteColor]];
    [self.contentView addSubview:evrp5];
    [evrp5 receiveObject:^(id object) {
        //        NSLog(@"点击色彩");
        [self sendObject:setSelectWhite];
    }];
    
    
    [evrp release];
    [evrp1 release];
    [evrp2 release];
//
    [evrp4 release];
    [evrp5 release];
}
//亮度
-(void)getLight{
  
    UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-200)/2, (cellHeight-10)/2, 200, 10)];
    [self.contentView addSubview:slide];
    [slide addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slide release];
}
-(void)sliderValueChanged:(UISlider* )slider {
//    NSLog(@"Slider value=%f", slider.value);
    [[UIScreen mainScreen] setBrightness:slider.value];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
