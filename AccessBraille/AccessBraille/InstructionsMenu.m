//
//  InstructionsMenu.m
//  AccessBraille
//
//  Created by Piper Chester on 3/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsMenu.h"

@implementation InstructionsMenu{
    UITextView *instructionsInfo;
    NSTimer *speechTimer;
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

}

- (void)viewDidUnload {
    [self setLabel:nil];
    [super viewDidUnload];
}

@end
