//
//  ABTouchView.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/5/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTouchView.h"

@implementation ABTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 * GR target
 */
- (void)tapped:(UITapGestureRecognizer *)reg {
    // Check if space
    float touchY = [_delegate locationInDelegate:reg].y;
    float avgY = [_delegate averageY];
    if (touchY > avgY + 75) {
        [_delegate space];
    } else {
        [_delegate updateYAverage:touchY];
        [_delegate touchWithId:self.tag tap:YES];
    }
}

@end
