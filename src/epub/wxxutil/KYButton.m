//
//  KYButton.m
//  UIBezierPathSymbol_Demo
//
//  Created by Kjuly on 8/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYButton.h"
#import "BlackView.h"
@implementation KYButton

@synthesize color;
@synthesize scale, thick;

- (void)dealloc {
  self.color = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
       [self addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
} 
-(void)touchBtn{
    [BlackView scaleAnimation:self];
    [self sendObject:@""];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  if (self.color == nil) [[UIColor whiteColor] setFill];
  else [self.color setFill];
}

- (void)showActivity {
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)]; // I do this because I'm in landscape mode
	// spinner is not visible until started
	[self addSubview:spinner];
	[spinner release];
}

- (void) startSpinner {
	[spinner startAnimating];
}

- (void) stopSpinner {
	[spinner stopAnimating];
}

@end
