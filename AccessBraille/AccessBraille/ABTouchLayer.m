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
        avgY = 450;
        farX = 760;
        
    }
    return self;
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
 * Removes all subviews from view and resets tracking.
 */
- (void)resetView {
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
 * receives taps from anywhere on the screen when keyboard is active.
 */
- (void)receiveScreenTap:(UITapGestureRecognizer *)reg {
    if ([reg locationInView:self].x > farX) {
        NSLog(@"Backspace");
    } else if ([reg locationInView:self].y > (avgY + 75) && [reg locationInView:self].x < farX) {
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
