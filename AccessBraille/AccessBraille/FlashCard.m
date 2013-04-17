//
//  FlashCard.m
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "FlashCard.h"
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ABKeyboard.h"
#import "ABParser.h"

@interface FlashCard ()

@end

@implementation FlashCard {
    UILabel *title;
    UILabel *typedCharacter;
    NSTimer *speechTimer;
    NSMutableArray *cards;
    NSMutableArray *letters;
    UIButton *instructionsButton;
    UIButton *settingsButton;
    UIButton *startButton;
    UILabel *infoText;
    ABKeyboard *keyboard;
    ABParser *parser;
}

@synthesize fliteController;
@synthesize slt;

- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init];
    }
    return fliteController;
}

- (Slt *)slt {
    if (slt == nil) {
        slt = [[Slt alloc] init];
    }
    return slt;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
	
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    title.center = CGPointMake(550, 50);
    [title setText:@"Flash Card Mode"];
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
    
    infoText = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 1000, 100)];
    [infoText setText:welcomeText];
    [infoText setFont: [UIFont fontWithName:@"Trebuchet MS" size:20.0f]];
    [[self view] addSubview:infoText];
    
    typedCharacter = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
    [typedCharacter setFont: [UIFont fontWithName:@"Trebuchet MS" size:60.0f]];
    [[self view] addSubview:typedCharacter];
    
    // Reading in the plist.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"cards.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingsButton.frame = CGRectMake(10, 400, 330, 330);
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:settingsButton];
    
    instructionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    instructionsButton.frame = CGRectMake(345, 400, 330, 330);
    [instructionsButton setTitle:@"Instructions" forState:UIControlStateNormal];
    [instructionsButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:instructionsButton];
    
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(685, 400, 330, 330);
    [startButton setTitle:@"Start!" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startButton];

    
    [self parseCards];
//    [self speak:welcomeText];
    
}

- (void)buttonPress:(id)sender{
    if (sender == startButton){
        [startButton removeFromSuperview];
        [settingsButton removeFromSuperview];
        [instructionsButton removeFromSuperview];
        [infoText removeFromSuperview];
        [self enterCardMode];
    }else if (sender == instructionsButton){
        [infoText setText:(instructionsText)];
        [self.fliteController say:instructionsText withVoice:self.slt];
    }
    else{
        [infoText setText:(settingsText)];
        [self.fliteController say:settingsText withVoice:self.slt];
    }
}

-(void)enterCardMode{
    [typedCharacter setText:cards[0]];
    [self.fliteController say:cards[0] withVoice:self.slt];
    [self parseSingleCard:cards[0]];
}

-(void)speak:(NSString *)textToSpeak{
    [self.fliteController say:textToSpeak withVoice:self.slt];
}

- (void)viewDidAppear:(BOOL)animated {

    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

/**
 * Speaks current character that's being typed.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    [self.fliteController say:character withVoice:self.slt];
    NSMutableString* word = [[NSMutableString alloc] init];
    [word appendFormat:@"%@", character];
    [typedCharacter setText:word];
}

- (void)parseSingleCard: (NSString *) card{
    NSArray *letters = [ABParser arrayOfCharactersFromWord:card];
    [self.fliteController say:letters[0] withVoice:self.slt];
}

/**
 * Loops through cards and parses them.
 */
- (void)parseCards
{
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    for (NSString *card in cards){
        for(int index = 0; index<card.length-1; index++){
            NSString *testStr = [NSString stringWithFormat:@"%c", [card characterAtIndex:index]];
            [chars addObject:testStr];
        }
    }
}

@end
