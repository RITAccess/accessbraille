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
#import "ABBrailleReader.h"

@implementation ABTouchLayer {
    
    /* Reading Input */
    NSMutableArray *activeTouches;
    BOOL reading;
    /* Backspace/Space */
    UITapGestureRecognizer *screenTap;
    
    /* Avg tracking */
    float farX;
    float avgY;
    int totalY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        activeTouches = [[NSMutableArray alloc] initWithCapacity:6];
        screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveScreenTap:)];
        [self addGestureRecognizer:screenTap];
        reading = NO;
        
        // Init avgs
        avgY = 550;
        farX = 760;
        totalY = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(context, 0, avgY);
    CGContextAddLineToPoint(context, 1024, avgY);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(context, 0, avgY + 100);
    CGContextAddLineToPoint(context, 1024, avgY + 100);
    
    CGContextStrokePath(context);
    
    for (ABTouchView *subview in self.subviews) {
        if ([subview isKindOfClass:[ABTouchView class]]) {
            CGRect frame = subview.frame;
            frame.size.height = avgY + 100;
            [subview setFrame:frame];
        }
    }
    
    
}

/**
 * Called when sub Views Have Been Added
 */
- (void)subViewsAdded {
    for (UIView *sv in self.subviews) {
        if (sv.tag == 5) {
            farX = sv.frame.origin.x + sv.frame.size.width;
        }
    }
}

/**
 * Returns the point of the tap in this view
 */
- (CGPoint)locationInDelegate:(UITapGestureRecognizer *)reg {
    return [reg locationInView:self];
}

/**
 * returns the average Y tap
 */
- (float)averageY {
    return avgY;
}

/**
 * Updates the Y average for touch points
 */
- (void)updateYAverage:(float)newPoint {
    if (totalY == 0) {
        avgY = newPoint;
    } else {
        avgY = ((avgY * totalY) + newPoint) / ++totalY;
    }
    
    [self setNeedsDisplay];
}

/**
 * Removes all subviews from view and resets tracking.
 */
- (void)resetView {
    totalY = 0;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

/**
 * Space was called
 */
- (void)space {
    [_delegate characterReceived:ABSpaceCharacter];
}

/**
 * Backspace was called
 */
- (void)backspace {
    [_delegate characterReceived:ABBackspace];
}

/**
 * receives taps from anywhere on the screen when keyboard is active.
 */
- (void)receiveScreenTap:(UITapGestureRecognizer *)reg {
    if ([reg locationInView:self].x > farX) {
        [self backspace];
    } else if ([reg locationInView:self].y > (avgY + 70 + _ajt) && [reg locationInView:self].x < farX) {
        [self space];
    }
}

/**
 * Reciever for taps from touch views
 */
- (void)touchWithId:(NSInteger)tapID tap:(BOOL)tapped {
    if (tapped) {
        if (!reading) {
            [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(readBits) userInfo:nil repeats:NO];
            reading = YES;
        }
        [activeTouches addObject:@(tapID)];
    }
}

- (void)readBits {
    reading = NO;
    if ([_delegate respondsToSelector:@selector(characterReceived:)]) {
        [_delegate characterReceived:[ABBrailleReader brailleStringFromTouchIDs:activeTouches]];
    }
    [activeTouches removeAllObjects];
}

@end
