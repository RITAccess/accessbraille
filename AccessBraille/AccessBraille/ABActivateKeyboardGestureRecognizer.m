//
//  ABActivateKeyboardGestureRecognizer.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABActivateKeyboardGestureRecognizer.h"
#import "NSArray+ObjectSubsets.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "ABTypes.h"
#import "ABKeyboard.h"

@interface ABActivateKeyboardGestureRecognizer ()

@property float start;

@end

@implementation ABActivateKeyboardGestureRecognizer {
    int allTouchesSize;
    CGPoint allTouchesStart[6];
    NSArray *allTouchesCurrent;
}

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        allTouchesSize = 0;
        allTouchesCurrent = @[];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (allTouchesSize > 6) {
        self.state = UIGestureRecognizerStateFailed;
    }
    for (UITouch *t in touches){
        allTouchesStart[allTouchesSize] = [t locationInView:self.view];
        allTouchesSize++;
    }
    _start = [[touches anyObject] locationInView:self.view].y;
}

/**
 * Sorts touch points in order from left to right
 */
- (NSArray *)sortTouchPoints:(NSSet *)touches {
    return [[touches allObjects] sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([(UITouch *)obj1 locationInView:self.view].x < [(UITouch *)obj2 locationInView:self.view].x) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 6){
        
        self.state = UIGestureRecognizerStateBegan;
        
        NSArray *sortedTouchPoints = [self sortTouchPoints:touches];
        
        // Check the direction of the gesture
        UITouch *test = [touches anyObject];
        if (([test previousLocationInView:self.view].y - [test locationInView:self.view].y) > 0){
            self.activateDirection = ABGestureDirectionUP;
        } else {
            self.activateDirection = ABGestureDirectionDOWN;
        }
        
        allTouchesCurrent = sortedTouchPoints;
        
        _translationFromStart = ABS(_start - [[touches anyObject] previousLocationInView:self.view].y);
        
    }
}

/**
 * Sets up touch regions
 */
- (void)getTouchInfo {
    // Don't run if gesture not propery recognized or if keyboard is active
    ABKeyboard *keyboard = (ABKeyboard *)_touchDelegate;
    if (keyboard.keyboardActive) { return; }
    
    // Info dictionary
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    // Put touch points into vectors to be used to set up columns later
    ABVector trackedVectors[6];
    for (int i = 0; i < 6; i++){
        ABVector tmp = ABVectorMake(allTouchesStart[i], [allTouchesCurrent[i] locationInView:self.view]);
        trackedVectors[i] = tmp;
    }
    
    info[ABGestureInfoStatus] = @0; // False
    
    
    if ([_touchDelegate respondsToSelector:@selector(touchColumns:withInfo:)]) {
        [_touchDelegate touchColumns:trackedVectors withInfo:info];
    }

    self.state = UIGestureRecognizerStateEnded;
}
                 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
}

- (void)reset {
    allTouchesCurrent = @[];
    allTouchesSize = 0;
    _start = 0;
    _translationFromStart = 0;
}

@end
