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

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)reset{
    
}


@end
