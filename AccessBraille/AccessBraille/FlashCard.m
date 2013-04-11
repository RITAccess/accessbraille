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
    [title setText:@"Flash Card Mode"];
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
    
    // Typed Character
    typedCharacter = [[UILabel alloc]initWithFrame:CGRectMake(500, 100, 300, 300)];
    [[self view] addSubview:typedCharacter];
    [typedCharacter setFont: [UIFont fontWithName:@"Trebuchet MS" size:60.0f]];
    
//    speechTimer = [NSTimer scheduledTimerWithTimeInterval:.1  target:self selector:@selector(speak) userInfo:nil repeats:NO];
}


- (void)viewDidAppear:(BOOL)animated {

    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

/**
 * Speaks current character that's being typed.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    NSLog(@"You just typed %@", character);
    [self.fliteController say:character withVoice:self.slt];
    NSMutableString* word = [[NSMutableString alloc] init];
    [word appendFormat:@"%@", character];
    [typedCharacter setText:word];
}

@end
