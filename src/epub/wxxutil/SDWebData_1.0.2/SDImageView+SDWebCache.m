//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
#import "UIImageView+Curled.h"
#import "ResourceHelper.h"
#import <objc/runtime.h>
static const void *Url2Key = &Url2Key;
static const void *ynUseUrl2Key = &ynUseUrl2Key;
@implementation UIImageView(SDWebCacheCategory)
@dynamic url2;@dynamic ynUseUrl2;

- (NSURL*)url2{
    return objc_getAssociatedObject(self, Url2Key);
}
- (void)setUrl2:(NSURL *)url2{
    objc_setAssociatedObject(self, Url2Key, url2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ynUseUrl2 {
    return [objc_getAssociatedObject(self, ynUseUrl2Key) boolValue];
}
- (void)setYnUseUrl2:(BOOL)ynUseUrl2{
    objc_setAssociatedObject(self, ynUseUrl2Key, [NSNumber numberWithFloat:ynUseUrl2], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//**************以上是附加属性**********//

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url refreshCache:YES];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
//    [manager cancelForDelegate:self];
	
    self.image = placeholder;
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self refreshCache:refreshCache];
    }
}

- (void)setImageWithURL:(NSURL *)url url2:(NSURL *)url2arg refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    [self setYnUseUrl2:NO];//是否使用了url2
	[self setUrl2:url2arg];
    self.image = placeholder;
	
    if (url)
    {
        [manager downloadWithURL:url url2:url2arg delegate:self refreshCache:refreshCache];
//        [manager downloadWithURL:url delegate:self refreshCache:refreshCache];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebDataManager sharedManager] cancelForDelegate:self];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache url2:(NSURL*)url2{
    if (self.url2) {
        if ([aData length]<400) {
            //如果url2为被使用过，使用一次
            if (![self ynUseUrl2]) {
                NSURL *url22 = self.url2;
                [self setYnUseUrl2:YES];
                [self setImageWithURL:[url22 retain] refreshCache:NO placeholderImage:[ResourceHelper loadImageByTheme:@"cellImgBack"]];
            }
            
        }else{
            UIImage *img=[UIImage imageWithData:aData];
            self.image=img;
        }

    }else{
        UIImage *img=[UIImage imageWithData:aData];
        if (img) {
        self.image=img;
        }

    }
	
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
//NSLog(@"%d",[aData length]);
	UIImage *img=[UIImage imageWithData:aData];
    self.image=img;
   // [self setImage:img borderWidth:(CGRectGetWidth(self.frame)-img.size.width)/2 shadowDepth:5.0 controlPointXOffset:100.0 controlPointYOffset:20];

}

@end
