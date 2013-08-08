//
//  ABTouchView.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/5/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTouchView.h"

#define SHOWLINES 0

@implementation ABTouchView {
    CGPoint currentTouch;
    BOOL touched;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        touched = false;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
#if SHOWLINES
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(context, 0, currentTouch.y);
    CGContextAddLineToPoint(context, self.bounds.size.width, currentTouch.y);
    
    CGContextMoveToPoint(context, currentTouch.x, 0);
    CGContextAddLineToPoint(context, currentTouch.x, self.bounds.size.height);
    
    CGContextStrokePath(context);
#endif
    
    if (!touched) {
        [self setBackgroundColor:[UIColor blueColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touched = YES;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesCancelled:nil withEvent:nil];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    touched = NO;
    [self setNeedsDisplay];
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
