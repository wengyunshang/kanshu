//
//  StoreClassTableViewCell.m
//  PandaBook
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "StoreClassTableViewCell.h"
#import "WxxLabel.h"
#import "BigClassData.h"
#import "PenSoundDao.h"
#import "ClassData.h"
#import "SDImageView+SDWebCache.h"
#import "WxxImageView.h"
#import "ResourceHelper.h"
#import "StoreViewController.h"
@interface StoreClassTableViewCell()
@property (nonatomic,strong)WxxLabel *titleLb;
@property (nonatomic,strong)WxxLabel *priceLb;
@property (nonatomic,strong)ClassData *classData;
@property (nonatomic,strong)WxxImageView *imgV;

@end
@implementation StoreClassTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 2.5, UIBounds.size.width-10, 65)];
        view.layer.cornerRadius = 3;
        view.layer.shadowPath =  [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:3].CGPath;
        view.backgroundColor = WXXCOLOR(255, 255, 255, 0.9);
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123123.png"]];
        view.layer.shadowOffset = CGSizeMake(1, 1);
        view.layer.shadowRadius = 1;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.1;
        [self.contentView addSubview:view];
        
        // Initialization code
//        self.contentView.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
        
        self.imgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)] autorelease];
        self.imgV.layer.cornerRadius = 23;
        self.imgV.layer.masksToBounds = YES;
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(15, 12, 46, 46)];
        headView.backgroundColor = [UIColor whiteColor];
        //        self.imgV.layer.masksToBounds = YES;
        headView.layer.borderColor = WXXCOLOR(255, 255, 255, 0.9).CGColor;
        headView.layer.borderWidth = 1;
        [self.contentView addSubview:headView];
        headView.layer.cornerRadius = 23;
        headView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:headView.bounds cornerRadius:23].CGPath;
        headView.layer.shadowOffset = CGSizeMake(1, 1);
        headView.layer.shadowRadius = 1;
        headView.layer.shadowColor = [UIColor blackColor].CGColor;
        headView.layer.shadowOpacity = 0.6;
        [headView addSubview:self.imgV];
        
        
        _titleLb = [[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+10, 2.5, 200, 65)];
        _titleLb.textColor = WXXCOLOR(0, 0, 0, 0.54);
        _titleLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [self.contentView addSubview:_titleLb];
        
        _priceLb = [[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+10, 2.5, 200, 65)];
        _priceLb.textColor = WXXCOLOR(0, 121, 242, 1);//[[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor];
//        _priceLb.text = @"1.00元";
        _priceLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [self.contentView addSubview:_priceLb];
        
    }
    return self;
}

-(void)setInfo:(BigClassData*)data{
    ClassData *cd = [[PenSoundDao sharedPenSoundDao]selectClass:data.bson_id];
//    [ResourceHelper loadImageByTheme:@"item_bg_selected"]
    self.classData = cd;
    _titleLb.text = cd.cclass_name;//data.bson_id;
//    [self.imgV setImage:[ResourceHelper loadImageByThemeJpg:cd.cclass_name]];
    
    if ([data.bclass_price intValue]>0 && [data.bclass_buy intValue] == 0) {
        _priceLb.hidden = NO;
        _priceLb.text = [NSString stringWithFormat:@"¥%@",data.bclass_price];
        [_priceLb reset2FrameWIthRight:UIBounds.size.width rightOrg:35];
        CGRect rect = _priceLb.frame;
        rect.size.height = 65;
        _priceLb.frame = rect;
    }else{
        _priceLb.hidden = YES;
    }
    
    NSString *iconurl =[NSString stringWithFormat:@"%@%@",httpiconurl,data.bclass_logo];
    [self.imgV setImageWithURL:[NSURL URLWithString:iconurl] refreshCache:NO placeholderImage:[ResourceHelper loadImageByThemeJpg:cd.cclass_name]];
}
-(ClassData*)getClassData{
    return self.classData;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
