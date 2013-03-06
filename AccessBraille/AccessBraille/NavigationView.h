//
//  NavigationView.h
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationContainer.h"

@protocol NavigationDelegate
@required

- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)menu;

@end

@interface NavigationView : UIView

@property (weak) id delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)updateWithCGPoint:(CGPoint)touchLocation;
-(void)updateMenuWithCGPoint:(CGPoint)touchLocation;
-(void)setStartNavigation;
-(void)close;

@end
