//
//  InstructionsViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController
{
    ABSpeak *speaker;
    NSArray *instructionViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_labelContainerView.layer setCornerRadius:20];
    speaker = [ABSpeak sharedInstance];
    instructionViews = @[_firstTextView, _secondTextView, _thirdTextView];
    [self speakInstructions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)speakInstructions
{
    for (UITextView *textView in instructionViews){
        [speaker speakString:textView.text];
    }
}

@end
