//
//  ABKeyboard.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABKeyboard.h"
#import "ABActivateKeyboardGestureRecognizer.h"
#import "ABTouchLayer.h"
#import "ABTypes.h"
#import "ABTouchView.h"
#import "ABBrailleReader.h"

@implementation ABKeyboard {
    ABTouchLayer *interface;
    ABBrailleReader *brailleReader;
}

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        // GR setup
        _delegate = delegate;
        ABActivateKeyboardGestureRecognizer *activate = [[ABActivateKeyboardGestureRecognizer alloc] initWithTarget:self action:@selector(ABKeyboardRecognized:)];
        [activate setTouchDelegate:self];
        [((UIViewController *)_delegate).view addGestureRecognizer:activate];

        // Enable the keyboard
        _enabled = YES;
        
        // Set Up Braille Interp
        brailleReader = [[ABBrailleReader alloc] init];
        [brailleReader setDelegate:_delegate];
        
        // Type interface setup
        interface = [[ABTouchLayer alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)]; // Hight/Width switched
        [interface setBackgroundColor:[UIColor grayColor]];
        [interface setAlpha:0.4];
        [interface setDelegate:brailleReader];
        
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
- (void)setUpViewWithTouchesFromABVectorArray:(ABVector[])vectors {
    
    // Call Drawing Methods
    
    for (int i = 0; i < 6; i++){
        
        ABTouchView *touch = [[ABTouchView alloc] initWithFrame:CGRectMake(vectors[i].end.x - 50, vectors[i].end.y, 100, 400)];
        [touch setBackgroundColor:[UIColor redColor]];
        [touch setTag:i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:touch action:@selector(tapped:)];
        
        [touch addGestureRecognizer:tap];
        
        [touch setDelegate:interface];
        
        [interface addSubview:touch];
    }
    [interface subViewsAdded];
}

/**
 * Gets touch colums from GR
 */
- (void)touchColumns:(ABVector[])vectors withInfo:(NSDictionary *)info{
    
    _keyboardActive = YES;
    
    [self setUpViewWithTouchesFromABVectorArray:vectors];
    
    UIViewController *VCDelegate = (UIViewController *)_delegate;
    [VCDelegate.view addSubview:interface];
    [VCDelegate.view bringSubviewToFront:interface];
    
}

/**
 * recieving end to activation gestures
 */
- (void)ABKeyboardRecognized:(ABActivateKeyboardGestureRecognizer *)reg {
    if (!_enabled) { return; }
    switch (reg.activateDirection) {
        case ABGestureDirectionUP:
            
            if (reg.translationFromStart > 200) {
                [reg getTouchInfo];
            }
            
            break;
        case ABGestureDirectionDOWN:
            
            if (reg.translationFromStart > 200) {
                [interface removeFromSuperview];
                [interface resetView];
                _keyboardActive = NO;
            }
            
            break;
        default:
            break;
    }
}

@end
