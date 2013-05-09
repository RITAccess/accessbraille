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
    typedText.textColor = [UIColor greenColor];
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
    pointsText.text = [NSString stringWithFormat:@"%d", points];
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [cardText setText:cards[arc4random() % maxEasyCards]]; // Display the word.
}

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
