//
//  FeedBackView.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 9/8/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "FeedBackView.h"
#import "EvLineProgressView.h"
#import "FeedBackTableViewCell.h"
#import "SVHTTPRequest.h"
@implementation FeedBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        EvLineProgressView* lineView = [[[EvLineProgressView alloc]initWithFrame:CGRectMake(15, 50, UIBounds.size.width-15*2, 1) lineColor:[UIColor lightGrayColor]] autorelease];
        [self addSubview:lineView];
        [lineView showLine];
        
        // Initialization code
        self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(lineView.frame)+5,
                                                                       320,self.frame.size.height-CGRectGetMaxY(lineView.frame)-5)] autorelease];
        self.tableView.dataSource = self;
        
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.userInteractionEnabled = NO;
        [self addSubview:self.tableView];
    }
    return self;
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
    
    int width =    UIBounds.size.width - 70;
    CGSize size = CGSizeMake(width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [@"是打发的说法是打发的说法是地方撒旦法说法是打发的说法是地方撒旦法师打发上师打发上的发生的法定是阿斯顿发送到发送到发" sizeWithFont:fontToSize(14) constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float height = labelsize.height+41;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
