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
@implementation BookButton

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [[UIColor colorWithRed:205/255.f green:200/255.f blue:190/255.f alpha:1] CGColor];
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 1;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0].CGPath;
        self.layer.shadowOffset = CGSizeMake(0.9, 1.0f);
        self.layer.shadowRadius = 1.5;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;

        
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
        _deleteBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        _deleteBtn.alpha = 0.4;
        [_deleteBtn addTarget:self action:@selector(deleteBook) forControlEvents:UIControlEventTouchUpInside];
//        _deleteBtn.layer.cornerRadius = 3;
//        _deleteBtn.layer.masksToBounds = YES;
        [self addSubview:_deleteBtn];
    }
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _deleteBtn.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _deleteBtn.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];
}

//删除指定书籍
-(void)deleteBook{
    if ([self.bookdata.bbook_down intValue]==1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除《%@》?",self.bookdata.bbook_name]
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
    }else{
        [[WxxPopView sharedInstance]showPopText:@"已删除"];
    }
    
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
    NSString *url = self.bookdata.bbook_doubanlogo;//[[ClassData sharedClassData]getLogoPrefix:self.bookdata.bbook_coverurl];
    NSString *gao7gao8url = [[ClassData sharedClassData]getgao7gao8LogoPrefix:self.bookdata.bbook_id];
    NSLog(@"%@",gao7gao8url);
    
    if (locked) {
        gao7gao8url = nil;
        url = nil;
    } 
//    self.bookImgV.url2 = [NSURL URLWithString:url];
    if ([url length]>20) {
        [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] url2:[NSURL URLWithString:url] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]]; //图标
        
    }else{
        [self.bookImgV setImageWithURL:[NSURL URLWithString:gao7gao8url] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:cellImage]];
        
    }
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
