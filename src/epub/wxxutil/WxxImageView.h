//
//  WxxImageView.h
//  driftbottle
//
//  Created by weng xiangxun on 13-8-12.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WxxImageView : UIImageView{
    
    void(^_downLoadFinish)(CGSize size);
    
}
@property (nonatomic,strong)NSURL *url2;
- (id)initWithFrame:(CGRect)frame imgUrl:(NSString*)imgurl downImageFinish:(void(^)(CGSize size))function;
-(void)setImageWithUrlString:(NSString*)urlstr;
-(void)resetFrame:(CGRect)rect;
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;
-(void)setImageWithUrlString:(NSString *)imgurl downImageFinish:(void(^)(CGSize))function;
@end
