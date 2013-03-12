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
    
    for (UITouch *tap in touches) {
        if ([tap locationInView:self.view].y < 200) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    
}

@end
