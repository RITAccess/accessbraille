//
//  InstructionsViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsViewController.h"
#import <UIKit/UIKit.h>

NSString *const InstructionsStoryBoardID = @"InstructionsMenu";

const CGRect TextViewOffScreenTop       = { { 75.0f, -1000.0f }, { 874.0f, 618.0f } };
const CGRect TextViewCenterScreen       = { { 75.0f,    75.0f }, { 874.0f, 618.0f } };
const CGRect TextViewOffScreenBottom    = { { 75.0f,  1000.0f }, { 874.0f, 618.0f } };

@interface InstructionsViewController ()

@property NSArray *instructionSet;

@end

@implementation InstructionsViewController
{
    ABSpeak *speaker;
    
    UISwipeGestureRecognizer *next_swipe;
    UISwipeGestureRecognizer *last_swipe;
    
    NSInteger currentSlide;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    speaker = [ABSpeak sharedInstance];
    
    _instructionSet = [self populateSlides];
    currentSlide = 0;
    _outputText.frame = TextViewCenterScreen;
    _outputText.text = _instructionSet[currentSlide];

    next_swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveSwipe:)];
    last_swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveSwipe:)];
    
    [next_swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [last_swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self.view setGestureRecognizers:@[next_swipe, last_swipe]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Instruction Display Logic

/**
 * Return the array of atributed strings that will be displayed in the instructions
 * screen slides. Order decides the deplay order.
 */
- (NSArray *)populateSlides
{
//    TODO: Implement to return attributed strings. See issue #213
    return @[@"General Usage: The Access Braille app launches onto an initial navigation menu. From here, drag up and down with one finger to navigate the different menu selections. When you hover over a certain mode, its name will be spoken to you. While still holding your finger, swipe to the right to enter the mode. Or you can tap on the mode icon.", @"Navigation: Once in a mode, to return to main navigation menu all the user needs to do is tap the Red Menu flag. The user can also double the screen in some apps to display the navigation menu.", @"Typing: To initialize the typing keyboard, swipe six fingers up from the bottom of the screen. 6 columns will appear on the screen. Each column is intended for one finger. To remove the keyboard, swipe six fingers down from the top of the keyboard."];
}

/**
 * Speaks the current slide displayed
 */
- (void)speakCurrentSlide
{
    [speaker speakString:_instructionSet[currentSlide]];
}

/**
 * Recieves the swipe and tries to animate to the next/last slide.
 */
- (void)didReceiveSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (next_swipe.hash == swipe.hash) // Next
    {
        [self animateToIndex:(currentSlide + 1) forward:YES completion:^(BOOL finished) {
            currentSlide++;
            [self speakCurrentSlide];
        }];
    }
    else if (last_swipe.hash == swipe.hash) // Last
    {
        [self animateToIndex:(currentSlide - 1) forward:NO completion:^(BOOL finished) {
            currentSlide--;
            [self speakCurrentSlide];
        }];
    }
}

/**
 * Animates the slides to the index if the index is within the instruction set
 * array, if not returns without calling the completion block.
 */
- (void)animateToIndex:(NSInteger)index forward:(BOOL)forword completion:(void(^)(BOOL finished))completion
{
    if (!(_instructionSet.count > index)) return; // Return if not valid
    
    [speaker stopSpeaking];
    [UIView animateWithDuration:0.6 animations:^{
        _outputText.frame = forword ? TextViewOffScreenTop : TextViewOffScreenBottom;
    } completion:^(BOOL finished) {
        _outputText.text = _instructionSet[index];
        _outputText.frame = forword ? TextViewOffScreenBottom : TextViewOffScreenTop;
        [UIView animateWithDuration:0.6 animations:^{
            _outputText.frame = TextViewCenterScreen;
        } completion:completion];
    }];
}

@end
