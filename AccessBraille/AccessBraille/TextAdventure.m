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
    
    // Initialize Game Elements
    _pack = [[NSMutableArray alloc]initWithCapacity:3];
    _currentLocation = [[NSMutableString alloc] initWithString:@"crashSite"];
    
    _path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [_path stringByAppendingPathComponent:@"adventureTexts.plist"];
    _texts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    speaker = [ABSpeak sharedInstance];
    
    UITapGestureRecognizer* tapToStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame:)];
    [tapToStart setEnabled:YES];
    [self.view addGestureRecognizer:tapToStart];
    
    _stringFromInput = [[NSMutableString alloc] init];
    
    _typedText = [[UITextView alloc]initWithFrame:CGRectMake(50, 650, 200, 50)];
    [_typedText setBackgroundColor:[UIColor colorWithHue:50 saturation:10 brightness:91 alpha:.5]];
    [_typedText setFont:[UIFont boldSystemFontOfSize:35]];
    _typedText.textColor = [UIColor blackColor];
    _typedText.layer.cornerRadius = 5;
    [_typedText setUserInteractionEnabled:NO];
    
    _infoText = [[UITextView alloc]initWithFrame:CGRectMake(50, 150, 900, 400)];
    [_infoText setFont:[UIFont boldSystemFontOfSize:40]];
    [_infoText setBackgroundColor:[UIColor clearColor]];
    [_infoText setUserInteractionEnabled:NO];
    [[self view] addSubview:_infoText];
    
    [self prompt:@"initialText"];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [speaker stopSpeaking];
}


#pragma mark - Gameplay Methods

-(void)startGame:(UIGestureRecognizer* )tapToStart
{
    [tapToStart setEnabled:NO];
    [[self view] addSubview:_typedText];
    
    [self initSoundWithFileName:@"crashSite"];
    [self prompt:@"crashSiteLook"];
}

/**
 * Bulk of the logic occurs here. Checks command to appropriately
 * speak and print the message, or call necessary gameplay methoods
 * like room changing or item stashing.
 */
- (void)checkCommand:(NSString* )command
{
    NSString *leaveString = [NSString stringWithFormat:@"%@Leave", _currentLocation];
    NSString *blockString = [NSString stringWithFormat:@"%@Block", _currentLocation];
    NSString *backString = [NSString stringWithFormat:@"%@Back", _currentLocation];
    NSString *rightString = [NSString stringWithFormat:@"%@Right", _currentLocation];
    NSString *leftString = [NSString stringWithFormat:@"%@Left", _currentLocation];
    
    if ([command isEqualToString:@"look"])
    {
        NSString *lookString = [NSString stringWithFormat:@"%@Look", _currentLocation];
        NSLog(@"%@", _currentLocation);
        [self initSoundWithFileName:lookString];
        [self prompt:lookString];
    }
    else if ([command isEqualToString:@"move"])
    {
        if ([_currentLocation isEqualToString:@"crashSite"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            _currentLocation = @"forestFloor";
        }
        else if ([_currentLocation isEqualToString:@"forestFloor"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            _currentLocation = @"secretCabin";
        }
        else if ([_currentLocation isEqualToString:@"giantTree"]){
            [self initSoundWithFileName:@"darkCaveBlock"];
            [self prompt:blockString];
        }
        else if ([_currentLocation isEqualToString:@"secretCabin"]){
            if (doorUnlocked) {
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                _currentLocation = @"cabinFloor";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([_currentLocation isEqualToString:@"cabinFloor"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            _currentLocation = @"windyLake";
        }
        else if ([_currentLocation isEqualToString:@"windyLake"]){
            if (sailAttached) {
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                _currentLocation = @"darkCave";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([_currentLocation isEqualToString:@"darkCave"]){
            if (caveLit){
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                _currentLocation = @"finalCavern";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([_currentLocation isEqualToString:@"sideCave"]){
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:blockString];
        }
        else if ([_currentLocation isEqualToString:@"finalCavern"]){
            if (collectedSilver){
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                _currentLocation = @"finalCavern";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
    }
    else if ([command isEqualToString:@"right"]) // Tries to move right.
    {
        if ([_currentLocation isEqualToString:@"forestFloor"])
        {
            [self initSoundWithFileName:leaveString];
            [self prompt:rightString];
            _currentLocation = @"giantTree";
        }
        else
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"rightBlock"];
        }
        
    }
    else if ([command isEqualToString:@"left"]) // Tries to move left.
    {
        if ([_currentLocation isEqualToString:@"darkCave"])
        {
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:leftString];
            _currentLocation = @"sideCave";
        }
        else
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"leftBlock"];
        }
    }
    else if ([command isEqualToString:@"back"])
    {
        if ([_currentLocation isEqualToString:@"crashSite"] ||
            [_currentLocation isEqualToString:@"darkCave"]) {
            [self prompt:@"backBlock"];
        }
        else if ([_currentLocation isEqualToString:@"forestFloor"]){
            [self initSoundWithFileName:@"crashSiteLeave"];
            [self prompt:backString];
            _currentLocation = @"crashSite";
        }
        else if ([_currentLocation isEqualToString:@"giantTree"]){
            [self initSoundWithFileName:@"forestFloorLeave"];
            [self prompt:backString];
            _currentLocation = @"forestFloor";
        }
        else if ([_currentLocation isEqualToString:@"secretCabin"]){
            [self initSoundWithFileName:@"crashSiteLeave"];
            [self prompt:backString];
            _currentLocation = @"forestFloor";
        }
        else if ([_currentLocation isEqualToString:@"cabinFloor"]){
            [self initSoundWithFileName:@"cabinFloorLeave"];
            [self prompt:backString];
            _currentLocation = @"secretCabin";
        }
        else if ([_currentLocation isEqualToString:@"windyLake"]){
            [self initSoundWithFileName:@"cabinFloorLeave"];
            [self prompt:backString];
            _currentLocation = @"cabinFloor";
        }
        else if ([_currentLocation isEqualToString:@"sideCave"]){
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:backString];
            _currentLocation = @"darkCave";
        }
        else if ([_currentLocation isEqualToString:@"finalCavern"]){
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:backString];
            _currentLocation = @"darkFloor";
        }
        
    }
    else if ([command isEqualToString:@"pick"])
    {
        NSString *pickString = [NSString stringWithFormat:@"%@Pick", _currentLocation];
        
        if ([_currentLocation isEqualToString:@"crashSite"]
            || [_currentLocation isEqualToString:@"secretCabin"]
            || [_currentLocation isEqualToString:@"windyLake"])
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"pickBlock"];
        }
        else if ([_currentLocation isEqualToString:@"cabinFloor"])
        {
            if (chestOpened && ![_pack containsObject:pickString]){
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [_pack addObject:pickString];
            } else {
                [self initSoundWithFileName:@"secretCabinBlock"];
                [self prompt:@"wrongCommand"];
            }
        }
        else if ([_currentLocation isEqualToString:@"finalCavern"])
        {
            if (![_pack containsObject:pickString]){
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [_pack addObject:pickString];
                collectedSilver = YES;
            } else {
                [self initSoundWithFileName:@"femaleHmm"];
                [self prompt:@"pickBlock"];
            }
        }
        else
        {
            if ([_pack containsObject:pickString]){
                [self initSoundWithFileName:@"femaleHmm"];
                [self prompt:@"pickBlock"];
            } else {
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [_pack addObject:pickString];
            }
        }

    }
    else if ([command isEqualToString:@"use"])
    {
        NSString *useString = [NSString stringWithFormat:@"%@Use", _currentLocation];
        
        if ([_currentLocation isEqualToString:@"secretCabin"] && [_pack containsObject:@"forestFloorPick"])
        {
            doorUnlocked = YES;
            [self initSoundWithFileName:useString];
            [self prompt:useString];
            [_pack removeObject:@"key"];
        }
        else if ([_currentLocation isEqualToString:@"windyLake"] && [_pack containsObject:@"cabinFloorPick"])
        {
            sailAttached = YES;
            [self initSoundWithFileName:useString  ]; // Still need sail attach sound...
            [self prompt:useString];
            [_pack removeObject:@"sail"];
        }
        else if ([_currentLocation isEqualToString:@"darkCave"] && [_pack containsObject:@"darkCavePick"])
        {
            caveLit = YES;
            [self initSoundWithFileName:useString]; // Still need sail attach sound...
            [self prompt:useString];
        }
        else {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"useBlock"];
        }
    }
    else if ([command isEqualToString:@"pack"]) // Speaks the content of the pack.
    {
        NSString* packContents = [_pack componentsJoinedByString:@" "];
        [speaker speakString:packContents];
    }
    else if ([command isEqualToString:@"wind"])
    {
        if ([_currentLocation isEqualToString:@"cabinFloor"] && !chestOpened)
        {
            chestOpened = YES;
            [self prompt:@"cabinFloorPuzzle"];
            [self initSoundWithFileName:@"cabinFloorPuzzle"];
        }
        else
        {
            [self prompt:@"wrongCommand"];
        }
    }
    else if ([command isEqualToString:@"help"])
    {
        [self prompt:@"helpText"];
    }
    else
    {
        [self prompt:@"wrongCommand"];
    }
}

- (void)initSoundWithFileName:(NSString *)soundName
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"aiff"];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    [avPlayer play];
}

#pragma mark - Helper Methods

/**
 * Speaks the message associated with the command as well as changing
 * the info text to represent what's being spoken.
 */
- (void)prompt:(NSString *)description
{
    [speaker speakString:[_texts valueForKey:description]];
    _infoText.text = [_texts valueForKey:description]; // This breaks for some reason...
}

- (void)clearStrings
{
    _typedText.text = @"";
    [_stringFromInput setString:@""];
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
            [_stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [_typedText setText:_stringFromInput]; // Sets typed text to the label.
        }
    }
}

@end
