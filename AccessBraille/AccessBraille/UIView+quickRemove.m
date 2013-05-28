//
//  UIView+quickRemove.m
//  AccessBraille
//
//  Created by Michael Timbrook on 5/28/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "UIView+quickRemove.h"

@implementation UIView (quickRemove)

/**
 * Removes all subviews from a view
 */
- (void)removeSubviews {
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}

@end
