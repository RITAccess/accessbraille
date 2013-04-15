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
    
    NSMutableArray *activeTouches;
    BOOL reading;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        activeTouches = [[NSMutableArray alloc] initWithCapacity:6];
        reading = NO;
        
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
