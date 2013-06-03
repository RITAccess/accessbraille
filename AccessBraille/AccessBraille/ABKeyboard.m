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
#import "ABSpeak.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation ABKeyboard {
    ABTouchLayer *interface;
    ABBrailleReader *brailleReader;
    // Audio
    SystemSoundID enabledSound;
    SystemSoundID disabledSound;
    SystemSoundID backspaceSound;
    ABSpeak *speak;
}

#pragma mark Setup

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
        brailleReader = [[ABBrailleReader alloc] initWithAudioTarget:self selector:@selector(playSound:)];
        [brailleReader setDelegate:_delegate];
        
        // Type interface setup
        interface = [[ABTouchLayer alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
        [interface setBackgroundColor:[UIColor grayColor]];
        [interface setAlpha:0.4];
        [interface setDelegate:brailleReader];
        
        // Audio
        _sound = YES;
        enabledSound = [self createSoundID:@"hop.mp3"];
        disabledSound = [self createSoundID:@"disable.mp3"];
        backspaceSound = [self createSoundID:@"backspace.aiff"];
        
        speak = [[ABSpeak alloc] init];
        
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

#pragma mark Keyboard Implementation

/*
 * Ask the implementer to go into a typing state
 */
- (void)setActiveStateWithTarget:(id)target withSelector:(SEL)selector {
    _activeKeyboard = selector;
    _activeTarget = target;
}
- (void)setDectiveStateWithTarget:(id)target withSelector:(SEL)selector {
    _deactiveKeyboard = selector;
    _deactiveTarget = target;
}

/**
 * Creates a view overlay for recognizing braille type
 */
- (void)setUpViewWithTouchesFromABVectorArray:(ABVector[])vectors {
    
    // Call Drawing Methods
    
    //double angle = [self averageAngleFromVectors:vectors];
    
    for (int i = 0; i < 6; i++){
        
        ABTouchView *touch = [[ABTouchView alloc] initWithFrame:CGRectMake(vectors[i].end.x - 50, [UIScreen mainScreen].bounds.size.height, 100, 800)];
        [touch setTag:i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:touch action:@selector(tapped:)];
        [touch addGestureRecognizer:tap];
        [touch setDelegate:interface];
        
        [UIView animateWithDuration:.5 animations:^{
            [touch setFrame:CGRectMake(vectors[i].end.x - 50, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        }];
        
        // touch.transform = CGAffineTransformMakeRotation(angle);
        
        
        [interface addSubview:touch];
    }
    [interface subViewsAdded];
}

/**
 * Get average angle formed by columns
 */
- (double)averageAngleFromVectors:(ABVector[])vectors {
    float count = 0;
    for (int i = 0; i < 6; i++) {
        count += vectors[i].angle;
    }
    return (count / 6);
}

/**
 * Gets touch colums from GR
 */
- (void)touchColumns:(ABVector[])vectors withInfo:(NSDictionary *)info{
    
    _keyboardActive = YES;
    if ([_activeTarget respondsToSelector:_activeKeyboard]) {
        [_activeTarget performSelector:_activeKeyboard];
    }
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
                [self playSound:ABEnableSound];
            }
            
            break;
        case ABGestureDirectionDOWN:
            
            if (reg.translationFromStart > 150) {
                // Not quite working yet
                [UIView animateWithDuration:1.5 animations:^{
                    CGRect orig = interface.frame;
                    orig.origin.y += [UIScreen mainScreen].bounds.size.height;
                    [interface setFrame:orig];
                } completion:^(BOOL finished) {
                    [interface removeFromSuperview];
                    [self playSound:ABDisableSound];
                    [interface resetView];
                    CGRect orig = interface.frame;
                    orig.origin.y -= [UIScreen mainScreen].bounds.size.height;
                    [interface setFrame:orig];
                }];
                if ([_deactiveTarget respondsToSelector:_deactiveKeyboard]) {
                    [_deactiveTarget performSelector:_deactiveKeyboard];
                }
                _keyboardActive = NO;
            }
            
            break;
        default:
            break;
    }
}

#pragma mark args

- (void) setSpaceOffset:(int)spaceOffset {
    _spaceOffset = spaceOffset;
    [interface setAjt:spaceOffset];
}

#pragma mark Talk

- (void)startSpeakingString:(NSString *)string {
    NSLog(@"Will Speak: %@", string);
    [speak speakString:string];
}

#pragma mark Audio

- (void)playSound:(NSString *)type {
    if (!_sound) { return; }
    if ([type isEqualToString:ABBackspaceSound]){
        AudioServicesPlaySystemSound(backspaceSound);
    } else if ([type isEqualToString:ABEnableSound]) {
        AudioServicesPlaySystemSound(enabledSound);
    } else if ([type isEqualToString:ABDisableSound]) {
        AudioServicesPlaySystemSound(disabledSound);
    }
}

/**
 * Creates system sound
 */
- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
