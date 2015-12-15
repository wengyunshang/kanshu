//
//  StoreBookInfoView.h
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-4-23.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
@class BookData;
@interface StoreBookInfoView : UIView
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(StoreBookInfoView);
-(void)show;
-(void)hidden;


-(void)setCellInfo:(BookData*)bookData;
@end

