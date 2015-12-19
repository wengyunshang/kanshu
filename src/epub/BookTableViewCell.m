//
//  BookTableViewCell.m
//  epub
//
//  Created by weng xiangxun on 14-3-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BookTableViewCell.h"
#import "BookData.h"
#import "SDImageView+SDWebCache.h"
#import "ResourceHelper.h"
#import "ClassData.h"
#import "BookButton.h"

@interface BookTableViewCell()
@property (nonatomic, strong) BookData *bookData;
@property (nonatomic, strong) BookButton *bookButton;
@property (nonatomic, strong) BookButton *bookButton2;
@property (nonatomic, strong) BookButton *bookButton3;
@end
@implementation BookTableViewCell

-(void)dealloc{
    
    [_bookData release];
//    [_bookSize release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
        
//        int r = arc4random() % 255;
//        int g = arc4random() % 255;
//        int b = arc4random() % 255;
//        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(-5, (UIBounds.size.width-tabHeight)/3*8/6+20-tabHeight/3, UIBounds.size.width-25, tabHeight/3)];
//        bottomView.backgroundColor =[UIColor whiteColor];// WXXCOLOR(r, g, b, 0.8);
//        bottomView.layer.borderWidth = 1;
//        bottomView.layer.borderColor = WXXCOLOR(255, 255, 255, 0.4).CGColor;
////        bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123123.png"]];
//        bottomView.layer.cornerRadius = 3;
//        bottomView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds cornerRadius:3].CGPath;
//        bottomView.layer.shadowOffset = CGSizeMake(2, 1);
//        bottomView.layer.shadowRadius = 2;
//        bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
//        bottomView.layer.shadowOpacity = 0.4;
//        [self.contentView addSubview:bottomView];
        
        
//        bottomView.frame = CGRectMake(-5, CGRectGetMinY(bottomView.frame)-5, bottomView.frame.size.width, bottomView.frame.size.height);
//        bottomView.layer.anchorPoint=CGPointMake(0.5, 0.0);
//        CALayer *layer = bottomView.layer;
//        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 50.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
//        layer.transform = rotationAndPerspectiveTransform;
        ;
        
        
        
        if (!_bookButton) {
            _bookButton = [[BookButton alloc]initWithFrame:CGRectMake(bookOgrx, 10, bookWidth, bookHeight)];
            [self.contentView addSubview:_bookButton];
        }
        
        if (!_bookButton2) {
            _bookButton2 = [[BookButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_bookButton.frame)+bookOgrx, 10, bookWidth, bookHeight)];
            [self.contentView addSubview:_bookButton2];
        }
        if (!_bookButton3) {
            _bookButton3 = [[BookButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_bookButton2.frame)+bookOgrx, 10, bookWidth, bookHeight)];
            [self.contentView addSubview:_bookButton3];
        }
        [_bookButton receiveObject:^(id object) {
            [self sendObject:_bookButton];
        }];
        UIImage *image = [UIImage imageNamed:@"sw.jpg"];
        [_bookButton setupBookCoverImage:image];
//        WxxImageView *arrowImgv = [[WxxImageView alloc]initWithImage:[ResourceHelper loadImageByTheme:@"nav_pane_handle_arrow"]];
//        arrowImgv.frame = CGRectMake(UIBounds.size.width - arrowImgv.image.size.width - 10, 40, arrowImgv.image.size.width, arrowImgv.image.size.height);
//        [self.contentView addSubview:arrowImgv];
//        [arrowImgv release];
    }
    return self;
}

-(void)setBookSelected{
    if (_bookButton) {
        [_bookButton setBookSelected];
    }
    if (_bookButton2) {
        [_bookButton2 setBookSelected];
    }
    if (_bookButton3) {
        [_bookButton3 setBookSelected];
    } 
}

-(void)showDelBtn{
    [_bookButton showDeleteBtn];
    [_bookButton2 showDeleteBtn];
    [_bookButton3 showDeleteBtn];
}
-(void)hideDelBtn{
    [_bookButton hideDeleteBtn];
    [_bookButton2 hideDeleteBtn];
    [_bookButton3 hideDeleteBtn];
}
 

-(void)setBookData1:(BookData*)bookdata{
    if (bookdata) {
                _bookButton.hidden = NO;
        _bookButton.bookdata = bookdata;
        [_bookButton reflashDataInfo];
    }else{
        _bookButton.hidden = YES;
    }
}

-(void)setBookData2:(BookData*)bookdata{
    if (bookdata) {
        _bookButton2.hidden = NO;
        _bookButton2.bookdata = bookdata;
        [_bookButton2 reflashDataInfo];
    }else{
        _bookButton2.hidden = YES;
    }
}

-(void)setBookData3:(BookData*)bookdata{
    if (bookdata) {
        _bookButton3.hidden = NO;
        _bookButton3.bookdata = bookdata;
        [_bookButton3 reflashDataInfo];
    }else{
        _bookButton3.hidden = YES;
    }
}
-(void)setCellInfo:(BookData*)bookData{
    self.bookData = bookData;  

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
