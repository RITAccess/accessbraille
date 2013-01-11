//
//  ViewController.m
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "ViewController.h"
#import "Drawing.h"
#import "CalibrationPoint.h"
#import "BrailleInterpreter.h"
#import "NavigationView.h"
#import "UIBezelGestureRecognizer.h"
#import <AudioToolbox/AudioToolbox.h>

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
    
    // Interpreter
    BrailleInterpreter *bi;

    // Calibration Points
    NSMutableDictionary *cpByFinger;
    
    // State Change Gestues
    UILongPressGestureRecognizer *sixFingerHold;
    UITapGestureRecognizer *doubleTapExit;
    UITapGestureRecognizer *tapToCloseMenu;
    UIBezelGestureRecognizer *leftSideSwipe;
    UIPanGestureRecognizer *menuTrav;
    
    
    // View
    NavigationView *nav;
    
    
}

@synthesize typingStateOutlet = _typingStateOutlet;
@synthesize textOutput = _textOutput;
@synthesize DrawingView = _DrawingView;

- (void)viewDidLoad {
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
    sixFingerHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sixFingerLong:)];
    [sixFingerHold setNumberOfTouchesRequired:6];
    sixFingerHold.minimumPressDuration = .75;
    doubleTapExit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitTyping:)];
    [doubleTapExit setNumberOfTapsRequired:2];
    [doubleTapExit setNumberOfTouchesRequired:1];
    [doubleTapExit setEnabled:NO];
    
    // Nav pullout
    nav = [[NavigationView alloc] initWithFrame:CGRectMake(-100, 0, 100, 748)];
    [self.view addSubview:nav];
    leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    tapToCloseMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    [tapToCloseMenu setNumberOfTapsRequired:1];
    [tapToCloseMenu setEnabled:NO];
    menuTrav = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    [menuTrav setMinimumNumberOfTouches:1];
    [menuTrav setMaximumNumberOfTouches:1];
    [menuTrav setEnabled:NO];
    

    // Add Recognizers to view
    [self.view addGestureRecognizer:BROneTap];
    [self.view addGestureRecognizer:BRTwoTap];
    [self.view addGestureRecognizer:BRThreeTap];
    [self.view addGestureRecognizer:BRFourTap];
    [self.view addGestureRecognizer:BRFiveTap];
    [self.view addGestureRecognizer:BRSixTap];
    [self.view addGestureRecognizer:sixFingerHold];
    [self.view addGestureRecognizer:doubleTapExit];
    [self.view addGestureRecognizer:leftSideSwipe];
    [self.view addGestureRecognizer:tapToCloseMenu];
    [self.view addGestureRecognizer:menuTrav];
    
    // Set starting states for objects and init variables
    cpByFinger = [[NSMutableDictionary alloc] init];
    isTypingMode = false;
    bi = [[BrailleInterpreter alloc] initWithViewController:self];
}

-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
            printf(".");
            [nav updateWithCGPoint:touch];
            break;
            
        case UIGestureRecognizerStateBegan:
            [tapToCloseMenu setEnabled:TRUE];
            [menuTrav setEnabled:TRUE];
            NSLog(@"State Started");
            break;
            
        case UIGestureRecognizerStateEnded:
            printf("\n");
            NSLog(@"State Ended");
            if (touch.x < 100) {
                [self closeMenu:reg];
            }
            break;
            
        default:
            break;
    }
}

-(void)panMenu:(UIPanGestureRecognizer *)reg{
    
    NSLog(@"panning");
    
}

-(void)closeMenu:(UIGestureRecognizer *)reg {
    if ([reg isKindOfClass:[UIBezelGestureRecognizer class]]) {
        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
    if ([reg locationOfTouch:0 inView:self.view].x > 100) {
        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
}


- (void)BRTap:(UITapGestureRecognizer *)reg{
    // Audio feedback click
    // Assuming valid tap, continue typing
    [self beginTyping];
    NSMutableDictionary *touchPoints = [[NSMutableDictionary alloc] init];
    for(int t = 0; t < (int)reg.numberOfTouches; t++){
        CGPoint point = [reg locationOfTouch:t inView:reg.view];
        for (NSString *key in cpByFinger){
            CalibrationPoint *tmp = [cpByFinger objectForKey:key];
            if ([tmp tapInRadius:point]) {
                [touchPoints setObject:tmp forKey:[tmp getCurrentID]];
            }
        }
    }
    if (touchPoints.count > 0) {
        NSString *check = [bi getChar:touchPoints];
        NSString *letter = [check isEqualToString:@"not"] ? @"" : check;
        NSString *currentText = _textOutput.text;
        _textOutput.text = [currentText stringByAppendingString:letter];
        NSLog(@"%@", letter);
    } else {
        if ([bi getAverageYValue] < [reg locationInView:reg.view].y){
            NSString *currentText = _textOutput.text;
            _textOutput.text = [currentText stringByAppendingString:@" "];
            NSLog(@"Space");
        }
    }
}

- (void)sixFingerLong:(UILongPressGestureRecognizer *)reg{
    // Creating any variables used in switch scope
    NSArray *rawTouch;
    NSArray *sortedTouchPoints;
    NSArray *fingerIDs = @[@3,@2,@1,@4,@5,@6];
    NSSortDescriptor *sortXValues = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:TRUE];
    NSArray *sorters = @[ sortXValues ];
    switch (reg.state) {
        case 1:
            // Enable Braille Recognizers
            [BROneTap setEnabled:YES];
            [BRTwoTap setEnabled:YES];
            [BRThreeTap setEnabled:YES];
            [BRFourTap setEnabled:YES];
            [BRFiveTap setEnabled:YES];
            [BRSixTap setEnabled:YES];
            [doubleTapExit setEnabled:YES];
            
            // Set callibration points
            rawTouch = @[
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:0 inView:reg.view] withTmpID:@0],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:1 inView:reg.view] withTmpID:@1],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:2 inView:reg.view] withTmpID:@2],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:3 inView:reg.view] withTmpID:@3],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:4 inView:reg.view] withTmpID:@4],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:5 inView:reg.view] withTmpID:@5]
            ];
            
            sortedTouchPoints = [rawTouch sortedArrayUsingDescriptors:sorters];
            for (int i = 0; i < 6; i++){
                CalibrationPoint *tmp = [sortedTouchPoints objectAtIndex:i];
                [tmp setNewID:[fingerIDs objectAtIndex:i]];
                [cpByFinger setValue:tmp forKey:[[tmp getCurrentID] stringValue]];
                [bi addCalibrationPoint:tmp];
            }
            // Configure radius and buffers in BI
            [bi setUpCalibration];
            
            // Audio feedback tone up
            break;
            
        case 3: // On Release
            [self beginTyping];
            NSLog(@"%@", [bi description]);
            // Disable all navigation gestures
            [sixFingerHold setEnabled:NO];
            NSLog(@"Typing Enabled");
            break;
            
        default:
            // NSLog(@"Unchecked state: %d", reg.state);
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

- (void)exitTyping:(UITapGestureRecognizer *)reg{
    if ([bi getAverageYValue] > ([reg locationInView:reg.view].y + [bi getMaxYDelta])) {
        [self endTyping];
    }
}

- (void)endTyping{
    // End Timer
    [typingTimeout invalidate];
    NSLog(@"End Typing");
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
    [doubleTapExit setEnabled:NO];
    // Enable Navigation Gestures
    [sixFingerHold setEnabled:YES];
    // Clear subview
    for (Drawing *v in [self.view subviews]){
        if ([v isKindOfClass:[Drawing class]]) {
            [v removeFromSuperview];
        }
    }
    // Audio feedback tone down
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDrawingView:nil];
    [self setTextOutput:nil];
    [super viewDidUnload];
}
@end
