//
//  MainMenuNavigation.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/15/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenuNavigation.h"

@implementation MainMenuNavigation

/**
 *  Sets the views background color to clear, and sets defaults for variables.
 */
- (void)makeClear {
    self.hightlightWidth = 750;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setVisible:(BOOL)visible {
    _visible = visible;
    if (visible) {
        [self.superview bringSubviewToFront:self];
    } else {
        [self.superview sendSubviewToBack:self];
    }
}

@end
