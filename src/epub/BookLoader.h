//
//  BookLoader.h
//  epub
//
//  Created by zhiyu zheng on 12-6-6.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookLoader : NSObject

@property(nonatomic, retain) NSArray* spineArray;
@property(nonatomic, retain) NSString* filePath; //书籍在documents的路径
@property(nonatomic, retain) NSString* savePath; //将要保存的书籍路径（caches下）
@property(nonatomic) int error;

- (id) initWithPath:(NSString*)path;

@end
