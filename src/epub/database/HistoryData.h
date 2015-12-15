//
//  HistoryData.h
//  PandaBook
//
//  Created by weng xiangxun on 15/4/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WxxBaseData.h"
#define hscurrentSpineIndex @"currentSpineIndex"
#define hscurrentPageInSpineIndex @"currentPageInSpineIndex"
#define hscurrentTextSize @"currentTextSize"
#define hsbookId @"bookId"
@interface HistoryData : WxxBaseData
@property (nonatomic,strong)NSString *hcurrentSpineIndex;
@property (nonatomic,strong)NSString *hcurrentPageInSpineIndex;
@property (nonatomic,strong)NSString *hcurrentTextSize;
@property (nonatomic,strong)NSString *hbookId;
@end
