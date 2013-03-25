//
//  ABKeyboard.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//


#define ABLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "ABKeyboard.h"
#import "ABActivateKeyboardGestureRecognizer.h"

@implementation ABKeyboard {
    
}

- (id)init {
    self = [super init];
    if (self) {
        // Init code
    }
    return self;
}

/**
 * Returns status logs from ABKeyboard to delegate
 */
- (void)Log:(NSString *)str {
    if ([_delegate respondsToSelector:@selector(ABLog:)]) {
        [_delegate ABLog:str];
    }
}

- (void)ABKeyboardRecognized:(ABActivateKeyboardGestureRecognizer *)reg {
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            ABLog(@"%f", reg.translationFromStart);
            break;
        default:
            break;
    }
}

@end
