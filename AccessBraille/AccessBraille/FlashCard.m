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
    UILabel *labelFromInput;
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
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 1000, 100)];
    [infoText setText:welcomeText];
    [[self view] addSubview:infoText];
    
    labelFromInput = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
    [labelFromInput setBackgroundColor:[UIColor clearColor]];
    labelFromInput.numberOfLines = 0;
    labelFromInput.lineBreakMode = NSLineBreakByWordWrapping;
    [labelFromInput setFont:[UIFont fontWithName:@"System" size:40.0]];
    
    [[self view] addSubview:labelFromInput];
    
    // Reading in the plist.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"cards.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    stringFromInput = [[NSMutableString alloc] init];
    
//    self.nextCardButton.hidden = true;
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
    [self enterCardMode];
    self.nextCardButton.hidden = true;
}

- (IBAction)displayNextCardFromButtonClick:(id)sender {
    NSLog(@"Pressing");
    [self changeCard:arc4random() % 100];
}



#pragma mark - Card Mode

-(void)enterCardMode{
    
    int randomCardIndex = arc4random() % 500;
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [labelFromInput setText:cards[randomCardIndex]]; // Display the word.
//    letterTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(speakSingleLetterFromArray) userInfo:nil repeats:NO];
//   [letterTimer fire];
}

-(void)changeCard: (int) newRandomCardIndex{
    [labelFromInput setText:cards[newRandomCardIndex]];
    NSLog(@"changing!");
}

/**
 * Speak character being typed, as well as appending it to the label.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSArray *)info {
    NSLog(@"%@", character);
    [stringFromInput appendFormat:@"%@", character];
    [labelFromInput setText:stringFromInput];
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
    [self setNextCardButton:nil];
    [super viewDidUnload];
}

@end
