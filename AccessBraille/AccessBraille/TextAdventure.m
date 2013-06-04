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

#pragma mark -
#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    speaker = [[ABSpeak alloc]init];
    [speaker speakString:initialText];
    
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
    [infoText setText:initialText];
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


#pragma mark - 
#pragma mark - Gameplay Methods

-(void)startGame:(UIGestureRecognizer* )tapToStart{
    [tapToStart setEnabled:NO];
    [[self view] addSubview:typedText];
    [speaker speakString:initialText];
    
    // Initialize Game Elements
    pack = [[NSMutableArray alloc]initWithCapacity:3];
    currentLocation = [[NSString alloc] initWithString:roomDescription];
}

/**
 * Add a pickup to the pack array.
 */
-(void)stashObject:(NSString* )item {
    [pack addObject:item];
}


-(void)changeToRoom:(NSString* )room {
    if ([room isEqual: @"waterfront"]){
        currentLocation = waterfrontDescription;
    }
}


#pragma mark - 
#pragma mark - Keyboard Methods

/**
 * Speak character being typed, as well as appending it to the UITextView.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    if ([character isEqual: @" "]){
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

-(void)checkCommand:(NSString* )command{
    if ([command isEqualToString:@"look"]){
        [speaker speakString:currentLocation];
    } else if ([command isEqualToString:@"book"]){
        [speaker speakString:@"That book will come in handy. You put it in your pack."];
        [self stashObject:@"book"];
    } else if ([command isEqualToString:@"help"]){
        [speaker speakString:helpText];
    } else if ([command isEqualToString:@"pack"]){
        NSString* packContents = [pack componentsJoinedByString:@" "];
        [speaker speakString:packContents];
    } else if ([command isEqualToString:@"move"]){
        [speaker speakString:@"You head to the door and leave the room"];
        [self changeToRoom:@"waterfront"];
    } else if ([command isEqualToString:@"use"]){
        if ([pack[0] isEqual: @"book"]){
            [speaker speakString:bookDescription];
        }
    } else {
        [speaker speakString:@"Not sure about that. Try something else..."];
    }
}

-(void)clearStrings{
    typedText.text = @"";
    [stringFromInput setString:@""];
}

@end
