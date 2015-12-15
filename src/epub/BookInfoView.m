//
//  BookInfoView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/7/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "BookInfoView.h"
#import "WxxLabel.h"
#import "YLLabel.h"
#import "BookData.h"
#import "FeedBackTableViewCell.h"
#import "EvLineProgressView.h"

#import "SVHTTPRequest.h"
@interface BookInfoView()
@property (nonatomic,strong)WxxLabel *authorTitleLb;
@property (nonatomic,strong)WxxLabel *authorLb;
@property (nonatomic,strong)YLLabel *bookIntroduction; //介绍
@property (nonatomic,strong)WxxLabel *bookTitleLb;
@property (nonatomic,strong)WxxLabel *bookLb;
@property (nonatomic,assign)BookData *bookdata;
@property (nonatomic,strong)UIView *headView;
@end

@implementation BookInfoView

- (id)initWithFrame:(CGRect)frame bookData:(BookData *)bookData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bookdata = bookData;
//        EvLineProgressView* lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(15, 50, UIBounds.size.width-15*2, 1) lineColor:[UIColor lightGrayColor]] autorelease];
//        [self addSubview:lineView];
//        [lineView showLine];
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                       15,
                                                                       320,self.frame.size.height-15) ] autorelease];
        self.tableView.dataSource = self;
        
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.userInteractionEnabled = NO;
        [self addSubview:self.tableView];
    }
    return self;
}

-(UIView *)headView{
    
    CGRect rect = CGRectMake(0, 0, UIBounds.size.width, 10);
    UIView *headview = [[[UIView alloc]initWithFrame:rect] autorelease];
    headview.backgroundColor = [UIColor redColor];
    EvLineProgressView* lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(15, 50, UIBounds.size.width-15*2, 1) lineColor:[UIColor lightGrayColor]] autorelease];
    [headview addSubview:lineView];
    [lineView showLine];
    int fontSize = 16;
    int orgX = 16;
    UIColor *colors = [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1];;
    self.bookTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(orgX, CGRectGetMaxY(lineView.frame)+10, 50, 30) text:@"书名:" font:fontTTFToSize(fontSize)]autorelease];
    self.bookTitleLb.textColor = colors;
    [self addSubview:self.bookTitleLb];
    self.bookLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bookTitleLb.frame), CGRectGetMinY(self.bookTitleLb.frame), 200, 30) text:self.bookdata.bbook_name font:fontTTFToSize(fontSize)] autorelease];
    self.bookLb.textColor = colors;
    [headview addSubview:self.bookLb];
    
    self.authorTitleLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bookTitleLb.frame), CGRectGetMaxY(self.bookTitleLb.frame), 50, 30) text:@"作者:" font:fontTTFToSize(fontSize)] autorelease];
    self.authorTitleLb.textColor = colors;
    [headview addSubview:self.authorTitleLb];
    self.authorLb = [[[WxxLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.authorTitleLb.frame), CGRectGetMinY(self.authorTitleLb.frame), 200, 30) text:self.bookdata.bbook_author font:fontTTFToSize(fontSize)] autorelease];
    self.authorLb.textColor = colors;
    [headview addSubview:self.authorLb];
    
    EvLineProgressView* lineView2 = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(self.authorTitleLb.frame)+10, CGRectGetWidth(lineView.frame), 1) lineColor:[UIColor lightGrayColor]] autorelease];
    [headview addSubview:lineView2];
    [lineView2 showLine];
    
    
    
    self.bookIntroduction = [[[YLLabel alloc]initWithFrame:CGRectMake(orgX,
                                                                     CGRectGetMaxY(lineView2.frame) + 10,
                                                                     UIBounds.size.width-orgX*2, 50)] autorelease];
    self.bookIntroduction.font = fontToSize(fontSize);
    
    [headview addSubview:self.bookIntroduction];
    [self.bookIntroduction setText:self.bookdata.bbook_introduction];
    
    float highHeight = [self.bookIntroduction highHeight:CGRectGetWidth(self.bookIntroduction.frame)] + 8;
    [self.bookIntroduction resetFrame:highHeight-CGRectGetMinY(self.bookIntroduction.frame)];
    
    
    rect.size.height = CGRectGetMaxY(self.bookIntroduction.frame);
    headview.frame = rect;
    return headview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    self.headView = [self headView];
//    NSLog(@"%f",CGRectGetMaxY(self.headView.frame));
    return CGRectGetMaxY(self.headView.frame);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headView;
}


//获取评论列表
-(void)getFeedbackList{
    [SVHTTPRequest GET:[WXXHTTPUTIL getFeedBackList4BookId]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        bookClass,@"class_id",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                //                if (response) {
                //
                //                    [[NSUserDefaults standardUserDefaults] setObject:[WXXHTTPUTIL getYYYYMMDD] forKey:@"lastupdate"];
                //
                //                    if ([response count]>0) {
                //                        for (int i=0; i<[response count]; i++) {
                //                            BookData *bookData =[BookData initWithDictionary:[response objectAtIndex:i]];
                //                            [bookData updateBookDataByServer];
                //                        }
                //                    }
                //                }
                //                //刷新
                //                [self reloadData];
            }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    int width =    UIBounds.size.width - 70;
//    CGSize size = CGSizeMake(width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize = [@"是打发的说法是打发的说法是地方撒旦法说法是打发的说法是地方撒旦法师打发上师打发上的发生的法定是阿斯顿发送到发送到发" sizeWithFont:fontToSize(14) constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float height = 1+41;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    FeedBackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    return cell;
}
 

@end
