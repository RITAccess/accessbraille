//
//  ABActivateKeyboardGestureRecognizer.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABActivateKeyboardGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ABActivateKeyboardGestureRecognizer ()

@property float start;

@end

@implementation ABActivateKeyboardGestureRecognizer {
    BOOL started;
    NSArray *allTouchesStart;
    NSArray *allTouchesCurrent;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStatePossible;
    started = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 6){
        NSArray *sortedTouchPoints = [[touches allObjects] sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([(UITouch *)obj1 locationInView:self.view].x < [(UITouch *)obj2 locationInView:self.view].x) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        
        if (ABS(([(UITouch *)sortedTouchPoints[0] locationInView:self.view].y - [(UITouch *)sortedTouchPoints[5] locationInView:self.view].y)) <= 50 && !started) {
            NSLog(@"Called Once");
            self.state = UIGestureRecognizerStateBegan;
            allTouchesStart = [sortedTouchPoints copy];
            _start = [(UITouch *)sortedTouchPoints[0] locationInView:self.view].y;
            started = YES;
        }
        
        if (([(UITouch *)sortedTouchPoints[4] previousLocationInView:self.view].y - [(UITouch *)sortedTouchPoints[4] locationInView:self.view].y) > 0){
            self.activateDirection = ABGestureDirectionUP;
        } else {
            self.activateDirection = ABGestureDirectionDOWN;
        }
        allTouchesCurrent = sortedTouchPoints;
        _translationFromStart = ABS(_start - [(UITouch *)sortedTouchPoints[4] previousLocationInView:self.view].y);
        
    }
}

/**
 * Sets up touch regions
 */
- (void)stopGesture {
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[0] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[0] locationInView:self.view].y);
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[1] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[1] locationInView:self.view].y);
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[2] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[2] locationInView:self.view].y);
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[3] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[3] locationInView:self.view].y);
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[4] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[4] locationInView:self.view].y);
    NSLog(@"%f - %f", [(UITouch *)allTouchesStart[5] locationInView:self.view].y, [(UITouch *)allTouchesCurrent[5] locationInView:self.view].y);
    
    
    // If valid set as valid
    info[@(ABColumnInfoValid)] = @(YES);
    
    if ([_touchDelegate respondsToSelector:@selector(touchColumnsWithInfo:)]) {
        [_touchDelegate touchColumnsWithInfo:info];
    }

}
                 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
}

- (void)reset {
//    NSLog(@"Reset");
}

@end
