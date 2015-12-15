//
//  BookData.m
//  epub
//
//  Created by weng xiangxun on 14-3-8.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BookData.h"
#import "EVCircularProgressView.h"
#import "SVHTTPRequest.h"
#import "WxxAlertView.h"
#import "ClassData.h"
#import "WxxIapStore.h"
@implementation BookData
-(void)dealloc{
    if (_progressView) {
        [_progressView release];
    }
    [_bbook_downloadtime release];
    [_bbook_new release];
    [_bbook_url release];
    [_bbook_introduction release];
    [_bbook_time release];
    [_bbook_price release];
    [_bbook_name release];
    [_bbook_file release];
    [_bbook_coverurl release];
    [_bbook_author release];
    [_bclass_id release];
    [_bbook_id release];
    [_bbook_down release];
    [_bbook_size release];
    [_bbook_doubanlogo release];
    [_bbook_local release];
    [super dealloc];
}

///* *** **
// * The Base64Transcoder library is the work of Jonathan Wright,
// * available at http://code.google.com/p/oauth/.
// * *** **
// */
//- (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
//    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[20];
//	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
//    
//    char base64Result[32];
//    size_t theResultLength = 32;
//    Base64EncodeData(result, 20, base64Result, &theResultLength);
//    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
//   
//    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
//    
//    return base64EncodedResult;
//}


-(void)downFile{
    self.downType = downing;  //状态改为下载中
    [WxxIapStore sharedWxxIapStore].ynDown = true;//标示为正在下载
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *timeSpFile = [NSString stringWithFormat:@"%ld.file", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:timeSpFile];
    self.bbook_file =timeSpFile;
    [self saveSelfToDB];
//    [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:writableDBPath];
    //延迟执行
    double delayInSeconds = 2.0;
//    [self.progressView showDownloadingBefor]; //下载之前的转圈
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"gao7下载");
                    
                    
//                    NSString *timeinter = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//                    
//                    
//                    NSString * DownloadUrl = [NSString stringWithFormat:@"http://my-bucket.qiniu.com/sunflower.jpg?e=%@",timeinter];
//                    
////
//                    hmac_sha1(DownloadUrl, "123");
//                    EncodedSign = urlsafe_base64_encode(Sign)
                    
                    //****下载开始****//
                    [SVHTTPRequest GET:[[ClassData sharedClassData]getgao7gao8BookPrefix:self.bbook_id]  //下载url
                            parameters:nil
                            saveToPath:writableDBPath
                              progress:^(float progress) {
                                  //下载进度条
                                  [self.progressView setProgress:progress  animated:YES];
                              }completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                                  
                                  
                                  
                                  //读取判断刚下载的文件是否正常，如果是返回404，503等写入文件就是错误的。
                                  NSFileManager *fm  = [NSFileManager defaultManager];
                                  NSError *errorfile = nil;
                                  NSDictionary* dictFile = [[fm attributesOfItemAtPath:writableDBPath error:&errorfile] retain];
                                  long nFileSize = [dictFile fileSize]; //得到文件大小
                                  [dictFile release];
                                  //如果文件小于1024字节，用第二连接下载
                                  if (error || nFileSize < 1024) {
                                      //NSLog(@"开始用第二连接下载%@:%@",self.bbook_name,[[ClassData sharedClassData]getBookPrefix:self.bbook_url]);
                                      //********************************第一连接下载无效，采用第二连接***********************************************************//
                                      [SVHTTPRequest GET:[[ClassData sharedClassData]getBookPrefix:self.bbook_url]  //下载url2
                                              parameters:nil
                                              saveToPath:writableDBPath
                                                progress:^(float progress) {
                                                    [self.progressView setProgress:progress  animated:YES];
                                                }completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                    if (error) {
                                                        [[WxxPopView sharedInstance] showPopText:@"下载错误，请联系开发者"];
//                                                        [[WxxAlertView sharedInstance]showWithTextWithTime:@"下载错误，请联系开发者"];
                                                        [self.progressView reHeal];
                                                        self.downType = downbefor;
                                                    }else{
                                                        showAlert(@"提示", @"下载完成，已放到｜我的书架｜");
//                                                        [[WxxPopView sharedInstance]showPopText:@"下载完成，已放到｜我的书架｜"];
                                                        [WxxIapStore sharedWxxIapStore].ynDown = false;
                                                        self.bbook_down = @"1";
                                                        [self updateSelf];
                                                        self.downType = downafter;
                                                        NSURL *pathURL= [NSURL fileURLWithPath:writableDBPath];
                                                        [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                                                    }
                                                }];
                                      //********************************第一连接下载无效，采用第二连接***********************************************************//
                                  }else{
                                      //**********下载完毕做的事情在这里****************
                                      //NSLog(@"保存：：：：：%@----",self.bbook_name );
                                      [WxxIapStore sharedWxxIapStore].ynDown = false;
                                      showAlert(@"提示", @"下载完成，已放到｜我的书架｜");
//                                      [[WxxPopView sharedInstance]showPopText:@"下载完成，已放到｜我的书架｜"];
                                      self.bbook_down = @"1";
                                      [self updateSelf]; //更新为下载完毕
                                      self.downType = downafter;//下载完毕状态改为下载完
                                      NSURL *pathURL= [NSURL fileURLWithPath:writableDBPath];
                                      [[PenSoundDao sharedPenSoundDao]addSkipBackupAttributeToItemAtURL:pathURL];
                                      
                                  }
                            }];//****下载结束****//
    });
}

//-(void)setBbook_file:(NSString *)bbook_file{
//    _bbook_file = [[SecurityUtil encodeBase64String:bbook_file] retain];
//}
//-(NSString*)getBook_file{
//    return [SecurityUtil decodeBase64String:self.bbook_file];
//}

-(EVCircularProgressView *)initProgreddView:(NSString *)priceStr{
    self.progressView = [[[EVCircularProgressView alloc]initWithText:priceStr] autorelease];
    self.progressView.layer.cornerRadius = 4;
    return self.progressView;
}

+ (id)initWithDictionary:(NSDictionary*)dic{
    BookData *dbbdata = [[[BookData alloc] initWithDictionary:dic] autorelease];
    return dbbdata;
}

- (id)initWithDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.bbook_url   = [dic objectForKey:book_url];
        self.bbook_time     = [dic objectForKey:book_time];
        self.bbook_price        = [dic objectForKey:book_price];
        self.bbook_name      = [dic objectForKey:book_name];
        self.bbook_file       = [dic objectForKey:book_file];
        self.bbook_coverurl  = [dic objectForKey:book_coverurl];
        self.bbook_author = [dic objectForKey:book_author];
        self.bclass_id    = [dic objectForKey:class_id];
        self.bbook_id    = [dic objectForKey:book_id];
        self.bbook_size = [dic objectForKey:book_size];
        self.bbook_doubanlogo = [dic objectForKey:book_doubanlogo];
        if ([dic objectForKey:book_down]) {
            self.bbook_down = [dic objectForKey:book_down];
        }else{
            self.bbook_down = @"0";
        }
        if ([dic objectForKey:book_new]) {
            self.bbook_new = [dic objectForKey:book_new];
        }else{
            self.bbook_new = @"1"; //默认为1，  新书
        }
        self.bbook_local = @"0";
        self.bbook_introduction = [dic objectForKey:book_introduction];
        
    }
    return self;
}

-(void)setBbook_file:(NSString *)bbook_file{
    if (!bbook_file) {
        _bbook_file = @"";
    }else{
        _bbook_file = [bbook_file retain];
    }
    
}

-(void)updateSelf{
    
    [[PenSoundDao sharedPenSoundDao] updateBookData:self];
}

-(void)updateBookDataByServer{
    
    [[PenSoundDao sharedPenSoundDao]updateBookDataByServer:self];
}

-(void)updateBook_newTo0{
    
    [[PenSoundDao sharedPenSoundDao] updateBookData:self.bbook_id book_newarg:@"0"];
}

//保存本实体到本地
-(void)saveSelfToDB{

    [[PenSoundDao sharedPenSoundDao]saveBook:self];
}
@end
