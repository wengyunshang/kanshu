//
//  RootViewController.h
//  IBooksOpen
//
//  Created by guo luchuan on 13-3-7.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookButton.h"

typedef enum {
    UIModalTransitionStyleOpenBooks = 0x01 << 7,

} UIModalTransitionStyleCustom;

@interface RootViewController : UIViewController
{
    @protected
    BookButton *_bookView;
    
}

//- (void)glcPresentViewController:(UIViewController *)viewController animated: (BOOL)animated completion:(void (^)(void))completion;
//
//- (void)glcDismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
