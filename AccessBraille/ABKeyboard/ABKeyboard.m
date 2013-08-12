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
#import "ABSpeak.h"
#import "SettingsViewController.h"
#import "ABBrailleInterpreter.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ABKeyboard ()

@end

@implementation ABKeyboard
{
    ABTouchLayer *interface;
    ABBrailleInterpreter *_interpreter;
    
    __strong ABActivateKeyboardGestureRecognizer *activate;
    
    // Audio URL paths and AVPlayer.
    NSURL *enabledURL, *disabledURL, *backspaceURL;
    AVAudioPlayer *avPlayer;
    
    ABSpeak *speak;
    
    // Hold gestures
    NSArray *gestures;
}

#pragma mark Setup

- (id)init
{
    self = [super init];
    if (self) {
        // Enable the keyboard
        _enabled = YES;
        
        // Audio
        _sound = YES;
        
        enabledURL = [[NSBundle mainBundle] URLForResource:@"enableKeyboard" withExtension:@"aiff"];
        disabledURL = [[NSBundle mainBundle] URLForResource:@"disableKeyboard" withExtension:@"aiff"];
        backspaceURL = [[NSBundle mainBundle] URLForResource:@"backspace" withExtension:@"aiff"];
        
        speak = [ABSpeak sharedInstance];
    }
    return self;
}

- (id)initWithDelegate:(id)delegate {
    self = [self init];
    if (self) {
        // GR setup
        _delegate = delegate;
        activate = [[ABActivateKeyboardGestureRecognizer alloc] initWithTarget:self action:@selector(ABKeyboardRecognized:)];
        [activate setTouchDelegate:self];
        [((UIViewController *)_delegate).view addGestureRecognizer:activate];

    }
    return self;
}

- (void)setOutput:(UITextView *)output
{
    _output = output;
    [_output setInputView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
}

#pragma mark Responder Actions

- (void)newCharacterFromInterpreter:(NSString *)string
{
    // Update output text object
    [_output insertText:string];
    
    // Make delegate calls
    if ([_delegate respondsToSelector:@selector(characterTyped:withInfo:)]) {
        [_delegate characterTyped:string
                         withInfo:@{ABGestureInfoStatus : @(YES),
                                    ABSpaceTyped : @(NO),
                                    ABBackspaceReceived : @(NO)}];
    }
    
    // Speak
    [speak speakString:string];
}

- (void)backspaceRecieved
{
    // Update output text object
    if (_output.text.length > 0) {
        _output.text = [_output.text substringToIndex:_output.text.length - 1];
        [_interpreter dropEndOffGraph];
        [self playSound:ABBackspaceSound];
    }
    
    // Make delegate calls
    if ([_delegate respondsToSelector:@selector(characterTyped:withInfo:)]) {
        [_delegate characterTyped:ABBackspace
                         withInfo:@{ABGestureInfoStatus : @(YES),
                                    ABSpaceTyped : @(NO),
                                    ABBackspaceReceived : @(YES)}];
    }
}

- (void)spaceRecieved
{
    // Update output text object
    [_output insertText:@" "];
    
    // Make delegate calls
    if ([_delegate respondsToSelector:@selector(characterTyped:withInfo:)]) {
        [_delegate characterTyped:ABSpaceCharacter
                         withInfo:@{ABGestureInfoStatus : @(YES),
                                    ABSpaceTyped : @(YES),
                                    ABBackspaceReceived : @(NO)}];
    }
    
    // Speak
    [speak speakString:_interpreter.getCurrentWord];
    
    [_interpreter reset];
}

- (void)enterRecieved
{
    [_output insertText:@"\n"];
    if ([_delegate respondsToSelector:@selector(keyboardEnterPressed)])
        [_delegate keyboardEnterPressed];
    
}

#pragma mark Set Grade

- (ABGrade)grade
{
    return _interpreter.grade;
}

- (void)setGrade:(ABGrade)grade
{
    [_interpreter setGrade:grade];
}

#pragma mark Keyboard Implementation

/**
 * Creates a view overlay for recognizing braille type
 */
- (void)setUpViewWithTouchesFromABVectorArray:(ABVector[])vectors {
    // Type interface setup
    interface = [[ABTouchLayer alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    [interface setBackgroundColor:[UIColor grayColor]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id val = [defaults objectForKey:KeyboardTransparency];
    if (val != nil) {
        [interface setAlpha:[defaults floatForKey:KeyboardTransparency]];
    } else {
        [interface setAlpha:0.4];
    }
    [interface setClearsContextBeforeDrawing:YES];

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
    
    // Added reponders
    _interpreter = [ABBrailleInterpreter new];
    [_interpreter setResponder:self];
    [interface setInterpreter:_interpreter];
    [interface setReponder:self];
    
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
                [self activated];
            }
            
            break;
        case ABGestureDirectionDOWN:
            
            if (reg.translationFromStart > 150) {
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
                [self deactivated];
                [_output resignFirstResponder];
                _keyboardActive = NO;
            }
            
            break;
        default:
            break;
    }
}

#pragma mark active/deactive

- (void)activated
{
    gestures = _delegate.view.gestureRecognizers;
    [_delegate.view setGestureRecognizers:@[activate]];
    [self playSound:ABEnableSound];
    [_output becomeFirstResponder];
    if ([_delegate respondsToSelector:@selector(keyboardDidBecomeActive)]) {
        [_delegate keyboardDidBecomeActive];
    }
}

- (void)deactivated
{
    [_delegate.view setGestureRecognizers:gestures];
    if ([_delegate respondsToSelector:@selector(keyboardDidDismiss)]) {
        [_delegate keyboardDidDismiss];
    }
}

#pragma mark args

- (void)setSpaceOffset:(int)spaceOffset {
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
    if (!_sound) {
        return;
    }
    
    if ([type isEqualToString:ABBackspaceSound]){
        avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backspaceURL error:nil];
    } else if ([type isEqualToString:ABEnableSound]) {
        avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:enabledURL error:nil];
    } else if ([type isEqualToString:ABDisableSound]) {
        avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:disabledURL error:nil];
    }
    
    [avPlayer play];
}

@end
