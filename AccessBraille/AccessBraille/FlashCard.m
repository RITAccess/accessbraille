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
    UILabel *infoText;
    ABKeyboard *keyboard;
    ABParser *parser;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoText = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 1000, 100)];
    [infoText setText:welcomeText];
    [[self view] addSubview:infoText];
    
    labelFromInput = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
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
}


#pragma mark - Buttons

- (IBAction)displayInstructionsFromButtonClick:(id)sender {
    [infoText setText:(settingsText)];
}

- (IBAction)displaySettingsFromButtonClick:(id)sender {
    [infoText setText:(instructionsText)];
}

- (IBAction)enterCardModeFromButtonClick:(id)sender {
    
}



#pragma mark - Card Mode

-(void)enterCardMode{
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [labelFromInput setText:cards[0]]; // Display the word.
    letterTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(speakSingleLetterFromArray) userInfo:nil repeats:NO];
   [letterTimer fire];
}

/**
 * Speak character being typed, as well as appending it to the label.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
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

@end
