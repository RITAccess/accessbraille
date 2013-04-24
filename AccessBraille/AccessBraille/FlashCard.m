//
//  FlashCard.m
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "FlashCard.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ABKeyboard.h"
#import "ABParser.h"

@interface FlashCard ()

@end

@implementation FlashCard {
    NSTimer *letterTimer;
    UITextView *typedText;
    UITextView *cardText;
    NSTimer *speechTimer;
    NSMutableArray *cards;
    NSArray *card;
    NSMutableString *stringFromInput;
    NSArray *letters;
    UITextView *infoText;
    ABKeyboard *keyboard;
    ABParser *parser;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 100)];
    [infoText setText:welcomeText];
    [infoText setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    [[self view] addSubview:infoText];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake(200, 220, 150, 100)];
    [typedText setBackgroundColor:[UIColor clearColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [[self view] addSubview:typedText];
    
    cardText = [[UITextView alloc] initWithFrame:CGRectMake(700, 220, 150, 100)];
    [cardText setBackgroundColor:[UIColor clearColor]];
    [cardText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [[self view] addSubview:cardText];
    
    // Reading in the plist.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"cards.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    stringFromInput = [[NSMutableString alloc] init];
}


#pragma mark - Buttons

- (IBAction)displayInstructionsFromButtonClick:(id)sender {
    [infoText setText:(settingsText)];
}

- (IBAction)displaySettingsFromButtonClick:(id)sender {
    [infoText setText:(instructionsText)];
}

- (IBAction)enterCardModeFromButtonClick:(id)sender {
    infoText.text = nil;
    self.instructionsButton.hidden = true;
    self.settingsButton.hidden = true;
    self.playButton.hidden = true;
    self.screenTitle.hidden = true;
    [self enterCardMode];
}




#pragma mark - Card Mode

-(void)enterCardMode{
    
    int randomCardIndex = arc4random() % 2000;
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[randomCardIndex]]; // Display the word.
}

-(void)changeCard: (int) newRandomCardIndex{
    [typedText setText:cards[newRandomCardIndex]];
    NSLog(@"changing!");
}

/**
 * Speak character being typed, as well as appending it to the label.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSArray *)info {
    NSLog(@"%@", character);
    [stringFromInput appendFormat:@"%@", character];
    [typedText setText:stringFromInput];
}


#pragma mark - Speech

- (void)speakSingleLetterFromArray{
    letters = [ABParser arrayOfCharactersFromWord:card[0]];
    
    letterTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(speakSingleLetterFromArray) userInfo:nil repeats:NO];
    
    for (int i = 0; i < letters.count; i++){
        NSLog(@"%@", letters[0]);
        [letterTimer fire];
    }
}

- (void)viewDidUnload {
    [self setInstructionsButton:nil];
    [self setSettingsButton:nil];
    [self setPlayButton:nil];
    [self setScreenTitle:nil];
    [super viewDidUnload];
}

@end
