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

@interface FlashCard ()

@end

@implementation FlashCard {
    
    UILabel *title;
    UILabel *typedCharacter;
    NSTimer *speechTimer;
    NSMutableArray *cards;
    NSMutableArray *letters;
    NSString *path;
    NSString *finalPath;
    UIButton *instructionsButton;
    UIButton *settingsButton;
    UIButton *startButton;
    UILabel *infoText;
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
    
    ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
	
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    title.center = CGPointMake(550, 50);
    [title setText:@"Flash Card Mode"];
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
    
    infoText = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 300, 100)];
    [infoText setText:@"Welcome to Flash Card mode! From here you can change settings, read instructions, or begin playing!"];
    [infoText setFont: [UIFont fontWithName:@"Trebuchet MS" size:20.0f]];
    [[self view] addSubview:infoText];
    
    typedCharacter = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
    [typedCharacter setFont: [UIFont fontWithName:@"Trebuchet MS" size:60.0f]];
    [[self view] addSubview:typedCharacter];
    
    // Reading in the plist.
    path = [[NSBundle mainBundle] bundlePath];
    finalPath = [path stringByAppendingPathComponent:@"cards.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingsButton.frame = CGRectMake(80, 400, 250, 300);
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:settingsButton];
    
    instructionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    instructionsButton.frame = CGRectMake(370, 400, 250, 300);
    [instructionsButton setTitle:@"Instructions" forState:UIControlStateNormal];
    [instructionsButton addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:instructionsButton];
    
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(660, 400, 250, 300);
    [startButton setTitle:@"Start!" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startButton];

    
    [self parseCards];
    
}

- (void)changeText:(id)sender{
    [infoText setText:(@"Instructions Text!")];
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
