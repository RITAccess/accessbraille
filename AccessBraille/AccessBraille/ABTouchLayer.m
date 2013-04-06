//
//  ABTouchLayer.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/4/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTouchLayer.h"
#import "ABTypes.h"
#import "ABTouchView.h"

@implementation ABTouchLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 * Removes all subviews from view
 */
- (void)resetView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

/**
 * Reciever for taps from touch views
 */
- (void)touchWithId:(NSInteger)tapID tap:(BOOL)tapped {
    
}


@end
