//
//  InstructionsViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsViewController.h"
#import <UIKit/UIKit.h>

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController
{
    ABSpeak *speaker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    speaker = [ABSpeak sharedInstance];
    
    UITapGestureRecognizer *instructionsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakInstruction:)];
    
    NSArray *instructionViews = @[_generalTextView, _navigationTextView, _typingTextView];
    
    for (UITextView *textView in instructionViews){
        [textView addGestureRecognizer:instructionsTap];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)speakInstruction:(UITapGestureRecognizer *)gestureRecognizer
{
    [speaker speakString:((UITextView *)(gestureRecognizer.view)).text];
}


@end
