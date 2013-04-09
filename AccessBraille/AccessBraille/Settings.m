//
//  Settings.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/20/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "Settings.h"
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation Settings{
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 60)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"Settings"]; 
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Arial" size:30.0f]];
    [[self view] addSubview:title];
    
    // TextField
    instructionsInfo = [[UITextView alloc] initWithFrame:CGRectMake(deviceHeight / 8, 150, deviceHeight - 300, 500)];
    [instructionsInfo setText:@"Some instructions that we will include are:\n\n*Speech Speed\n\n*Game Difficulty\n\n*Reset Data"];
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