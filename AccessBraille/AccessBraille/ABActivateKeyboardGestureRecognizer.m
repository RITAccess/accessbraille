//
//  ABActivateKeyboardGestureRecognizer.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABActivateKeyboardGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ABActivateKeyboardGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"a.%d", [touches count]);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"b.%d", [touches count]);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}



- (void)reset {
    NSLog(@"Reset");
}

@end
