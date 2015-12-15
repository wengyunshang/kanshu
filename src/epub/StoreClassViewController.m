//
//  StoreClassViewController.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 15/3/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "StoreClassViewController.h"
#import "StoreClassTableViewCell.h"
#import "SVHTTPRequest.h"
#import "ClassData.h"
#import "PenSoundDao.h"
#import "WxxIapStore.h"
#import "StoreViewController.h"
#import "SearchResultViewController.h"
#import "BigClassData.h"
@interface StoreClassViewController ()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *bookArrDic;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)UISearchBar *searchBar;
@end

@implementation StoreClassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"storebooks", nil);
    
    
    
   self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view.
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0,0,UIBounds.size.width,CGRectGetHeight(self.view.frame)-116) ] autorelease];
    self.tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    //    self.tableView.userInteractionEnabled = NO;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 20)]];
    [self.view addSubview:self.tableView];
    [self getDataList];
    [self.tableView setTableHeaderView:[self initHeadView]];
    _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 4);
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor], nil];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1.0);
        _gradientLayer.hidden = YES;
    [self.view.layer addSublayer:_gradientLayer];
}


-(UIView*)initHeadView{
    
    _searchBar = [[[UISearchBar alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40)] autorelease];
    _searchBar.placeholder=@"查找书籍";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
//    theTableView.tableHeaderView = searchBar;
//    _searchBar.showsBookmarkButton = YES;
//    _searchBar.showsSearchResultsButton = YES;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
//    _searchBar.tintColor = WXXCOLOR(230, 87, 72, 0.87);
    _searchBar.barTintColor = [UIColor whiteColor];
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    //searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    for(id cc in [_searchBar.subviews[0] subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消"  forState:UIControlStateNormal];
//            btn.titleLabel.font = fontToSize(15);
//            [btn setTitleColor:WXXCOLOR(0, 0, 0, 0.25) forState:UIControlStateNormal];
//        }
//    }
//    [self.view addSubview: searchBar];
//    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
//    headV.backgroundColor = [UIColor whiteColor];
//    headV.layer.cornerRadius = 5;
//    self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, UIBounds.size.width-30, 40)];
//    self.searchField.layer.borderColor = WXXCOLOR(230, 87, 72, 0.54).CGColor;
//    self.searchField.backgroundColor = WXXCOLOR(0, 0, 0, 0.2);
//    self.searchField.layer.cornerRadius = 5;
//    self.searchField.layer.borderWidth = 1;
//    [headV addSubview:self.searchField];
    
    return _searchBar;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            btn.titleLabel.font = fontToSize(15);
            [btn setTitleColor:WXXCOLOR(230, 87, 72, 0.87) forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
    NSLog( @"%s,%d" , __FUNCTION__ , __LINE__ );
    if ([self.searchBar.text length]>0) {
//        [self getSearchBookList];
        [[WxxLoadView sharedInstance]showself];
        [self performSelector:@selector(getSearchBookList) withObject:nil afterDelay:2];
        [searchBar resignFirstResponder];
    }else{
        [[WxxPopView sharedInstance]showPopText:@"请输入书名"];
    }
}
//cancel button clicked...
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    NSLog( @"%s,%d" , __FUNCTION__ , __LINE__ );
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
}

//搜索
-(void)getSearchBookList{
    
    //获取分类信息
    [SVHTTPRequest GET:[WXXHTTPUTIL getSearchBookList]
            parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.searchBar.text,@"book_name",
                        nil]
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                NSLog(@"%@",response);
                if (response) {
                    if ([response count]<=0) {
                        [[WxxLoadView sharedInstance]hideSelf];
                        [[WxxPopView sharedInstance]showPopText:@"没查到相关书籍"];
                    }else{
                        SearchResultViewController *searchVC = [[SearchResultViewController alloc]init];
                        [searchVC setDicInfo:response];
                        [self.navigationController pushViewController:searchVC animated:YES];
                        [searchVC release];
                    }
                }else{
                    
                }
            }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 3.0) {
        
        _gradientLayer.hidden = YES;
    }else{
        if (_gradientLayer.hidden) {
            _gradientLayer.hidden = NO;
        }
    }
    //    NSLog(@"----%f",scrollView.contentOffset.y);
}
-(void)getDataList{
    //小熊看书id
    self.bookArrDic  = [[PenSoundDao sharedPenSoundDao]selectBigClassList:bigClassValue];
    [self.tableView reloadData];
}

-(void)getBigClassINfo{
    
    //获取分类信息
    [SVHTTPRequest GET:[WXXHTTPUTIL getClassList]
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                
                if (response) {
                    //                    NSLog(@"%@",response);
//                    if ([response count]<=0) {
//                        [[WxxAlertView sharedInstance]showWithTextWithTime:NSLocalizedString(@"loadNilBook", nil)];
//                    }else{
//                        [[WxxAlertView sharedInstance]hidden];
//                    }
//                    for (int i=0; i<[response count]; i++) {
//                        ClassData *classData =[ClassData initWithDictionary:[response objectAtIndex:i]];
//                        [classData saveSelfToDB];
//                    }
                    //分类下载完毕，把logo界面隐藏掉,进入主界面，
//                    [[BookLogoView sharedInstance]hideSelf];
                }else{
                    //分类下载错误的情况下： 如果本地存在分类，也隐藏logo,
//                    if ([[ClassData sharedClassData]ynHaveClass]) {
//                        [[BookLogoView sharedInstance]hideSelf];
//                    }else{//如果本地没有分类，需要继续下载，否则链接全部失效
//                        [self getClassINfo];
//                    }
                }
            }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bookArrDic count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cate_cell";
        
    StoreClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil) {
        cell = [[[StoreClassTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BigClassData *bookData =[self.bookArrDic objectAtIndex:indexPath.row];
    [cell setInfo:bookData];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BigClassData *bookData =[self.bookArrDic objectAtIndex:indexPath.row];
    if ([bookData.bclass_price intValue]>0 && [bookData.bclass_buy intValue]==0) {
        [[WxxLoadView sharedInstance]showself];
        //购买
        [[WxxIapStore sharedWxxIapStore]receiveObject:^(id object) {
            [[WxxLoadView sharedInstance]hideSelf];
            if ([object isEqualToString:BUYSECCUSS]) {
                bookData.bclass_buy = @"1";
                [bookData updateSelf];
                self.bookArrDic  = [[PenSoundDao sharedPenSoundDao]selectBigClassList:bookClass];
                [self.tableView reloadData];
            }else{
                
            }
        }];
        
        [[WxxIapStore sharedWxxIapStore] buyGood:[bookData.bson_id intValue]];
        return;
    }
    
    
    StoreClassTableViewCell *cell = (StoreClassTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    ClassData *classData = [cell getClassData];
    [[PenSoundDao sharedPenSoundDao]setMaxNum:classData.cclass_id];
    StoreViewController *svc = [[StoreViewController alloc] initWithClassId:classData.cclass_id];
    
    NSString *iconurl =[NSString stringWithFormat:@"%@%@",httpiconurl,bookData.bclass_logo];
    [svc intiRefreshBtn:iconurl];
    svc.navigationItem.title = classData.cclass_name;
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
