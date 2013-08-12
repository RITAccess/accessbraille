//
//  FlashCard.m
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "FlashCard.h"

@implementation FlashCard {
    UISwipeGestureRecognizer *swipeToSelectEasy, *swipeToSelectMedium, *swipeToSelectHard;
    NSMutableArray *cards;
    NSArray *card, *letters;
    NSMutableString *stringFromInput;
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    int points;
    NSString *finalPath, *path;
    SystemSoundID correctSound, incorrectSound;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scoreLabel setHidden:YES];
    [_pointsTagView setHidden:YES];
    [_cardTextView setHidden:YES];
    [_typedTextView setHidden:YES];
    
    correctSound = [self createSoundID:@"correct.aiff"];
    incorrectSound = [self createSoundID:@"incorrect.aiff"];
    
    stringFromInput = [[NSMutableString alloc] init];
    speaker = [[ABSpeak alloc] init];
    
    /* Gestures */
    swipeToSelectEasy = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginPlaying:)];
    [swipeToSelectEasy setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeToSelectEasy];
    
    swipeToSelectMedium = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginPlaying:)];
    [swipeToSelectMedium setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeToSelectMedium];
    
    swipeToSelectHard = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginPlaying:)];
    [swipeToSelectHard setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeToSelectHard];
    
    [speaker speakString:_infoTextView.text];  // Speaking the text from Storyboard.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [speaker stopSpeaking];
}

/**
 * Initializes proper cards based on the direction of the swipe. Initializes
 * keyboard, disables gestures, and removes info text.
 *
 * @param gesture UISwipeGestureRecognizer that's direction determines difficulty selection.
 */
- (void)beginPlaying:(UISwipeGestureRecognizer *)gesture
{
    //  Initialize Proper Cards
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp){
        [self initializeCards:@"easy.plist"];
        [_cardTextView setText:cards[arc4random() % maxEasyCards]];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight){
        [self initializeCards:@"medium.plist"];
        [_cardTextView setText:cards[arc4random() % maxMediumCards]];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionDown){
        [self initializeCards:@"hard.plist"];
        [_cardTextView setText:cards[arc4random() % maxHardCards]];
    }
    
    // Defining font size - wasn't working in Storyboard for some reason...
    [_cardTextView setFont:[UIFont boldSystemFontOfSize:140]];
    [_typedTextView setFont:[UIFont boldSystemFontOfSize:140]];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    [speaker speakString:_cardTextView.text];
    
    [_infoTextView removeFromSuperview];
    [_cardTextView setHidden:NO];
    [_pointsTagView setHidden:NO];
    [_scoreLabel setHidden:NO];
    [_typedTextView setTextColor:[UIColor greenColor]];  // Not working in Interface Builder for some reason...
    [_typedTextView setHidden:NO];
    [_typedTextView setText:@""];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [swipeToSelectEasy setEnabled:NO];
    [swipeToSelectMedium setEnabled:NO];
    [swipeToSelectHard setEnabled:NO];
}

#pragma mark - Card Mode

/**
 * Checks to see if typed word matches the card displayed. If so, play a correct sound
 * and switch to a new card. Else, play an incorrect sound.
 */
- (void)checkCard
{
    if ([_cardTextView.text isEqualToString:_typedTextView.text]){
        AudioServicesPlaySystemSound(correctSound);
        [_scoreLabel setText:[NSString stringWithFormat:@"%d", ++points]];
        [_cardTextView setText:cards[arc4random() % maxHardCards]];
        [speaker speakString:_cardTextView.text]; // Speak the new card.
        [_typedTextView setText:@""];
        [stringFromInput setString:@""];
    } else {
        AudioServicesPlaySystemSound(incorrectSound);
    }
}

- (void)initializeCards:(NSString* )withDifficulty
{
    path = [[NSBundle mainBundle] bundlePath];
    finalPath = [path stringByAppendingPathComponent:withDifficulty];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
}

#pragma mark - Helper Methods

- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info
{
    if ([info[ABSpaceTyped] boolValue]){
        [self checkCard];
    } else {
        // Remove character from typed string if backspace detected.
        if ([info[ABBackspaceReceived] boolValue]){
            if (stringFromInput.length > 0) {
                [stringFromInput deleteCharactersInRange:NSMakeRange(stringFromInput.length - 1, 1)];
                [_typedTextView setText:stringFromInput];
            }
        } else {
            [stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [_typedTextView setText:stringFromInput]; // Sets typed text to the label.
        }
    }
}

- (SystemSoundID) createSoundID: (NSString*)name
{
    path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
