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

@interface ABActivateKeyboardGestureRecognizer ()

@property float start;

@end

@implementation ABActivateKeyboardGestureRecognizer {
    NSArray *allTouchesStart;
    NSArray *allTouchesCurrent;
}

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        allTouchesStart = @[];
        allTouchesCurrent = @[];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    allTouchesStart = [NSArray addToArray:allTouchesStart from:[touches allObjects] inView:self.view];
    _start = [[touches anyObject] locationInView:self.view].y;
    if (allTouchesStart.count > 6) {
        self.state = UIGestureRecognizerStateFailed;
    }
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
    // Don't run if gesture not propery recognized
    if (allTouchesStart.count != 6) { return; }
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
       
    NSLog(@"%@", [allTouchesStart oneLineNSStringOfArrayWithDescriptionBlock:^NSString *(id obj) {
        return [NSString stringWithFormat:@"%f", [(UITouch *)obj locationInView:self.view].y];
    }]);
    
    // If valid set as valid - incomp
    if (allTouchesStart[0] == 0) {
        info[ABGestureInfoStatus] = @0; // False
    } else {
        info[ABGestureInfoStatus] = @1; // True
    }
    
    if ([_touchDelegate respondsToSelector:@selector(touchColumnsWithInfo:)]) {
        [_touchDelegate touchColumnsWithInfo:info];
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
    allTouchesStart = @[];
    _start = 0;
    _translationFromStart = 0;
    NSLog(@"Reset");
}

@end
