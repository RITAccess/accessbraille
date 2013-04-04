//
//  ABKeyboard.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABKeyboard.h"
#import "ABActivateKeyboardGestureRecognizer.h"
#import "ABTypes.h"

@implementation ABKeyboard {
    
}

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        // Init code
        _delegate = delegate;
        ABActivateKeyboardGestureRecognizer *activate = [[ABActivateKeyboardGestureRecognizer alloc] initWithTarget:self action:@selector(ABKeyboardRecognized:)];
        [activate setTouchDelegate:self];
        [((UIViewController *)_delegate).view addGestureRecognizer:activate];

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
 * Creates a view overlay for recognizing braille type
 */
- (UIView *)viewWithTouchesFromABVectorArray:(ABVector[])vectors {
    
    // Set up overlay view
    UIView *interface = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [interface setBackgroundColor:[UIColor grayColor]];
    [interface setAlpha:0.4];
    
    // Test view
    
    
    
    return interface;
}

/**
 * Gets touch colums from GR
 */
- (void)touchColumns:(ABVector[])vectors withInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    NSLog(@"%@", ABVectorPrintable(vectors));
}

/**
 * recieving end to activation gestures
 */
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
