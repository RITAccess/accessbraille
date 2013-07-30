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
    UITextView *cardText, *typedText;
    
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

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    correctSound = [self createSoundID:@"correct.aiff"];
    incorrectSound = [self createSoundID:@"incorrect.aiff"];
    
    stringFromInput = [[NSMutableString alloc] init];
    speaker = [[ABSpeak alloc] init];
    
    cardText = [[UITextView alloc] initWithFrame:CGRectMake((height / 2) - 200, (width / 2) - 200, 700, 300)];
    [cardText setBackgroundColor:[UIColor clearColor]];
    [cardText setFont:[UIFont fontWithName:@"ArialMT" size:140]];
    [cardText setUserInteractionEnabled:NO];
    [[self view] addSubview:cardText];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake((height / 2) - 200, (width / 2) - 200, 700, 300)];
    [typedText setBackgroundColor:[UIColor clearColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:140]];
    typedText.textColor = [UIColor colorWithRed:0.f green:.8 blue:0.f alpha:1.f];
    [typedText setUserInteractionEnabled:NO];
    [[self view] addSubview:typedText];
    
    /* Gestures */
    swipeToSelectEasy = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterEasyMode:)];
    [swipeToSelectEasy setEnabled:YES];
    [swipeToSelectEasy setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeToSelectEasy];
    
    swipeToSelectMedium = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterMediumMode:)];
    [swipeToSelectMedium setEnabled:YES];
    [swipeToSelectMedium setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeToSelectMedium];
    
    swipeToSelectHard = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterHardMode:)];
    [swipeToSelectHard setEnabled:YES];
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


#pragma mark - Gestures

- (void)enterEasyMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self disableGesturesAndManageLabels];
    [self initializeCards:@"easy.plist"];
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[arc4random() % maxEasyCards]]; // Display the word.
    [speaker speakString:cardText.text];

    [_infoTextView removeFromSuperview];
    [_pointsTagView setHidden:NO];
    [_scoreLabel setHidden:NO];
}

- (void)enterMediumMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self disableGesturesAndManageLabels];
    [self initializeCards:@"medium.plist"];
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[arc4random() % maxMediumCards]]; // Display the word.
    [speaker speakString:cardText.text];
}

- (void)enterHardMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self initializeCards:@"hard.plist"];
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [self disableGesturesAndManageLabels];
    [cardText setText:cards[arc4random() % maxHardCards]]; // Display the word.
    [speaker speakString:cardText.text];
}

#pragma mark - Card Mode

/**
 * Checks to see if typed word matches the card displayed. If so, play a correct sound
 * and switch to a new card. Else, play an incorrect sound.
 */
- (void)checkCard{
    if ([cardText.text isEqualToString:typedText.text]) {
        AudioServicesPlaySystemSound(correctSound);
        [_scoreLabel setText:[NSString stringWithFormat:@"%d", ++points]];
        [cardText setText:cards[arc4random() % maxHardCards]];
        [speaker speakString:cardText.text]; // Speak the new card.
        [self clearStrings];
    }else{
        AudioServicesPlaySystemSound(incorrectSound);
    }
}

- (void)initializeCards:(NSString* )withDifficulty{
    path = [[NSBundle mainBundle] bundlePath];
    finalPath = [path stringByAppendingPathComponent:withDifficulty];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
}

#pragma mark - Helper Methods

- (void)disableGesturesAndManageLabels{
    swipeToSelectEasy.enabled = NO;
    swipeToSelectMedium.enabled = NO;
    swipeToSelectHard.enabled = NO;
}

- (void)clearStrings{
    typedText.text = @"";
    [stringFromInput setString:@""];
}

/**
 * Speak character being typed, as well as appending it to the UITextView.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    if ([info[ABSpaceTyped] boolValue]){
        [self checkCard];
    }else{
        if ([info[ABBackspaceReceived] boolValue]){ // Remove character from typed string if backspace detected.
            if (stringFromInput.length > 0) {
                [stringFromInput deleteCharactersInRange:NSMakeRange(stringFromInput.length - 1, 1)];
                [typedText setText:stringFromInput];
            }
        }
        else{
            [stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [typedText setText:stringFromInput]; // Sets typed text to the label.
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
