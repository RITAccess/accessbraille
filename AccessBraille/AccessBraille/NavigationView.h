//
//  NavigationView.h
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationView : UIView

-(void)updateWithCGPoint:(CGPoint)touchLocation;
-(void)touchesEnd;
-(Boolean)isActive;

@end
