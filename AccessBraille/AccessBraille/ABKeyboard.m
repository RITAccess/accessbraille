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

/**
 * Gets touch colums from GR
 */
- (void)touchColumnsWithInfo:(NSDictionary *)info {
    NSLog(@"%@", [info[ABGestureInfoStatus] boolValue] ? @"Valid" : @"Invalid");
}

- (void)ABKeyboardRecognized:(ABActivateKeyboardGestureRecognizer *)reg {
    switch (reg.activateDirection) {
        case ABGestureDirectionUP:
            
            if (reg.translationFromStart > 200) {
                [reg getTouchInfo];
            }
            
            break;
        case ABGestureDirectionDOWN:
            
            if (reg.translationFromStart > 200) {
                
            }
            
            break;
        default:
            break;
    }
}

@end
