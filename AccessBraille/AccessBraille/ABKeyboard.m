//
//  ABKeyboard.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

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

- (void)touchColumnsWithInfo:(NSDictionary *)info {
    if (info[@(ABColumnInfoValid)]) {
        
        NSLog(@"%@", info);
        
    }
}

- (void)ABKeyboardRecognized:(ABActivateKeyboardGestureRecognizer *)reg {
    switch (reg.activateDirection) {
        case ABGestureDirectionUP:
            
            if (reg.translationFromStart > 200) {
                [reg stopGesture];
            }
            
            break;
        case ABGestureDirectionDOWN:
            
            if (reg.translationFromStart > 200) {
                NSLog(@"Keyboard Deactivate");
            }
            
            break;
        default:
            break;
    }
}

@end
