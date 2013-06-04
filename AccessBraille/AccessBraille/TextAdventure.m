//
//  TextAdventure.m
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "TextAdventure.h"

@interface TextAdventure ()

@end

@implementation TextAdventure

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    path = [[NSBundle mainBundle] bundlePath];
    finalPath = [path stringByAppendingPathComponent:@"adventureTexts.plist"];
    texts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    speaker = [[ABSpeak alloc]init];
    [speaker speakString:[texts valueForKey:@"initialText"]];
    
    UITapGestureRecognizer* tapToStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame:)];
    [tapToStart setEnabled:YES];
    [self.view addGestureRecognizer:tapToStart];
    
    stringFromInput = [[NSMutableString alloc] init];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake(50, 650, 200, 50)];
    [typedText setBackgroundColor:[UIColor greenColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    typedText.textColor = [UIColor blackColor];
    [typedText setUserInteractionEnabled:NO];
    
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [infoText setText:[texts valueForKey:@"initialText"]];
    [infoText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [infoText setBackgroundColor:[UIColor clearColor]];
    [infoText setUserInteractionEnabled:NO];
    [[self view] addSubview:infoText];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Gameplay Methods

-(void)startGame:(UIGestureRecognizer* )tapToStart{
    [tapToStart setEnabled:NO];
    [[self view] addSubview:typedText];
    [speaker speakString:[texts valueForKey:@"wakeupText"]];
    [infoText setText:[texts valueForKey:@"wakeupText"]];
    
    // Initialize Game Elements
    pack = [[NSMutableArray alloc]initWithCapacity:3];
    currentLocation = [[NSString alloc] initWithString:[texts valueForKey:@"roomDescription"]];
}

/**
 * Add a pickup to the pack array.
 */
-(void)stashObject:(NSString* )item {
    [pack addObject:item];
}


-(void)changeToRoom:(NSString* )room {
    if ([room isEqual: @"waterfront"]){
        currentLocation = [texts valueForKey:@"waterfrontDescription"];
    }
}


#pragma mark - Keyboard Methods

/**
 * Speak character being typed, as well as appending it to the UITextView.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    if ([info[ABSpaceTyped] boolValue]){
        [self checkCommand:typedText.text];
        [self clearStrings];
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

/**
 * Bulk of the logic occurs here. Checks command to appropriately
 * speak and print the message, or call necessary gameplay methoods
 * like room changing or item stashing.
 */
-(void)checkCommand:(NSString* )command{
    if ([command isEqualToString:@"look"]){
        [speaker speakString:currentLocation]; // Breaks on a prompt call for some reason.
        [infoText setText:currentLocation];
    } else if ([command isEqualToString:@"book"]){
        if ([pack containsObject:@"book"]){
            [self prompt:@"bookDescription"];
        } else {
            [self prompt:@"bookPickup"];
            [self stashObject:@"book"];
        }
    } else if ([command isEqualToString:@"help"]){
        [self prompt:@"helpText"];
    } else if ([command isEqualToString:@"pack"]){
        NSString* packContents = [pack componentsJoinedByString:@" "];
        [speaker speakString:packContents];
    } else if ([command isEqualToString:@"move"]){
        if ([currentLocation isEqualToString:[texts valueForKey:@"roomDescription"]]){
            [self prompt:@"roomLeave"];
            [self changeToRoom:@"waterfront"];
        }
    } else if ([command isEqualToString:@"use"]){
        if ([pack[0] isEqual: @"book"]){
            [self prompt:@"book"];
        }
    } else {
        [speaker speakString:@"Not sure about that. Try something else..."];
    }
}

#pragma mark - Helper Methods

/**
 * Speaks the message associated with the command as well as changing
 * the info text to represent what's being spoken.
 */
-(void)prompt:(NSString *)description {
    [speaker speakString:[texts valueForKey:description]];
    [infoText setText:[texts valueForKey:description]];
}

-(void)clearStrings{
    typedText.text = @"";
    [stringFromInput setString:@""];
}

@end
