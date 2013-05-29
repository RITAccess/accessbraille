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
    UISwipeGestureRecognizer *swipeToSelectEasy;
    UISwipeGestureRecognizer *swipeToSelectMedium;
    UISwipeGestureRecognizer *swipeToSelectHard;
    UITextView *typedText;
    UITextView *cardText;
    UITextView *pointsText;
    NSMutableArray *cards;
    NSArray *card;
    NSMutableString *stringFromInput;
    NSArray *letters;
    UITextView *infoText;
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    int points;
    NSString *finalPath;
    NSString *path;
    SystemSoundID correctSound;
    SystemSoundID incorrectSound;
}

#pragma mark - View

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [infoText setText:welcomeText];
    [infoText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [infoText setBackgroundColor:[UIColor clearColor]];
    [infoText setUserInteractionEnabled:NO];
    [[self view] addSubview:infoText];
    
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
    
    pointsText = [[UITextView alloc] initWithFrame:CGRectMake(900, 50, 100, 100)];
    [pointsText setBackgroundColor:[UIColor clearColor]];
    [pointsText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    pointsText.textColor = [UIColor redColor];
    [[self view] addSubview:pointsText];
    
    
    
    stringFromInput = [[NSMutableString alloc] init];
    speaker = [[ABSpeak alloc] init];
    
    pointsText.hidden = true;
    
    [self hideSwipeLabels:false];
//    self.screenTitle.hidden = true;
    
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

}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    [self hideSwipeLabels:true]; 
    pointsText.hidden = true;
    
    correctSound = [self createSoundID:@"correct.aiff"];
    incorrectSound = [self createSoundID:@"incorrect.aiff"];
    
//    [speaker speakString:welcomeText];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Gestures

- (void)enterEasyMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self hideSwipeLabels:true];
    self.screenTitle.hidden = true;
    infoText.text = nil;
    pointsText.hidden = false;
    pointsText.text = [NSString stringWithFormat:@"%d", points];
    [self initializeCards:@"easy.plist"];
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    
    [cardText setText:cards[arc4random() % maxEasyCards]]; // Display the word.
}

- (void)enterMediumMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self hideSwipeLabels:true];
    self.screenTitle.hidden = true;
    infoText.text = nil;
    pointsText.hidden = false;
    pointsText.text = [NSString stringWithFormat:@"%d", points];
    [self initializeCards:@"medium.plist"];
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    
    [cardText setText:cards[arc4random() % maxMediumCards]]; // Display the word.
}

- (void)enterHardMode:(UIGestureRecognizer *)withGestureRecognizer{
    [self hideSwipeLabels:true];
    self.screenTitle.hidden = true;
    infoText.text = nil;
    pointsText.hidden = false;
    pointsText.text = [NSString stringWithFormat:@"%d", points];
    [self initializeCards:@"hard.plist"];
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    
    [cardText setText:cards[arc4random() % maxHardCards]]; // Display the word.
}

-(void)hideSwipeLabels:(BOOL)toDisplay{
    self.easyModeLabel.hidden = toDisplay;
    self.mediumModeLabel.hidden = toDisplay;
    self.hardModeLabel.hidden = toDisplay;
}
//
//- (void)selectDifficulty:(UIGestureRecognizer *)gestureRecognizer{
//
//}


-(void)initializeCards:(NSString* )withDifficulty{
    path = [[NSBundle mainBundle] bundlePath];
    finalPath = [path stringByAppendingPathComponent:withDifficulty];
    cards = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
}


#pragma mark - Card Mode

-(void)checkCard{
    if ([cardText.text isEqualToString:typedText.text]) { // If the typed string matches the card.
        AudioServicesPlaySystemSound(correctSound);
        pointsText.text = [NSString stringWithFormat:@"%d", ++points];
        [cardText setText:cards[arc4random() % maxHardCards]];
        [self clearStrings];
    }
    else{
        AudioServicesPlaySystemSound(incorrectSound);
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
        [self checkCard];
    }else{
        if ([info[ABBackspaceReceived] boolValue]){ // Remove character from typed string if backspace detected.
            if (stringFromInput.length > 0) {
                [stringFromInput deleteCharactersInRange:NSMakeRange(stringFromInput.length - 1, 1)];
                [typedText setText:stringFromInput];
            }
        }
        else{
            [speaker speakString:character];
            [stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [typedText setText:stringFromInput]; // Sets typed text to the label.
        }
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
