//
//  InstructionsMenu.m
//  AccessBraille
//
//  Created by Piper Chester on 3/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsMenu.h"
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation InstructionsMenu{
    UITextView *instructionsInfo;
    NSTimer *speechTimer;
}

@synthesize fliteController;
@synthesize slt;

- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init];
    }
    return fliteController;
}

- (Slt *)slt {
    if (slt == nil) {
        slt = [[Slt alloc] init];
    }
    return slt;
}

/** Method to be called as soon as view loads. */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 60)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"How to Use"]; /// Will be passed in from external class
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Arial" size:30.0f]];
    [[self view] addSubview:title];
    
    // TextField
    instructionsInfo = [[UITextView alloc] initWithFrame:CGRectMake(deviceHeight / 8, 150, deviceHeight - 300, 500)];
    [instructionsInfo setText:@"Swipe from the left at any time to bring up the navigation menu.\n\nIn BT, swipe 6 fingers up to enter Typing Mode.\n\nWhen in Typing Mode, tap to the right of the screen to backspace, or the center to add a space.\n\nTap above the contacts to exit Typing Mode.\n\nThese instructions can be accessed at any time."];
    [instructionsInfo setBackgroundColor:[UIColor clearColor]];
    [instructionsInfo setFont:[UIFont fontWithName:@"Arial" size:24.0f]];
    [instructionsInfo setUserInteractionEnabled:NO];
    [[self view] addSubview:instructionsInfo];

    
    /** Timer will wait 500 miliseconds before speak is called. */
    speechTimer = [NSTimer scheduledTimerWithTimeInterval:.1  target:self selector:@selector(speak) userInfo:nil repeats:NO];
    
}

/** FliteController will speak what needs to be said. */
- (void)speak
{
    // Speech
    [self.fliteController say:instructionsInfo.text withVoice:self.slt];
}

- (void)viewDidUnload {
    [self setLabel:nil];
    [super viewDidUnload];
}

@end
