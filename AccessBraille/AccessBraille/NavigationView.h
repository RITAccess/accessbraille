//
//  NavigationView.h
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationContainer.h"

@interface NavigationView : UIView

-(id)initWithFrame:(CGRect)frame setSuper:(NavigationContainer *)superVC;
-(void)updateWithCGPoint:(CGPoint)touchLocation;
-(void)updateMenuWithCGPoint:(CGPoint)touchLocation;
-(void)setStartNavigation;
-(void)close;

@end
