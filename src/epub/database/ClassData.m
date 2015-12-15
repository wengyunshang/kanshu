//
//  ClassData.m
//  bingyuhuozhige
//
//  Created by weng xiangxun on 14-6-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ClassData.h"

@implementation ClassData


static ClassData *_sharedClassData = nil;
/**
 数据库采用单例模式: 不必每个地方去管理
 */
+ (ClassData *)sharedClassData{
    if (!_sharedClassData || !_sharedClassData.cclass_name || !_sharedClassData.cclass_logo) {
        _sharedClassData = [[[PenSoundDao sharedPenSoundDao]selectClass:bookClass] retain];;
    }
    return _sharedClassData;
}

-(void)changeClassData:(NSString*)classId{
    _sharedClassData = nil;
    _sharedClassData = [[[PenSoundDao sharedPenSoundDao]selectClass:bookClass] retain];;
}
#define cloudUrl @"http://wxxbook.qiniudn.com"
#define guwencloudUrl @"http://xstory.qiniudn.com"
#define guwenGao7gao8Url @"http://pkg.gao7gao8.com/epub"
//logo前缀  拼凑方式： url + 目录 + 文件名
-(NSString*)getLogoPrefix:(NSString*)fileName{
//    NSLog(@"%@",fileName);
    if (fileName && [fileName length]>0) {
        NSString *str = [NSString
                         stringWithFormat:@"%@/%@/%@/%@",
                         self.cclass_url2,
                         [self.cclass_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         self.cclass_logo,
                         [fileName
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        return str;
    }
    return nil;
}
//文件前缀  拼凑方式： url + 目录 + 文件名
-(NSString*)getBookPrefix:(NSString*)fileName{
//     NSLog(@"%@",fileName);
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@",self.cclass_url2,[self.cclass_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.cclass_book,[fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return str;
}

//gao7gao8 服务端的链接
-(NSString*)getgao7gao8LogoPrefix:(NSString*)fileName{
    //    NSLog(@"%@",fileName);
    if (fileName && [fileName length]>0) {
        NSString *str = [NSString stringWithFormat:@"%@/%@/%@.jpg",self.cclass_url,self.cclass_logo,[fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        return str;
    }
    return nil;
}
//gao7gao8 服务端的链接
-(NSString*)getgao7gao8BookPrefix:(NSString*)fileName{
    //     NSLog(@"%@",fileName);
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@.epub",self.cclass_url,self.cclass_book,[fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return str;
}

//本地分类是否正确
-(BOOL)ynHaveClass{
    if (self.cclass_logo && self.cclass_book) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    
    [_cclass_id release];
    [_cclass_name release];
    [_cclass_logo release];
    [_cclass_book release];
    [_cclass_url release];
    [_cclass_url2 release];
    [_cclass_title release];
    [super dealloc];
}


+ (id)initWithDictionary:(NSDictionary*)dic{
    ClassData *dbbdata = [[[ClassData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.cclass_id       = [dic objectForKey:class_id];
        self.cclass_name     = [dic objectForKey:class_name];
        self.cclass_logo     = [dic objectForKey:class_logo];
        self.cclass_book     = [dic objectForKey:class_book];
        self.cclass_url     = [dic objectForKey:class_url];
        self.cclass_url2     = [dic objectForKey:class_url2];
        self.cclass_title = [dic objectForKey:class_title];
    }
    return self;
}



//-(void)updateSelf{
//    
//    [[PenSoundDao sharedPenSoundDao] updateBookData:self];
//}

//保存本实体到本地
-(void)saveSelfToDB{
    
    [[PenSoundDao sharedPenSoundDao]saveClass:self];
}
@end
