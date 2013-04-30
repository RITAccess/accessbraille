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
    UITapGestureRecognizer *tapToDisplayInstructions;
    UITapGestureRecognizer *tapToDisplaySettings;
    UISwipeGestureRecognizer *swipeToEnterCardMode;
    NSTimer *letterTimer;
    UITextView *typedText;
    UITextView *cardText;
    UITextView *pointsText;
    NSTimer *speechTimer;
    NSMutableArray *cards;
    NSArray *card;
    NSMutableString *stringFromInput;
    NSArray *letters;
    UITextView *infoText;
    UITapGestureRecognizer *tap;
    ABKeyboard *keyboard;
    ABParser *parser;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Reading in the plist.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"cards.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [infoText setText:welcomeText];
    [infoText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    infoText.editable = NO;
    infoText.scrollEnabled = NO;
    infoText.allowsEditingTextAttributes = NO;
    [[self view] addSubview:infoText];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake(200, 150, 150, 100)];
    [typedText setBackgroundColor:[UIColor clearColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:80]];
    typedText.editable = NO;
    typedText.scrollEnabled = NO;
    [[self view] addSubview:typedText];
    
    cardText = [[UITextView alloc] initWithFrame:CGRectMake(700, 150, 150, 100)];
    [cardText setBackgroundColor:[UIColor clearColor]];
    [cardText setFont:[UIFont fontWithName:@"ArialMT" size:80]];
    cardText.editable = NO;
    cardText.scrollEnabled = NO;
    cardText.allowsEditingTextAttributes = NO;
    [[self view] addSubview:cardText];
    
    pointsText = [[UITextView alloc] initWithFrame:CGRectMake(900, 50, 100, 100)];
    [pointsText setBackgroundColor:[UIColor clearColor]];
    [pointsText setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    pointsText.textColor = [UIColor redColor];
    [[self view] addSubview:pointsText];
    
    tapToDisplayInstructions = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayInstructions:)];
    [tapToDisplayInstructions setNumberOfTapsRequired:1];
    [tapToDisplayInstructions setEnabled:YES];
    [self.view addGestureRecognizer:tapToDisplayInstructions];
    
    tapToDisplaySettings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displaySettings:)];
    [tapToDisplaySettings setNumberOfTapsRequired:2];
    [tapToDisplaySettings setEnabled:YES];
    [self.view addGestureRecognizer:tapToDisplaySettings];
    
    swipeToEnterCardMode = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterCardMode:)];
    [swipeToEnterCardMode setEnabled:YES];
    [self.view addGestureRecognizer:swipeToEnterCardMode];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    stringFromInput = [[NSMutableString alloc] init];
    pointsText.hidden = true;
}

- (void)viewDidUnload {
    [self setScreenTitle:nil];
    [super viewDidUnload];
}


#pragma mark - Gestures

-(void)displayInstructions:(UIGestureRecognizer *)gestureRecognizer{
    [infoText setText:(instructionsText)];
}

- (void)displaySettings:(UIGestureRecognizer *)gestureRecognizer{
    [infoText setText:(settingsText)];
}

- (void)enterCardMode:(UIGestureRecognizer *)gestureRecognizer{
    infoText.text = nil;
    self.screenTitle.hidden = true;
    pointsText.hidden = false;
    [self enterCardMode];
}


#pragma mark - Card Mode

-(void)enterCardMode{
    pointsText.text = @"0";
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[arc4random() % maxCards]]; // Display the word.
}

-(void)changeCard: (int) newRandomCardIndex{
    [typedText setText:cards[newRandomCardIndex]];
    NSLog(@"changing!");
}

-(void)checkCard{
    if (cardText.text == typedText.text) {
        NSLog(@"Correct!");
        [self changeCard:(arc4random() % maxCards)];  // Random card index
    }
}

/**
 * Speak character being typed, as well as appending it to the label.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSArray *)info {
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

@end
