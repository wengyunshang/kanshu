//
//  FeedBackTableViewCell.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/9/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "FeedBackTableViewCell.h"
#import "WxxImageView.h"
#import "FeedBackData.h"
#import "YLLabel.h"
#import "UserData.h"
#import "ResourceHelper.h"
#import "WxxLabel.h"
#import "SDImageView+SDWebCache.h"
@interface FeedBackTableViewCell()
@property (nonatomic,strong)WxxImageView *userImgV; //头像
@property (nonatomic,strong)WxxLabel *userName; // 昵称
@property (nonatomic,strong)YLLabel *userFeedBack; //评论

@end

@implementation FeedBackTableViewCell

-(void)dealloc{
    self.userImgV = nil;
    self.userName = nil;
    self.userFeedBack = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        // Initialization code
        self.userImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(15, 15, 35, 35)] autorelease];
        
        [self.userImgV.layer setBorderColor:[[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor]];
        [self.userImgV.layer setBorderWidth:0.3f];
        self.userImgV.layer.cornerRadius = 3;
        self.userImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userImgV];
        
        self.userName = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userImgV.frame)+10,
                                                                      CGRectGetMinY(self.userImgV.frame),
                                                                      200, 50) font:fontTTFToSize(16)] autorelease];
       
        self.userName.textColor = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];
//        self.userName.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.userName];
        self.userName.text = @"昵称";
        [self.userName resetLineFrame];
      
        
        self.userFeedBack = [[[YLLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame),
                                                                         CGRectGetMaxY(self.userName.frame)+10,
                                                                         UIBounds.size.width-CGRectGetMinX(self.userName.frame)-10, 50)] autorelease];
        self.userFeedBack.font = fontToSize(14);
//        self.userFeedBack.backgroundColor = [UIColor greenColor];
//        self.userFeedBack.text = @"是打发的说法是打发的说法是地方撒旦法说法是打发的说法是地方撒旦法师打发上师打发上的发生的法定是阿斯顿发送到发送到发";
        [self.contentView addSubview:self.userFeedBack];
       
        
//        NSLog(@"%f",CGRectGetMaxY(self.userName.frame)+10);
    }
    return self;
}

//-(void)height{
//    int width =    UIBounds.size.width - 70;
//    CGSize size = CGSizeMake(width,2000);
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize = [@"" sizeWithFont:fontToSize(14) constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    float height = labelsize.height+41;
//}

-(void)setFeedInfo:(FeedBackData*)feeddata{
    UserData *userdata = [[PenSoundDao sharedPenSoundDao]selectUser:feeddata.fuser_openId];
    
    [self.userImgV setImageWithURL:[NSURL URLWithString:userdata.uuser_logo] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]];
    if ([userdata.uuser_name length]<=0) {
        self.userName.text = @"书友";
    }else{
        self.userName.text = userdata.uuser_name;
    }
    
    [self.userName resetLineFrame];
    
    
    //评论
    [self.userFeedBack setText:[NSString stringWithFormat:@"    %@",feeddata.ffeed_text]];
    float highHeight = [self.userFeedBack highHeight:CGRectGetWidth(self.userFeedBack.frame)] + 8;
    [self.userFeedBack resetFrame:highHeight-CGRectGetMinY(self.userFeedBack.frame)];
    
    //
//    feeddata.fuser_openId
    
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
