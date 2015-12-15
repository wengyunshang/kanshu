//
//  BookLoader.m
//  epub
//
//  Created by zhiyu zheng on 12-6-6.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BookLoader.h"

@interface BookLoader()

- (void) parse;

@end

@implementation BookLoader

@synthesize spineArray,filePath,error,savePath;

- (id) initWithPath:(NSString*)path{
    if((self=[super init])){
        
        NSString *fileLast = [path substringFromIndex:[path length]-4];
        NSLog(@"%@",fileLast);
       
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:path];
        
        error = 0;
        self.savePath = [NSString stringWithFormat:@"/book/%@",path];
        self.filePath = writableDBPath;
        if ([fileLast isEqualToString:@"epub"]) {
            self.filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
        }
        NSFileManager *filemanager=[[NSFileManager alloc] init];
        if (![filemanager fileExistsAtPath:self.filePath]) {
            self.filePath = writableDBPath;
        }
        NSLog(@"%@",self.filePath);
		self.spineArray = [[NSMutableArray alloc] init];
        [self.spineArray release];
		[self parse];
	}
	return self;
}

- (void) parse{

}
@end
