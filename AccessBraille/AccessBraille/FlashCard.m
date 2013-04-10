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
    NSTimer *speechTimer;
    NSMutableArray *cards;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
	
    // Title
    title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 60)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"Flash Card Mode"];
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
    
//    speechTimer = [NSTimer scheduledTimerWithTimeInterval:.1  target:self selector:@selector(speak) userInfo:nil repeats:NO];
}


- (void)viewDidAppear:(BOOL)animated {

    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

/**
 * 
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    // Your code goes here
    NSLog(@"You just typed %@", character);
}

/** 
 * Calls FliteController to speak. 
 */
- (void)speak
{
    [self.fliteController say:[self chooseCard] withVoice:self.slt];
    [self.fliteController say:title.text withVoice:self.slt];
}

/** 
 * Test method to pick a card from an array and call speak() to say the card. 
 */
- (NSString*)chooseCard{
//    cards = [NSArray arrayWithObjects:@"cat",@"red",@"top",nil];
    
    NSString *card = [cards objectAtIndex:1];
    
    return card;
}

@end
