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
    
    UITapGestureRecognizer *generalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakInstruction:)];
    UITapGestureRecognizer *navigationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakInstruction:)];
    UITapGestureRecognizer *typingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakInstruction:)];
    
    NSArray *gestureTaps = @[generalTap, navigationTap, typingTap];
    
    for (UITapGestureRecognizer *tap in gestureTaps){
        [tap setNumberOfTapsRequired:2];
    }
    
    [_generalTextView addGestureRecognizer:generalTap];
    [_navigationTextView addGestureRecognizer:navigationTap];
    [_typingTextView addGestureRecognizer:typingTap];
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
