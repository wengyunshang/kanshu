//
//  BookButton.m
//  PandaBook
//
//  Created by weng xiangxun on 15/3/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BookButton.h"
#import "WxxImageView.h"
#import "WxxLabel.h"
#import "ResourceHelper.h"
#import "ClassData.h"
#import "SDImageView+SDWebCache.h"
#import "BookData.h"

@interface BookButton()
@property (nonatomic,strong)UIImageView *delIconImgV;
@property (nonatomic,assign)BOOL ynSelect;
@end

@implementation BookButton

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.layer.borderColor = [[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor];
//        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 1;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0].CGPath;
        self.layer.shadowOffset = CGSizeMake(0.9, 1.0f);
        self.layer.shadowRadius = 1.5;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.ynSelect = NO;
        
        self.bookImgV = [[[WxxImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        self.bookImgV.image = [ResourceHelper loadImageByTheme:cellImage];
        [self addSubview:self.bookImgV];
        
        self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.bookTitleLb.frame), self.frame.size.width, self.bookTitleLb.frame.size.height)];
//        self.titleView.layer.cornerRadius = 1;
        self.titleView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.4];//WXXCOLOR(46, 108, 153, 1);
        [self addSubview:self.titleView];
        
        self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(2,
                                                                      CGRectGetMaxY(self.frame)+3,
                                                                      self.frame.size.width-4, 50)] autorelease];
        self.bookTitleLb.font = [UIFont boldSystemFontOfSize:12];
        
        self.bookTitleLb.textColor = [UIColor whiteColor];
        [self addSubview:self.bookTitleLb];
        self.bookTitleLb.textAlignment = NSTextAlignmentCenter;
        self.bookTitleLb.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.4];//WXXCOLOR(46, 108, 153, 1);
        
         
        [self addTarget:self action:@selector(showBookWebView) forControlEvents:UIControlEventTouchUpInside];
        
//        _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
//        
//        [self addSubview:_cover];
//        [self showDeleteBtn];
    }
    return self;
}

- (void)setupBookCoverImage:(UIImage *)image
{
    _cover.layer.contents = (__bridge id)(image.CGImage);
}
-(void)showBookWebView{
//    BookData *bookData = [self.booksArr objectAtIndex:row];
//    [self sendObject:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBooks" object:self.bookdata];
}

-(void)showDeleteBtn{
    
    if (!_deleteBtn) {
        _deleteBtn = [[WxxButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
//        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [_deleteBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        _deleteBtn.alpha = 0.4;
        [_deleteBtn addTarget:self action:@selector(deleteBook) forControlEvents:UIControlEventTouchUpInside];
//        _deleteBtn.layer.cornerRadius = 3;
//        _deleteBtn.layer.masksToBounds = YES;
        [self addSubview:_deleteBtn];
    }
    if (!self.delIconImgV) {
        UIImage *image = [ResourceHelper loadImageByTheme:@"v3_sj_quxiao"];
        self.delIconImgV = [[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_deleteBtn.frame)-image.size.width/3*2,
                                                                         CGRectGetHeight(_deleteBtn.frame)-image.size.height/3*2,
                                                                         image.size.width,
                                                                         image.size.height)] autorelease];
        
        [_deleteBtn addSubview:self.delIconImgV];
    }
    self.ynSelect = NO;
    self.delIconImgV.image = [ResourceHelper loadImageByTheme:@"v3_sj_quxiao"];
    _deleteBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
//    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [_deleteBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _deleteBtn.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _deleteBtn.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];
}

//设置书籍为选中状态
-(void)setBookSelected{
    self.ynSelect = NO;
    [self deleteBook];
}

//删除指定书籍
-(void)deleteBook{
    
//    [self.bookdata.bbook_down intValue]==1
    NSString *imgStr = @"v3_sj_xuan";
    UIColor *btnColor =[UIColor clearColor];
    if (!self.ynSelect) {
        self.ynSelect = YES;
        [[PenSoundDao sharedPenSoundDao]addDelBookIdToArr:self.bookdata.bbook_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDeleteBottomView" object:nil];
    }else{
        
        self.ynSelect = NO;
        imgStr = @"v3_sj_quxiao";
        btnColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [[PenSoundDao sharedPenSoundDao]removeDelBookIdFromArr:self.bookdata.bbook_id];
//        [[WxxPopView sharedInstance]showPopText:@"已删除"];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.delIconImgV.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.delIconImgV.image = [ResourceHelper loadImageByTheme:imgStr];
        self.deleteBtn.backgroundColor = btnColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.delIconImgV.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
//    [UIView animateKeyframesWithDuration:0.5 delay:nil options:nil animations:^{
//        
//        self.delIconImgV.alpha = 0.5;
//    } completion:^(BOOL finished) {
//        
//    }];
    
//    [[PenSoundDao sharedPenSoundDao]delBook4Id:bookData.bbook_id];//删除书本数据库信息
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [_deleteBtn setTitle:@"已删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.bookdata.bbook_down = @"0"; //设置为未下载
        [self.bookdata updateSelf];
    }
}

-(void)hideDeleteBtn{
    
    if (self.deleteBtn) {
        [UIView animateWithDuration:0.5 animations:^{
            _deleteBtn.alpha = 0.0;
        }completion:^(BOOL finished){
            
        }];
    }
}
  
-(void)reflashDataInfo{
    
    BOOL locked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveflow"] boolValue];
    
    //logo采用双URL机制，优先考虑gao7服务器， 如果gao7上还没有，读取默认设置服务器的图片
    
    NSString *url = [[ClassData sharedClassData]getLogoPrefix:self.bookdata.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookdata.bbook_id];
    NSString *url3 = self.bookdata.bbook_doubanlogo;
    NSLog(@"%@",gao7gao8url);
    //    if (booktype == BTGulong || booktype == BTjingdu || booktype == BTHanhan || booktype == BTmoyan || booktype == BTzhangailin || booktype == BTqiongyao || booktype == BTWolongsheng || booktype == BTHuangyi) {//静读时光采用豆瓣logo
    //        url = gao7gao8url;
    //        gao7gao8url = self.bookData.bbook_doubanlogo;
    //    }
    //    NSLog(@"gao7::::%@",gao7gao8url);
    if (locked) {
        gao7gao8url = nil;
        url = nil;
    }
    self.bookImgV.url2 = [NSURL URLWithString:url];
    [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url3] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
    
    
    self.bookTitleLb.text = self.bookdata.bbook_name;
    [self.bookTitleLb reset2Frame];
    
    CGRect rect = self.bookTitleLb.frame;
    rect.origin.y = self.bookImgV.frame.size.height-10-rect.size.height;
    rect.size.height = rect.size.height + 2;
    rect.size.width = self.frame.size.width-4;
    self.bookTitleLb.frame = rect;
    self.titleView.frame = CGRectMake(0, CGRectGetMinY(self.bookTitleLb.frame), self.frame.size.width, self.bookTitleLb.frame.size.height);
}

@end
