//
//  UIBezelGestureRecognizer.m
//  AccessBraille
//
//  Created by Michael on 1/10/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "UIBezelGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation UIBezelGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:target action:action];
    if (self) {
//        NSLog(@"Gesture Created - INIT");
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesBegan");
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
    CGPoint touch = [[touches anyObject] locationInView:self.view];
    if (touch.x > 8) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"TouchesMoved");
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
    self.state = UIGestureRecognizerStateChanged;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded");
    self.state = UIGestureRecognizerStateEnded;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesCancelled");
    self.state = UIGestureRecognizerStateFailed;
}

-(void)reset{
//    NSLog(@"Gesture reset");
}

@end
