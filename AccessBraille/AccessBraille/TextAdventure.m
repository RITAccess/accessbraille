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
//    [speaker speakString:@"Would you care to start an exciting text-based adventure? Tap once to begin."];
    
    UITapGestureRecognizer* tapToStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame:)];
    [tapToStart setEnabled:YES];
    [self.view addGestureRecognizer:tapToStart];
    
    stringFromInput = [[NSMutableString alloc] init];
    
    typedText = [[UITextView alloc]initWithFrame:CGRectMake(50, 650, 200, 50)];
    [typedText setBackgroundColor:[UIColor greenColor]];
    [typedText setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    typedText.textColor = [UIColor blackColor];
    [typedText setUserInteractionEnabled:NO];
    [[self view] addSubview:typedText];
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
//    [speaker speakString:@"You wake up in your bed. Type LOOK to see what's around you."];
    pack = [[NSMutableArray alloc]initWithCapacity:3];
}

-(void)stashObject:(NSString* )item {
    [pack insertObject:item atIndex:0];
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
        NSLog(@"Looking...");
//        [speaker speakString:@"You survey your surroundings. You're in a room filled with jelly beans."];
    } else if ([command isEqualToString:@"book"]){
        [speaker speakString:@"That book will come in handy. You put it in your pack."];
        [self stashObject:@"book"];
    } else if ([command isEqualToString:@"help"]){
        [speaker speakString:helpText];
    } else if ([command isEqualToString:@"pack"]){
        NSString* packContents = [pack componentsJoinedByString:@" "];
        NSLog(@"%@", packContents);
        [speaker speakString:packContents];
    }
}

-(void)clearStrings{
    typedText.text = @"";
    [stringFromInput setString:@""];
}

@end
