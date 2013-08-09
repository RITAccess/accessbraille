//
//  TimetripViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "TimetripViewController.h"

@implementation TimetripViewController
{
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    AVAudioPlayer *avPlayer;
    
    NSMutableArray *pack;
    NSString *currentLocation;
    NSMutableString *stringFromInput;
    BOOL isPlaying, doorUnlocked, sailAttached, chestOpened, caveLit, collectedSilver;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Game Elements
    pack = [[NSMutableArray alloc]initWithCapacity:3];
    currentLocation = [[NSMutableString alloc] initWithString:@"crashSite"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"adventureTexts.plist"];
    _texts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    keyboard = [[ABKeyboard alloc]initWithDelegate:self];
    speaker = [ABSpeak sharedInstance];
    
    _tapToStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame:)];
    [_tapToStart setEnabled:YES];
    [self.view addGestureRecognizer:_tapToStart];
    
    stringFromInput = [NSMutableString new];
    
    [_typedText.layer setCornerRadius:5];
    
    [self prompt:@"initialText"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
    
    [_infoText setFont:[UIFont boldSystemFontOfSize:40]];
    [_typedText setFont:[UIFont boldSystemFontOfSize:35]];
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

-(void)startGame:(UITapGestureRecognizer* )tapToStart
{
    [_tapToStart setEnabled:NO];
    [[self view] addSubview:_typedText];
    
    [self initSoundWithFileName:@"crashSite"];
    [self prompt:@"crashSiteLook"];
    
    [_infoText setFont:[UIFont boldSystemFontOfSize:40]];
    [_typedText setFont:[UIFont boldSystemFontOfSize:35]];
}

/**
 * Bulk of the logic occurs here. Checks command to appropriately
 * speak and print the message, or call necessary gameplay methoods
 * like room changing or item stashing.
 */
- (void)checkCommand:(NSString* )command
{
    NSString *leaveString = [NSString stringWithFormat:@"%@Leave", currentLocation];
    NSString *blockString = [NSString stringWithFormat:@"%@Block", currentLocation];
    NSString *backString = [NSString stringWithFormat:@"%@Back", currentLocation];
    NSString *rightString = [NSString stringWithFormat:@"%@Right", currentLocation];
    NSString *leftString = [NSString stringWithFormat:@"%@Left", currentLocation];
    
    if ([command isEqualToString:@"look"])
    {
        NSString *lookString = [NSString stringWithFormat:@"%@Look", currentLocation];
        [self initSoundWithFileName:lookString];
        [self prompt:lookString];
    }
    else if ([command isEqualToString:@"move"])
    {
        if ([currentLocation isEqualToString:@"crashSite"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            currentLocation = @"forestFloor";
        }
        else if ([currentLocation isEqualToString:@"forestFloor"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            currentLocation = @"secretCabin";
        }
        else if ([currentLocation isEqualToString:@"giantTree"]){
            [self initSoundWithFileName:@"darkCaveBlock"];
            [self prompt:blockString];
        }
        else if ([currentLocation isEqualToString:@"secretCabin"]){
            if (doorUnlocked) {
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                currentLocation = @"cabinFloor";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([currentLocation isEqualToString:@"cabinFloor"]){
            [self initSoundWithFileName:leaveString];
            [self prompt:leaveString];
            currentLocation = @"windyLake";
        }
        else if ([currentLocation isEqualToString:@"windyLake"]){
            if (sailAttached) {
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                currentLocation = @"darkCave";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([currentLocation isEqualToString:@"darkCave"]){
            if (caveLit){
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                currentLocation = @"finalCavern";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
        else if ([currentLocation isEqualToString:@"sideCave"]){
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:blockString];
        }
        else if ([currentLocation isEqualToString:@"finalCavern"]){
            if (collectedSilver){
                [self initSoundWithFileName:leaveString];
                [self prompt:leaveString];
                currentLocation = @"finalCavern";
            } else {
                [self initSoundWithFileName:blockString];
                [self prompt:blockString];
            }
        }
    }
    else if ([command isEqualToString:@"right"]) // Tries to move right.
    {
        if ([currentLocation isEqualToString:@"forestFloor"])
        {
            [self initSoundWithFileName:leaveString];
            [self prompt:rightString];
            currentLocation = @"giantTree";
        }
        else
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"rightBlock"];
        }
        
    }
    else if ([command isEqualToString:@"left"]) // Tries to move left.
    {
        if ([currentLocation isEqualToString:@"darkCave"])
        {
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:leftString];
            currentLocation = @"sideCave";
        }
        else
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"leftBlock"];
        }
    }
    else if ([command isEqualToString:@"back"])
    {
        if ([currentLocation isEqualToString:@"crashSite"] ||
            [currentLocation isEqualToString:@"darkCave"]) {
            [self prompt:@"backBlock"];
        }
        else if ([currentLocation isEqualToString:@"forestFloor"]){
            [self initSoundWithFileName:@"crashSiteLeave"];
            [self prompt:backString];
            currentLocation = @"crashSite";
        }
        else if ([currentLocation isEqualToString:@"giantTree"]){
            [self initSoundWithFileName:@"forestFloorLeave"];
            [self prompt:backString];
            currentLocation = @"forestFloor";
        }
        else if ([currentLocation isEqualToString:@"secretCabin"]){
            [self initSoundWithFileName:@"crashSiteLeave"];
            [self prompt:backString];
            currentLocation = @"forestFloor";
        }
        else if ([currentLocation isEqualToString:@"cabinFloor"]){
            [self initSoundWithFileName:@"cabinFloorLeave"];
            [self prompt:backString];
            currentLocation = @"secretCabin";
        }
        else if ([currentLocation isEqualToString:@"windyLake"]){
            [self initSoundWithFileName:@"cabinFloorLeave"];
            [self prompt:backString];
            currentLocation = @"cabinFloor";
        }
        else if ([currentLocation isEqualToString:@"sideCave"]){
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:backString];
            currentLocation = @"darkCave";
        }
        else if ([currentLocation isEqualToString:@"finalCavern"]){
            [self initSoundWithFileName:@"darkCaveLeave"];
            [self prompt:backString];
            currentLocation = @"darkFloor";
        }
        
    }
    else if ([command isEqualToString:@"pick"])
    {
        NSString *pickString = [NSString stringWithFormat:@"%@Pick", currentLocation];
        
        if ([currentLocation isEqualToString:@"crashSite"]
            || [currentLocation isEqualToString:@"secretCabin"]
            || [currentLocation isEqualToString:@"windyLake"])
        {
            [self initSoundWithFileName:@"femaleHmm"];
            [self prompt:@"pickBlock"];
        }
        else if ([currentLocation isEqualToString:@"cabinFloor"])
        {
            if (chestOpened && ![pack containsObject:pickString]){
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [pack addObject:pickString];
            } else {
                [self initSoundWithFileName:@"secretCabinBlock"];
                [self prompt:@"wrongCommand"];
            }
        }
        else if ([currentLocation isEqualToString:@"finalCavern"])
        {
            if (![pack containsObject:pickString]){
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [pack addObject:pickString];
                collectedSilver = YES;
            } else {
                [self initSoundWithFileName:@"femaleHmm"];
                [self prompt:@"pickBlock"];
            }
        }
        else
        {
            if ([pack containsObject:pickString]){
                [self initSoundWithFileName:@"femaleHmm"];
                [self prompt:@"pickBlock"];
            } else {
                [self initSoundWithFileName:pickString];
                [self prompt:pickString];
                [pack addObject:pickString];
            }
        }

    }
    else if ([command isEqualToString:@"use"])
    {
        NSString *useString = [NSString stringWithFormat:@"%@Use", currentLocation];
        
        if ([currentLocation isEqualToString:@"secretCabin"] && [pack containsObject:@"forestFloorPick"])
        {
            doorUnlocked = YES;
            [self initSoundWithFileName:useString];
            [self prompt:useString];
            [pack removeObject:@"key"];
        }
        else if ([currentLocation isEqualToString:@"windyLake"] && [pack containsObject:@"cabinFloorPick"])
        {
            sailAttached = YES;
            [self initSoundWithFileName:useString  ]; // Still need sail attach sound...
            [self prompt:useString];
            [pack removeObject:@"sail"];
        }
        else if ([currentLocation isEqualToString:@"darkCave"] && [pack containsObject:@"darkCavePick"])
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
        NSString* packContents = [pack componentsJoinedByString:@" "];
        [speaker speakString:packContents];
    }
    else if ([command isEqualToString:@"wind"])
    {
        if ([currentLocation isEqualToString:@"cabinFloor"] && !chestOpened)
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
    [stringFromInput setString:@""];
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
            if (stringFromInput.length > 0) {
                [stringFromInput deleteCharactersInRange:NSMakeRange(stringFromInput.length - 1, 1)];
                [_typedText setText:stringFromInput];
            }
        } else {
            [stringFromInput appendFormat:@"%@", character]; // Concat typed letters together.
            [_typedText setText:stringFromInput]; // Sets typed text to the label.
        }
    }
}

@end
