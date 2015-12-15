//
//  UserUtil.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-5-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "UserUtil.h"
#import "SVHTTPRequest.h"
#import "SetConfig.h"
@implementation UserUtil

-(void)registerUserUdid{
    [SVHTTPRequest GET:[WXXHTTPUTIL sendDeviceUDID]
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
                //                         NSLog(@"%@",response);
                
                //新用户弹出设置界面
                if (!response || WXXBACKERROR(response)) {
                    
                    //弹出设置用户信息框
                    //                             SetViewController *setVC = [[SetViewController alloc]init];
                    //                             [self.navigationController pushViewController:setVC animated:YES];
                    //                             [setVC release];
                    
                    //新用户创建星星表新数据
//                    [WXXBASEINFOUTIL newStarData];
//                    [WXXBASEINFOUTIL newUserData];
//                    [WXXBASEINFOUTIL receiveObject:^(id object) {
//                        IndexViewController *indexVC = [[IndexViewController alloc]init];
//                        [self.navigationController pushViewController:indexVC animated:YES];
//                        [indexVC release];
//                    }];
                }else{
//                    //设置database全局用户信息
//                    [WXXBASEINFOUTIL setUserInfoData:response];
//                    [WXXUSERDATA saveSelfToDB];
//                    
//                    [SVHTTPRequest GET:[WXXHTTPUTIL findStar4Id]
//                            parameters:nil
//                            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *errors) {
//                                
//                                if (!response || WXXBACKERROR(response)) {
//                                }else{
//                                    //设置星星表数据
//                                    [WXXBASEINFOUTIL setStarInfoData:response];
//                                    
//                                    IndexViewController *indexVC = [[IndexViewController alloc]init];
//                                    [self.navigationController pushViewController:indexVC animated:YES];
//                                    [indexVC release];
//                                    
//                                }
//                                
//                            }];
                    
                    
                }
                
                
            }];
}
@end
