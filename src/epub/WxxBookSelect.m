//
//  WxxBookSelect.m
//  epub
//
//  Created by weng xiangxun on 14-4-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "WxxBookSelect.h"
#import "ResourceHelper.h"
#import "PenSoundDao.h"
#import "BookData.h"
#import "ClassData.h"
#include <sys/xattr.h>
@implementation WxxBookSelect
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+(void)installBook{
    //初始化基础数据
 if([ResourceHelper getUserDefaults:@"installed"] != nil){
     return;
 }
//    [self initClassid:@"5" name:@"appstore" book:@"book" logo:@"logo" time:@"2014-03-03" url:@"" url2:@""];
//    [self initClassid:@"6" name:@"古典文学" book:@"book" logo:@"logo" time:@"2014-03-03" url:@"" url2:@""];
//    [self initClassid:@"3" name:@"英文书" book:@"book" logo:@"logo" time:@"2014-03-03" url:@"" url2:@""];
//    [self initClassid:@"3" name:@"耽美小说" book:@"book" logo:@"logo" time:@"2014-03-03" url:@"" url2:@""];
//    [self initClassid:@"3" name:@"豆瓣高分图书" book:@"book" logo:@"logo" time:@"2014-03-03" url:@"" url2:@""];
//
    NSArray *bookArr = nil;
    
    switch (booktype) {
        case BTMingxiaoxi:
            [self writeMingxiaoxiBookFile];
            break;
        case BTWaituomingzhu:
            [self writeWaiguoMingzhuBookFile];
            break;
        case BTXiaoxiong:
            
            bookArr = [self installBingyuHUOzhige]; //
            break;
        case BTGuoguo:
            [self writeGuoguoBookFile];
            break;
        case BTStaticread:
            bookArr = [self installStaticread]; //
            break;
        case BTjingdu:
            bookArr = [self installStaticread]; //
            break;
        case BTxiaoshuo:
            bookArr = [self installBingyuHUOzhige]; //
            break;
        default:
            break;
    }
    
    //魔女天骄美人痣
//    NSArray *bookArr = [self installMNTJMRZ];
    if (bookArr) {
        
    
        if([ResourceHelper getUserDefaults:@"installed"] == nil){
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            for (int i=0; i<[bookArr count]; i++) {
                NSLog(@"%@",[bookArr objectAtIndex:i]);
                NSString *fileDefaultPath = [[NSBundle mainBundle] pathForResource:[bookArr objectAtIndex:i] ofType:@"epub"];
                if (fileDefaultPath) {
                    NSURL *pathURL= [NSURL fileURLWithPath:fileDefaultPath];
                    
                    
                    if ([fileManager copyItemAtPath:fileDefaultPath toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, [NSString stringWithFormat:@"%@.epub",[bookArr objectAtIndex:i]]] error:nil] == NO)
                    {
                        [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                        NSLog(@"1: %@",fileDefaultPath);
                        NSLog(@"2: %@",fileDefaultPath);
                        NSLog(@"书本写入Document完毕");
                    }
                    NSFileManager *filemanager=[[NSFileManager alloc] init];
                    if ([filemanager fileExistsAtPath:fileDefaultPath]) {
                        NSError *error;
                        [filemanager removeItemAtPath:fileDefaultPath error:&error];
                    }
                    [filemanager release];
//                    [self addSkipBackupAttributeToItemAtURL:pathURL];
                }
                
            }
        }
        
        [ResourceHelper setUserDefaults:@"1" forKey:@"installed"];
    }
}

+(void)writeGuoguoBookFile{
    if([ResourceHelper getUserDefaults:@"installed"] == nil){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        for (int i=16420; i<16423; i++) {
            NSString *fileDefaultPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"epub"];
            if (fileDefaultPath) {
                NSURL *pathURL= [NSURL fileURLWithPath:fileDefaultPath];
                
                
                if ([fileManager copyItemAtPath:fileDefaultPath toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, [NSString stringWithFormat:@"%@.epub",[NSString stringWithFormat:@"%d",i]]] error:nil] == NO)
                {
                    
                    NSLog(@"1: %@",fileDefaultPath);
                    NSLog(@"2: %@",fileDefaultPath);
                    NSLog(@"书本写入Document完毕");
                }
                [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                NSFileManager *filemanager=[[NSFileManager alloc] init];
                if ([filemanager fileExistsAtPath:fileDefaultPath]) {
                    NSError *error;
                    [filemanager removeItemAtPath:fileDefaultPath error:&error];
                }
                [filemanager release];
                //                    [self addSkipBackupAttributeToItemAtURL:pathURL];
            }
            
        }
    }
    
    [ResourceHelper setUserDefaults:@"1" forKey:@"installed"];
    
}

+(void)writeMingxiaoxiBookFile{
    if([ResourceHelper getUserDefaults:@"installed"] == nil){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        for (int i=16403; i<16417; i++) {
            NSString *fileDefaultPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"epub"];
            if (fileDefaultPath) {
                NSURL *pathURL= [NSURL fileURLWithPath:fileDefaultPath];
                
                
                if ([fileManager copyItemAtPath:fileDefaultPath toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, [NSString stringWithFormat:@"%@.epub",[NSString stringWithFormat:@"%d",i]]] error:nil] == NO)
                {
                    [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                    NSLog(@"1: %@",fileDefaultPath);
                    NSLog(@"2: %@",fileDefaultPath);
                    NSLog(@"书本写入Document完毕");
                }
                NSFileManager *filemanager=[[NSFileManager alloc] init];
                if ([filemanager fileExistsAtPath:fileDefaultPath]) {
                    NSError *error;
                    [filemanager removeItemAtPath:fileDefaultPath error:&error];
                }
                [filemanager release];
                //                    [self addSkipBackupAttributeToItemAtURL:pathURL];
            }
            
        }
    }
    
    [ResourceHelper setUserDefaults:@"1" forKey:@"installed"];
    
}
//BOOL success;
//NSError *error;
//NSFileManager *fm = [NSFileManager defaultManager];
//NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsDirectory = [paths objectAtIndex:0];
////NSLog(@"%@",documentsDirectory);
//NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
////	NSLog(@"数据库地址:%@",writableDBPath);
////不备份到icloud
//
//
//success = [fm fileExistsAtPath:writableDBPath];
//
////如果document下没有这个数据库，去根目录拷贝一分
//if(!success){
//    NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:dbName];
//    //NSLog(@"%@",defaultDBPath);
//    success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//    if(!success){
//        //			NSLog(@"error: %@", [error localizedDescription]);
//        
//    }else{
//        NSURL *pathURL= [NSURL fileURLWithPath:writableDBPath];
//        [self addSkipBackupAttributeToItemAtURL:pathURL];
//    }
//    success = YES;
//}
+(void)writeWaiguoMingzhuBookFile{
    if([ResourceHelper getUserDefaults:@"installed"] == nil){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *cachesDir = [paths objectAtIndex:0];
        
        for (int i=16325; i<16402; i++) {
            NSString *fileDefaultPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"epub"];
            if (fileDefaultPath) {
                
                
                
                if ([fileManager copyItemAtPath:fileDefaultPath toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, [NSString stringWithFormat:@"%@.epub",[NSString stringWithFormat:@"%d",i]]] error:nil] == NO)
                {
                    
                    NSLog(@"1: %@",fileDefaultPath);
                    NSLog(@"2: %@",fileDefaultPath);
                    NSLog(@"书本写入Document完毕");
                }
                NSURL *pathURL= [NSURL fileURLWithPath:fileDefaultPath];
                [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                NSFileManager *filemanager=[[NSFileManager alloc] init];
                if ([filemanager fileExistsAtPath:fileDefaultPath]) {
                    NSError *error;
                    [filemanager removeItemAtPath:fileDefaultPath error:&error];
                }
                [filemanager release];
                //                    [self addSkipBackupAttributeToItemAtURL:pathURL];
            }
            
        }
    }
    
    [ResourceHelper setUserDefaults:@"1" forKey:@"installed"];
    
}
//初始化基础数据
+(void)initDatabaseInfo{
    //初始化分类
//    [[PenSoundDao sharedPenSoundDao]initClassInfo];
}


//静读天下
+(NSArray*)installStaticread{
    NSArray *bookArr = [NSArray arrayWithObjects:@"麦田里的守望者",
                        @"三体全集",
                        @"红与黑",  nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"麦田里的守望者",@"book_name",
                             @"0",@"book_price",
                             @"塞林格",@"book_author",
                             @"15",@"class_id",
                             @"",@"book_url",
                             @"http://img3.douban.com/lpic/s28000034.jpg",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"麦田里的守望者.epub",@"book_file",
                             @"-1",@"book_id",
                             @"1", @"book_down",
                             @"",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic2 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"三体",@"book_name",
                             @"0",@"book_price",
                             @"刘慈欣",@"book_author",
                             @"15",@"class_id",
                             @"",@"book_url",
                             @"http://img5.douban.com/mpic/s2865028.jpg",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"三体全集.epub",@"book_file",
                             @"-2",@"book_id",
                             @"1", @"book_down",
                             @"",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
//    NSDictionary *bookDic3 =[NSDictionary dictionaryWithObjectsAndKeys:
//                             @"乔布斯传",@"book_name",
//                             @"0",@"book_price",
//                             @"沃尔特·艾萨克森",@"book_author",
//                             @"15",@"class_id",
//                             @"",@"book_url",
//                             @"http://img5.douban.com/lpic/s11185789.jpg",@"book_doubanlogo",
//                             @"2014-04-03",@"book_time",
//                             @"乔布斯传.epub",@"book_file",
//                             @"-3",@"book_id",
//                             @"1", @"book_down",
//                             @"",@"book_introduction",
//                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic4 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"红与黑",@"book_name",
                             @"0",@"book_price",
                             @"司汤达",@"book_author",
                             @"15",@"class_id",
                             @"",@"book_url",
                             @"http://img3.douban.com/lpic/s2883820.jpg",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"红与黑.epub",@"book_file",
                             @"-4",@"book_id",
                             @"1", @"book_down",
                             @"",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    
    [self insertToDbInitSql:bookDic1];
    [self insertToDbInitSql:bookDic2];
//    [self insertToDbInitSql:bookDic3];
    [self insertToDbInitSql:bookDic4];
    return bookArr;
}


//冰与火之歌
+(NSArray*)installBingyuHUOzhige{
    NSArray *bookArr = [NSArray arrayWithObjects:NSLocalizedString(@"init_file", nil),
                        NSLocalizedString(@"init_file2", nil),
                        NSLocalizedString(@"init_file3", nil),
                        NSLocalizedString(@"init_file4", nil),
                        NSLocalizedString(@"init_file5", nil), nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"第一卷权力的游戏",@"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://pkg.gao7gao8.com/epub/logo/32.png",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"第一卷权力的游戏.epub",@"book_file",
                             @"-1",@"book_id",
                            @"1", @"book_down",
                             @"《冰与火之歌》( A Song of Ice and Fire )由美国著名科幻奇幻小说家乔治·R·R·马丁 ( George R.R. Martin )所著，是当代奇幻文学一部影响深远的里程碑式的作品。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic2 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"第二卷列王的纷争",@"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://pkg.gao7gao8.com/epub/logo/33.png",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"第二卷列王的纷争.epub",@"book_file",
                             @"-2",@"book_id",
                             @"1", @"book_down",
                             @"《冰与火之歌》( A Song of Ice and Fire )由美国著名科幻奇幻小说家乔治·R·R·马丁 ( George R.R. Martin )所著，是当代奇幻文学一部影响深远的里程碑式的作品。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic3 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"第三卷冰雨的风暴",@"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://pkg.gao7gao8.com/epub/logo/34.png",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"第三卷冰雨的风暴.epub",@"book_file",
                             @"-3",@"book_id",
                             @"1", @"book_down",
                             @"《冰与火之歌》( A Song of Ice and Fire )由美国著名科幻奇幻小说家乔治·R·R·马丁 ( George R.R. Martin )所著，是当代奇幻文学一部影响深远的里程碑式的作品。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic4 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"第四卷群鸦的盛宴",@"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://pkg.gao7gao8.com/epub/logo/35.png",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"第四卷群鸦的盛宴.epub",@"book_file",
                             @"-4",@"book_id",
                             @"1", @"book_down",
                             @"《冰与火之歌》( A Song of Ice and Fire )由美国著名科幻奇幻小说家乔治·R·R·马丁 ( George R.R. Martin )所著，是当代奇幻文学一部影响深远的里程碑式的作品。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    NSDictionary *bookDic5 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"第五卷魔龙的狂舞",@"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://pkg.gao7gao8.com/epub/logo/36.png",@"book_doubanlogo",
                             @"2014-04-03",@"book_time",
                             @"第五卷魔龙的狂舞.epub",@"book_file",
                             @"0",@"book_id",
                             @"1", @"book_down",
                             @"《冰与火之歌》( A Song of Ice and Fire )由美国著名科幻奇幻小说家乔治·R·R·马丁 ( George R.R. Martin )所著，是当代奇幻文学一部影响深远的里程碑式的作品。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    [self insertToDbInitSql:bookDic2];
    [self insertToDbInitSql:bookDic3];
    [self insertToDbInitSql:bookDic4];
    [self insertToDbInitSql:bookDic5];
    
    return bookArr;
}

//诗经
+(NSArray*)installSHIJING{
    
    NSArray *bookArr = [NSArray arrayWithObjects:NSLocalizedString(@"init_file7", nil), nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"权利的游戏", @"book_name",
                             @"0",@"book_price",
                             @"乔治·R·R·马丁",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"权利的游戏.jpg",@"book_coverurl",
                             @"2014-04-03",@"book_time",
                             @"权利的游戏.epub",@"book_file",
                             @"0",@"book_id",
                             @"1",@"book_down",
                             @"它是我国第一部诗歌总集，共收入自西周初年至春秋中期大约五百多年的诗歌三百零五篇，共分风（160篇）、雅（105篇）、颂（40篇）三大部分。它们都得名于音乐。“风”的意义就是声调。古人所谓《秦风》、《魏风》、《郑风》，就如现在我们说陕西调、山西调、河南调、“雅”是正的意思。周代人把正声叫做雅乐，犹如清代人把昆腔叫做雅部，带有一种尊崇的意味。大雅小雅可能是根据年代先后而分的。“颂”是用于宗庙祭的乐歌。 ",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    return bookArr;
}

+(void)createNewBook:(NSString *)fileName{
    
     NSString *timeSpFile = [NSString stringWithFormat:@"%ld", -(long)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             fileName, @"book_name",
                             @"0",@"book_price",
                             @"",@"book_author",
                             bookClass,@"class_id",
                             @"",@"book_url",
                             @"诗经.png",@"book_coverurl",
                             @"2014-04-03",@"book_time",
                             fileName,@"book_file",
                             timeSpFile,@"book_id",
                             @"1",@"book_down",
                             @"",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    
}

//佛经
+(NSArray*)installFOJING{
    
    NSArray *bookArr = [NSArray arrayWithObjects:NSLocalizedString(@"init_file9", nil), nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             NSLocalizedString(@"init_file9", nil), @"book_name",
                             @"0",@"book_price",
                             @"",@"book_author",
                             @"7",@"class_id",
                             @"",@"book_url",
                             @"心经.png",@"book_coverurl",
                             @"2014-04-03",@"book_time",
                            [NSString stringWithFormat:@"%@.epub",NSLocalizedString(@"init_file9", nil)],@"book_file",
                             @"0",@"book_id",
                             @"1",@"book_down",
                             @"这个世界上的眼见,耳闻,吃穿住用,全是污染,是毒,学佛经法,可以疗毒。可以得解脱,可以活的更自在.",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    return bookArr;
}

//韩非子
+(NSArray*)installHANFEIZI{
    
    NSArray *bookArr = [NSArray arrayWithObjects:NSLocalizedString(@"init_file8", nil), nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                             @"韩非子", @"book_name",
                             @"0",@"book_price",
                             @"诗歌",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"韩非子.png",@"book_coverurl",
                             @"2014-04-03",@"book_time",
                             @"韩非子.epub",@"book_file",
                             @"0",@"book_id",
                             @"1",@"book_down",
                             @"韩非子的文章构思精巧，描写大胆，语言幽默，于平实中见奇妙，具有耐人寻味、警策世人的艺术风格。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    return bookArr;
}



//魔女天骄美人痣
+(NSArray*)installMNTJMRZ{
    NSArray *bookArr = [NSArray arrayWithObjects:NSLocalizedString(@"init_file6", nil), nil];
    
    NSDictionary *bookDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                            @"魔女天骄美人志", @"book_name",
                             @"0",@"book_price",
                             @"潜龙",@"book_author",
                             @"3",@"class_id",
                             @"",@"book_url",
                             @"http://bcs.duapp.com/book-one/xiaoshuo/logo/monvtianjiaomeirenzhi.png?sign=MBO:loIvSIXhSUejypUlac2j1jm8:qj3bL81xZXsM4A13NDwYWqJCJEQ%3D&response-cache-control=private",@"book_coverurl",
                             @"2014-04-03",@"book_time",
                             @"魔女天骄美人志.epub",@"book_file",
                             @"0",@"book_id",
                             @"1",@"book_down",
                             @"一个平凡的小子，在痛苦和奇遇的机缘下，骤然改变了他的一生，成为武林中超轶绝尘，独袖一枝的人物。",@"book_introduction",
                             @"0.9mb",@"book_size",nil];
    [self insertToDbInitSql:bookDic1];
    return bookArr;
}


+(void)initClassid:(NSString*)classId name:(NSString*)classname book:(NSString*)classbook logo:(NSString*)classlogo time:(NSString*)classtime url:(NSString*)classurl url2:(NSString*)classurl2{
    NSDictionary *classDic1 =[NSDictionary dictionaryWithObjectsAndKeys:
                              classId,@"class_id",
                              classname,@"class_name",
                              classbook,@"class_book",
                              classlogo,@"class_logo",
                              classtime,@"class_time",
                              classurl,@"class_url",
                              classurl2,@"class_url2",
                              nil];
    [self installToDbInitClass:classDic1];
}

+(void)installToDbInitClass:(NSDictionary*)dic{
    ClassData *bookdata5 = [ClassData initWithDictionary:dic];
    [bookdata5 saveSelfToDB];
    bookdata5 = nil;
}

+(void)insertToDbInitSql:(NSDictionary*)dic{
    BookData *bookdata5 = [BookData initWithDictionary:dic];
    [bookdata5 saveSelfToDB];
    bookdata5 = nil;
}
@end
