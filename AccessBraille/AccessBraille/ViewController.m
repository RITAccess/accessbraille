//
//  ViewController.m
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    // Typing Mode
    NSTimer *typingTimeout;
    bool isTypingMode;
    
    // Brail Typing 
    UITapGestureRecognizer *BROneTap;
    UITapGestureRecognizer *BRTwoTap;
    UITapGestureRecognizer *BRThreeTap;
    UITapGestureRecognizer *BRFourTap;
    UITapGestureRecognizer *BRFiveTap;
    UITapGestureRecognizer *BRSixTap;

    // State Change Gestues
    UILongPressGestureRecognizer *twoFingerHold;
}

@synthesize typingStateOutlet = _typingStateOutlet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Braille Recognizer Gestures
    BROneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BROneTap setNumberOfTouchesRequired:1];
        [BROneTap setNumberOfTapsRequired:1];
        [BROneTap setEnabled:NO];
    BRTwoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRTwoTap setNumberOfTouchesRequired:2];
        [BRTwoTap setNumberOfTapsRequired:1];
        [BRTwoTap setEnabled:NO];
    BRThreeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRThreeTap setNumberOfTouchesRequired:3];
        [BRThreeTap setNumberOfTapsRequired:1];
        [BRThreeTap setEnabled:NO];
    BRFourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRFourTap setNumberOfTouchesRequired:4];
        [BRFourTap setNumberOfTapsRequired:1];
        [BRFourTap setEnabled:NO];
    BRFiveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRFiveTap setNumberOfTouchesRequired:5];
        [BRFiveTap setNumberOfTapsRequired:1];
        [BRFiveTap setEnabled:NO];
    BRSixTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRSixTap setNumberOfTouchesRequired:6];
        [BRSixTap setNumberOfTapsRequired:1];
        [BRSixTap setEnabled:NO];
    
    // State Switch **two finger for simulater testing**
    twoFingerHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerLong:)];
    [twoFingerHold setNumberOfTouchesRequired:2];
    twoFingerHold.minimumPressDuration = .75;

    // Add Recognizers to view
    [self.view addGestureRecognizer:BROneTap];
    [self.view addGestureRecognizer:BRTwoTap];
    [self.view addGestureRecognizer:BRThreeTap];
    [self.view addGestureRecognizer:BRFourTap];
    [self.view addGestureRecognizer:BRFiveTap];
    [self.view addGestureRecognizer:BRSixTap];
    [self.view addGestureRecognizer:twoFingerHold];
    
    // Set starting states for objects
    isTypingMode = false;
}

- (void)BRTap:(UITapGestureRecognizer *)reg{
    // Audio feedback click
    // Assuming valid tap, continue typing
    [self beginTyping];
    NSLog(@"Typing: %@ Taps: %d", isTypingMode ? @"Enabled" : @"Disabled", (int)reg.numberOfTouches);
    if ((int)reg.numberOfTouches == 1){
        CGPoint point = [reg locationInView:reg.view];
        NSLog(@"Point (%f,%f)", point.x, point.y);
    }
}

- (void)twoFingerLong:(UILongPressGestureRecognizer *)reg{
    switch (reg.state) {
        case 1: // On Recognition
            // Disable all navigation gestures
            // Enable Braille Recognizers
            [BROneTap setEnabled:YES];
            [BRTwoTap setEnabled:YES];
            [BRThreeTap setEnabled:YES];
            [BRFourTap setEnabled:YES];
            [BRFiveTap setEnabled:YES];
            [BRSixTap setEnabled:YES];
            
            // Set callibration points
            // Audio feedback tone up
            NSLog(@"Typing Enabled");
            break;
            
        case 3: // On Release
            [self beginTyping];
            break;
            
        default:
            NSLog(@"Unchecked state: %d", reg.state);
            break;
    }
}

- (void)beginTyping{
    if (!isTypingMode){
        // Start timer and switch to typing mode
        typingTimeout = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(endTyping) userInfo:nil repeats:false];
        isTypingMode = true;
        [_typingStateOutlet setText:@"True"];
    } else {
        // Reset timer if in typing mode
        [typingTimeout invalidate];
        typingTimeout = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(endTyping) userInfo:nil repeats:false];
    }
}

- (void)endTyping{
    NSLog(@"Timeout reached");
    // Disable Typing
    isTypingMode = false;
    [_typingStateOutlet setText:@"False"];
    // Disable Braille Recognizers
    [BROneTap setEnabled:NO];
    [BRTwoTap setEnabled:NO];
    [BRThreeTap setEnabled:NO];
    [BRFourTap setEnabled:NO];
    [BRFiveTap setEnabled:NO];
    [BRSixTap setEnabled:NO];
    // Enable Navigation Gestures
    // Audio feedback tone down
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
