//
//  NavigationContainer.h
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBezelGestureRecognizer.h"

@interface NavigationContainer : UIViewController

- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)menu;

@property (strong, nonatomic) UIBezelGestureRecognizer *leftSideSwipe;
@property (strong, nonatomic) UIPanGestureRecognizer *menuTrav;

@end
