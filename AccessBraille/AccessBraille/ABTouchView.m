//
//  ABTouchView.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/5/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTouchView.h"

@implementation ABTouchView {
    CGPoint currentTouch;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(context, 0, currentTouch.y);
    CGContextAddLineToPoint(context, self.bounds.size.width, currentTouch.y);
    
    CGContextMoveToPoint(context, currentTouch.x, 0);
    CGContextAddLineToPoint(context, currentTouch.x, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

/**
 * GR target
 */
- (void)tapped:(UITapGestureRecognizer *)reg {
    // Check if space
    currentTouch = [reg locationInView:self];
    float touchY = [_delegate locationInDelegate:reg].y;
    float avgY = [_delegate averageY];
    if (touchY > avgY + 150) {
        [_delegate space];
    } else {
        [_delegate updateYAverage:touchY];
        [_delegate touchWithId:self.tag tap:YES];
    }
    [self setNeedsDisplay];
}

@end
