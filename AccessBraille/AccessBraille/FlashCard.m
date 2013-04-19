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
    UILabel *title;
    UILabel *labelFromInput;
    NSTimer *speechTimer;
    NSMutableArray *cards;
    NSArray *card;
    NSMutableString *stringFromInput;
    NSArray *letters;
    UIButton *instructionsButton;
    UIButton *settingsButton;
    UIButton *startButton;
    UILabel *infoText;
    ABKeyboard *keyboard;
    ABParser *parser;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    title.center = CGPointMake(550, 50);
    [title setText:@"Flash Card Mode"];
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
    
    infoText = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 1000, 100)];
    [infoText setText:welcomeText];
    [infoText setFont: [UIFont fontWithName:@"Trebuchet MS" size:20.0f]];
    [[self view] addSubview:infoText];
    
    labelFromInput = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
    [labelFromInput setFont: [UIFont fontWithName:@"Trebuchet MS" size:60.0f]];
    [[self view] addSubview:labelFromInput];
    
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
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    stringFromInput = [[NSMutableString alloc] init];
}


#pragma mark - Button

- (void)buttonPress:(id)sender{
    if (sender == startButton){
        [startButton removeFromSuperview];
        [settingsButton removeFromSuperview];
        [instructionsButton removeFromSuperview];
        [infoText removeFromSuperview];
        [self enterCardMode];
        
    }else if (sender == instructionsButton){
        [infoText setText:(instructionsText)];
    }
    else{
        [infoText setText:(settingsText)];
    }
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
