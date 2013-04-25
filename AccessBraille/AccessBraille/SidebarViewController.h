//
//  SidebarViewController.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/23/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController

/* Set menu position between 0 and 100, 100 being open */
- (void)updateMenuPosition:(float)position;

/* Menu State */
@property (nonatomic) BOOL menuOpen;

@end
