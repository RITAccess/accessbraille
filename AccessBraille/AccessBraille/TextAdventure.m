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
    
    isPlaying = NO;
    
    _path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [_path stringByAppendingPathComponent:@"adventureTexts.plist"];
    _texts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    speaker = [[ABSpeak alloc]init];
    [speaker speakString:[_texts valueForKey:@"initialText"]];
    
    UITapGestureRecognizer* tapToStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame:)];
    [tapToStart setEnabled:YES];
    [self.view addGestureRecognizer:tapToStart];
    
    _stringFromInput = [[NSMutableString alloc] init];
    
    _typedText = [[UITextView alloc]initWithFrame:CGRectMake(50, 650, 200, 50)];
    [_typedText setBackgroundColor:[UIColor greenColor]];
    [_typedText setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    _typedText.textColor = [UIColor blackColor];
    [_typedText setUserInteractionEnabled:NO];
    
    _infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [_infoText setText:[_texts valueForKey:@"initialText"]];
    [_infoText setFont:[UIFont fontWithName:@"ArialMT" size:40]];
    [_infoText setBackgroundColor:[UIColor clearColor]];
    [_infoText setUserInteractionEnabled:NO];
    [[self view] addSubview:_infoText];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Gameplay Methods

-(void)startGame:(UIGestureRecognizer* )tapToStart
{
    [tapToStart setEnabled:NO];
    [[self view] addSubview:_typedText];
    [self prompt:@"crashSite"];
    
    // Initialize Game Elements    
    _pack = [[NSMutableArray alloc]initWithCapacity:3];
    _currentLocation = [[NSMutableString alloc] initWithString:@"crashSite"];
}

/**
 * Add a pickup to the pack array.
 */
-(void)stashObject:(NSString* )item
{
    [_pack addObject:item];
}

#pragma mark - Keyboard Methods

/**
 * Speak character being typed, as well as appending it to the UITextView.
 */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info
{
    if ([info[ABSpaceTyped] boolValue]){
        [self checkCommand:_typedText.text];
        [self clearStrings];
    } else {
        // Remove character from typed string if backspace detected.
        if ([info[ABBackspaceReceived] boolValue]){
            if (_stringFromInput.length > 0) {
                [_stringFromInput deleteCharactersInRange:NSMakeRange(_stringFromInput.length - 1, 1)];
                [_typedText setText:_stringFromInput];
            }
        } else {
            [speaker speakString:character];
            [_stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [_typedText setText:_stringFromInput]; // Sets typed text to the label.
        }
    }
}

/**
 * Bulk of the logic occurs here. Checks command to appropriately
 * speak and print the message, or call necessary gameplay methoods
 * like room changing or item stashing.
 */
-(void)checkCommand:(NSString* )command
{
    BOOL doorUnlocked = NO;
    
    if ([command isEqualToString:@"look"])
    {
        [self prompt:_currentLocation];
    }
    else if ([command isEqualToString:@"move"])
    {
        if ([_currentLocation isEqualToString:@"crashSite"])
        {
            [self prompt:@"crashSiteLeave"];
            _currentLocation = @"forestFloor";
        }
        else if ([_currentLocation isEqualToString:@"forestFloor"])
        {
            [self prompt:@"forestFloorLeave"];
            _currentLocation = @"secretCabin";
        }
        else if ([_currentLocation isEqualToString:@"secretCabin"])
        {
            if (doorUnlocked)
            {
                [self prompt:@"secretCabinLeave"];
                _currentLocation = @"cabinFloor";
            }
            else
            {
                [self prompt:@"secretCabinBlock"];
            }
        }
        
        NSLog(@"Moved to: %@", _currentLocation);
    }
    // Pick Command - Used for obtaining new items and inserting them into the pack.
    else if ([command isEqualToString:@"pick"])
    {
        NSLog(@"Picking up at %@", _currentLocation);
        if ([_currentLocation isEqualToString:@"forestFloor"])
        {
            if (![_pack containsObject:@"key"])
            {
                [_pack addObject:@"key"];
                [self prompt:@"forestFloorPickup"];
            }
            else
            {
                [self prompt:@"pickBlock"];
            }
        }
    }
    else if ([command isEqualToString:@"use"])
    {
        if ([_currentLocation isEqualToString:@"secretCabin"] && [_pack containsObject:@"key"])
        {
            [self prompt:@"keyUse"];
        }        
    }
    else if ([command isEqualToString:@"pack"])
    {
        NSString* packContents = [_pack componentsJoinedByString:@" "];
        [speaker speakString:packContents];
    }
    else if ([command isEqualToString:@"help"])
    {
        [self prompt:@"helpText"];
    }
    else
    {
        [speaker speakString:@"Not sure about that. Try something else..."];
    }
}

#pragma mark - Helper Methods

/**
 * Speaks the message associated with the command as well as changing
 * the info text to represent what's being spoken.
 */
-(void)prompt:(NSString *)description
{
    [speaker speakString:[_texts valueForKey:description]];
    _infoText.text = [_texts valueForKey:description]; // This breaks for some reason...
}

-(void)clearStrings
{
    _typedText.text = @"";
    [_stringFromInput setString:@""];
}

@end
