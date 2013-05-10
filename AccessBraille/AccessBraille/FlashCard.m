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
#import "ABSpeak.h"

@interface FlashCard ()

@end

@implementation FlashCard {
    UITapGestureRecognizer *tapToDisplayInstructions;
    UITapGestureRecognizer *tapToDisplaySettings;
    UISwipeGestureRecognizer *swipeToSelectDifficulty;
    UISwipeGestureRecognizer *swipeToSelectEasy;
    UISwipeGestureRecognizer *swipeToSelectMedium;
    UISwipeGestureRecognizer *swipeToSelectHard;
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
    ABSpeak *speaker;
    int points;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Reading in the plist.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"easy.plist"];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [infoText setText:welcomeText];
    [infoText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [infoText setBackgroundColor:[UIColor clearColor]];
    infoText.editable = NO;
    infoText.scrollEnabled = NO;
    infoText.allowsEditingTextAttributes = NO;
    [[self view] addSubview:infoText];
    
    cardText = [[UITextView alloc] initWithFrame:CGRectMake((height / 2) - 200, (width / 2) - 200, 400, 300)];
    [cardText setBackgroundColor:[UIColor clearColor]];
    [cardText setFont:[UIFont fontWithName:@"ArialMT" size:140]];
    cardText.editable = NO;
    cardText.scrollEnabled = NO;
    cardText.allowsEditingTextAttributes = NO;
    [[self view] addSubview:cardText];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake((height / 2) - 200, (width / 2) - 200, 400, 300)];
    [typedText setBackgroundColor:[UIColor clearColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:140]];
    typedText.editable = NO;
    typedText.scrollEnabled = NO;
    typedText.textColor = [UIColor colorWithRed:0.f green:.8 blue:0.f alpha:1.f];
    [[self view] addSubview:typedText];
    
    pointsText = [[UITextView alloc] initWithFrame:CGRectMake(900, 50, 100, 100)];
    [pointsText setBackgroundColor:[UIColor clearColor]];
    [pointsText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
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
    
    swipeToSelectDifficulty = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectDifficulty:)];
    [swipeToSelectDifficulty setEnabled:YES];
    [self.view addGestureRecognizer:swipeToSelectDifficulty];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    self.easyModeLabel.hidden = true;
    self.mediumModeLabel.hidden = true;
    self.hardModeLabel.hidden = true;
    stringFromInput = [[NSMutableString alloc] init];
    pointsText.hidden = true;
}

- (void)viewDidUnload {
    [self setScreenTitle:nil];
    [self setMediumModeLabel:nil];
    [self setHardModeLabel:nil];
    [self setEasyModeLabel:nil];
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
    [swipeToSelectDifficulty setEnabled:false];
    infoText.text = nil;
    self.screenTitle.hidden = true;
    pointsText.hidden = false;
    pointsText.text = [NSString stringWithFormat:@"%d", points];
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[arc4random() % maxEasyCards]]; // Display the word.
    self.easyModeLabel.hidden = true;
    self.mediumModeLabel.hidden = true;
    self.hardModeLabel.hidden = true;
    
}

- (void)selectDifficulty:(UIGestureRecognizer *)gestureRecognizer{
    infoText.text = nil;
    self.screenTitle.hidden = true;
    pointsText.hidden = true;
    self.easyModeLabel.hidden = false;
    self.mediumModeLabel.hidden = false;
    self.hardModeLabel.hidden = false;
    
    swipeToSelectEasy = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterCardMode:)];
    [swipeToSelectEasy setEnabled:YES];
    [swipeToSelectEasy setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeToSelectEasy];
    
    swipeToSelectMedium = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterCardMode:)];
    [swipeToSelectMedium setEnabled:YES];
    [swipeToSelectEasy setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeToSelectMedium];
    
    swipeToSelectHard = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterCardMode:)];
    [swipeToSelectHard setEnabled:YES];
    [swipeToSelectEasy setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeToSelectHard];
}


#pragma mark - Card Mode

-(void)checkCard{
    SystemSoundID correctSound = [self createSoundID:@"correct.aiff"];
    SystemSoundID incorrectSound = [self createSoundID:@"incorrect.aiff"];
    NSLog(@"Checking Card...");
    if ([cardText.text isEqualToString:typedText.text]) {
        AudioServicesPlaySystemSound(correctSound);
        NSLog(@"Correct!");
        pointsText.text = [NSString stringWithFormat:@"%d", ++points];
        [cardText setText:cards[arc4random() % maxEasyCards]];
        [self clearStrings];
    }
    else{
        AudioServicesPlaySystemSound(incorrectSound);
        NSLog(@"Incorrect!");
    }
}

-(void)clearStrings{
    typedText.text = @"";
    [stringFromInput setString:@""];
}

/**
 * Speak character being typed, as well as appending it to the label.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    if ([character isEqual: @" "]){
        NSLog(@"It's a space!");
        [self checkCard];
    }else{
        [stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
        [typedText setText:stringFromInput]; // Sets typed text to the label.
        NSLog(@"Card: %@", cardText.text);
        NSLog(@"Typed: %@", typedText.text);
    }
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

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
