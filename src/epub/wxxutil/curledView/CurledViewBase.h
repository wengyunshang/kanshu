//
//  CurledViewBase.h
//  curledViews
//
//  Created by Ryan Kelly on 2/9/12.
//  Copyright (c) 2012 Remote Vision, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
/**
 
 使用方式
 
 // configure images and border for a Custom UIButton
 [photoButton setContentMode:UIViewContentModeScaleToFill];
 [photoButton setImage:[UIImage imageNamed:@"raptor_face.png"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
 [photoButton setImage:[UIImage imageNamed:@"stegasaurus_face.png"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateHighlighted];
 
 
 // configure images and border for a UIImageView
 [photoImageView setContentMode:UIViewContentModeScaleToFill];
 [photoImageView setImage:[UIImage imageNamed:@"stegasaurus_face.png"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0];
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CurledViewBase : NSObject

+(UIImage*)rescaleImage:(UIImage*)image forView:(UIView*)view;
+(UIBezierPath*)curlShadowPathWithShadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset forView:(UIView*)view;
@end
