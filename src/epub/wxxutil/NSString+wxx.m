//
//  NSString+wxx.m
//  driftbottle
//
//  Created by weng xiangxun on 13-8-18.
//  Copyright (c) 2013年 weng xiangxun. All rights reserved.
//

#import "NSString+wxx.h"

@implementation NSString (wxx)


-(void)test{
    
} 
//计算文本所占高度
//2个参数：宽度和文本内容
-(CGFloat)stringTextHeight:(CGFloat)widthInput Content:(NSString *)strContent font:(UIFont*)font{
    CGSize constraint = CGSizeMake(widthInput, MAXFLOAT);
//    CGSize size = [strContent sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    CGRect rect = CGRectZero;
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        rect = [self boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    }else{
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attrs];
        rect = [attributeString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        [attributeString release];
    }
    
    return rect.size.height;
}

//计算 宽度
-(CGFloat)stringTextWidthfont:(UIFont*)font{
    //    CGSize constraint = CGSizeMake(heightInput, heightInput);
    CGFloat constrainedSize = 26500.0f; //其他大小也行
//    CGSize size = [strContent sizeWithFont:font constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    CGRect rect = CGRectZero;
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        rect = [self boundingRectWithSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    }else{
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attrs];
        rect = [attributeString boundingRectWithSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        [attributeString release];
    }
    
//    return rect.size;
    
    //    CGFloat height = MAX(size.height, 44.0f);
    return rect.size.width;
}

//计算 宽度
-(CGSize)stringTextWidthFont:(UIFont*)font maxWidth:(CGFloat)maxWidth{
    //    CGSize constraint = CGSizeMake(heightInput, heightInput);
    //    CGFloat constrainedSize = 26500.0f; //其他大小也行
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    CGRect rect = CGRectZero;
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        rect = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    }else{
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attrs];
        rect = [attributeString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        [attributeString release];
    }
    
    return rect.size;
    
//    CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    //    CGFloat height = MAX(size.height, 44.0f);
//    return size;
}
@end
