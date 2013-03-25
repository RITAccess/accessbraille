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
            self.state = UIGestureRecognizerStateBegan;
            _start = [(UITouch *)sortedTouchPoints[0] locationInView:self.view].y;
            started = YES;
        }
        
        if (([(UITouch *)sortedTouchPoints[4] previousLocationInView:self.view].y - [(UITouch *)sortedTouchPoints[4] locationInView:self.view].y) > 0){
            self.activateDirection = ABGestureDirectionUP;
        } else {
            self.activateDirection = ABGestureDirectionDOWN;
        }
        
        _translationFromStart = ABS(_start - [(UITouch *)sortedTouchPoints[4] previousLocationInView:self.view].y);
        
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
