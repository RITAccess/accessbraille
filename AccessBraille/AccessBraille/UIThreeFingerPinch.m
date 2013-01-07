//
//  UIThreeFingerPinch.m
//  AccessBraille
//
//  Created by Michael on 1/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "UIThreeFingerPinch.h"

@implementation UIThreeFingerPinch

-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if(self){
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    int numberOfTouches = event.allTouches.count;
    NSLog(@"TOUCHES BEGAN with %d", numberOfTouches);
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"TOUCHES MOVED");
    
//    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCHES ENDED");
//    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCHES CANCELLED");
//    [super touchesCancelled:touches withEvent:event];
}

@end
