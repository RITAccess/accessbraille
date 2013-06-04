//
//  SidebarViewController.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/23/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController

/* Scrolls the menu items */
- (void)moveMenuItems:(UIPanGestureRecognizer *)reg;

/* Menu State */
@property (nonatomic) BOOL menuOpen;

@end
