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

/**
 *  Called by system to draw view
 */
- (void)drawRect:(CGRect)rect {
    
    // Only draw is visible property is true
    if (_visible) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Size of highted area
        CGRect size = CGRectMake(0, (self.frame.size.height / 2) - 100, self.hightlightWidth, 200);
        // Coloring for highted bar
        UIColor *fillBox = [UIColor colorWithRed:225/255 green:0/255 blue:0/255 alpha:0.4];
        
        // Draw on screen
        CGContextSetFillColorWithColor(context, fillBox.CGColor);
        CGContextAddRect(context, size);
        CGContextFillPath(context);
    }
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
