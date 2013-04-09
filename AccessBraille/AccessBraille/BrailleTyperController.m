//
//  ViewController.m
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

/**
    Controller for the Braille Typing interface
 */


#import "BrailleTyperController.h"
#import "Drawing.h"
#import "CalibrationPoint.h"
#import "BrailleInterpreter.h"
#import "NavigationContainer.h"
#import "NavigationView.h"
#import "UIBezelGestureRecognizer.h"
#import "Enabled.h"
#import "newViewControllerTemplate.h"
#import "TextOut.h"
#import "AppDelegate.h"
#import "BrailleTyper.h"
#import <CoreData/CoreData.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BrailleTyperController ()



@end

#pragma mark Implementation

@implementation BrailleTyperController {
    // Typing Mode
    NSTimer *typingTimeout;
    bool isTypingMode;
    
    // Brail Typing 
    UITapGestureRecognizer *BROneTap;
    UITapGestureRecognizer *BRTwoTap;
    UITapGestureRecognizer *BRThreeTap;
    UITapGestureRecognizer *BRFourTap;
    UITapGestureRecognizer *BRFiveTap;
    UITapGestureRecognizer *BRSixTap;
    
    // Interpreter
    BrailleInterpreter *bi;

    // Calibration Points
    NSMutableDictionary *cpByFinger;
    
    // State Change Gestues
    UILongPressGestureRecognizer *sixFingerHold;
    UITapGestureRecognizer *doubleTapExit;
    
    // Layout
    Enabled *enabled;
    
    // Audio
    SystemSoundID enabledSound;
    SystemSoundID disabledSound;
    SystemSoundID backspaceSound;
}

@synthesize typingStateOutlet = _typingStateOutlet;
@synthesize DrawingView = _DrawingView;

@synthesize fliteController;
@synthesize slt;

# pragma mark - ViewController Methods

/**
 Runs after load
*/
- (void)viewDidLoad {

    [super viewDidLoad];
    
    /// Braille Recognizer Gestures
    BROneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BROneTap setNumberOfTouchesRequired:1];
        [BROneTap setNumberOfTapsRequired:1];
        [BROneTap setEnabled:NO];
    BRTwoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRTwoTap setNumberOfTouchesRequired:2];
        [BRTwoTap setNumberOfTapsRequired:1];
        [BRTwoTap setEnabled:NO];
    BRThreeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRThreeTap setNumberOfTouchesRequired:3];
        [BRThreeTap setNumberOfTapsRequired:1];
        [BRThreeTap setEnabled:NO];
    BRFourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRFourTap setNumberOfTouchesRequired:4];
        [BRFourTap setNumberOfTapsRequired:1];
        [BRFourTap setEnabled:NO];
    BRFiveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRFiveTap setNumberOfTouchesRequired:5];
        [BRFiveTap setNumberOfTapsRequired:1];
        [BRFiveTap setEnabled:NO];
    BRSixTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BRTap:)];
        [BRSixTap setNumberOfTouchesRequired:6];
        [BRSixTap setNumberOfTapsRequired:1];
        [BRSixTap setEnabled:NO];
    
    /// State Switch **two finger for simulater testing**
    sixFingerHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sixFingerLong:)];
    [sixFingerHold setNumberOfTouchesRequired:6];
    sixFingerHold.minimumPressDuration = .75;
    doubleTapExit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitTyping:)];
    [doubleTapExit setNumberOfTapsRequired:2];
    [doubleTapExit setNumberOfTouchesRequired:1];
    [doubleTapExit setEnabled:NO];

    /// Add Recognizers to view
    [self.view addGestureRecognizer:BROneTap];
    [self.view addGestureRecognizer:BRTwoTap];
    [self.view addGestureRecognizer:BRThreeTap];
    [self.view addGestureRecognizer:BRFourTap];
    [self.view addGestureRecognizer:BRFiveTap];
    [self.view addGestureRecognizer:BRSixTap];
    [self.view addGestureRecognizer:sixFingerHold];
    [self.view addGestureRecognizer:doubleTapExit];

    // Set starting states for objects and init variables
    cpByFinger = [[NSMutableDictionary alloc] init];
    isTypingMode = false;
    bi = [[BrailleInterpreter alloc] initWithViewController:self];
    
    // Draw views
    enabled = [[Enabled alloc] initWithFrame:CGRectMake(971.5, 695.5, 44, 44)];
    enabled.enable = FALSE;
    [self.view addSubview:enabled];
    
    // Audio
    enabledSound = [self createSoundID:@"hop.mp3"];
    disabledSound = [self createSoundID:@"disable.mp3"];
    backspaceSound = [self createSoundID:@"backspace.aiff"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    /**
        Forwards autorotation to subviews
     */
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidAppear:(BOOL)animated {
    /**
        View Did Appear
     */
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    /**
        Did Move To Parent View Controller
     */
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    /**
        Will Move To Parent View Controller
     */
    
}

- (void)viewWillDisappear:(BOOL)animated {
    /**
        View Will Disappear
     */
    if (isTypingMode){
        [self endTyping];
    }
    [self saveState];
}

- (void)viewWillAppear:(BOOL)animated{
    /**
        View Will Appear
     */
    [self.view setFrame:self.parentViewController.view.frame];
    _TextDrawing.buf = [self getLastItemInTable];
}

-(void)saveState {
    /**
        Save all persistant varables
    */
    [self updateLastValue:[_TextDrawing getCurrentText]];
}

- (void)didReceiveMemoryWarning {
    /**
     Did receive memory warning
     */
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    /**
     view did unload
     */
    [self setDrawingView:nil];
    [self setTextOutput:nil];
    [self setTextDrawing:nil];
    [super viewDidUnload];
}

# pragma mark - Typing Methods

/**
 Gets called when in typing mode, proccesses taps and sends them off to the BrailleInterpreter class
 */
- (void)BRTap:(UITapGestureRecognizer *)reg{   
    
    
    // Assuming valid tap, continue typing
    [self beginTyping];
    NSMutableDictionary *touchPoints = [[NSMutableDictionary alloc] init];
    for(int t = 0; t < (int)reg.numberOfTouches; t++){
        CGPoint point = [reg locationOfTouch:t inView:reg.view];
        for (NSString *key in cpByFinger){
            
            CalibrationPoint *tmp = [cpByFinger objectForKey:key];
            if ([tmp tapInRadius:point]) {
                [touchPoints setObject:tmp forKey:[tmp getCurrentID]];
            }
        }
    }
    if (touchPoints.count > 0) {
        NSString *check = [bi getChar:touchPoints];
        if(![check isEqualToString:@"not"]){
            [self.fliteController say:check withVoice:self.slt];
            [_TextDrawing appendToText:check];
        }
    } else {
        
        int backSpaceBuf = 850;
        
        if ([bi getAverageYValue] < [reg locationInView:reg.view].y && [reg locationInView:reg.view].x < backSpaceBuf){
            [_TextDrawing appendToText:@" "];
            [self.fliteController say:[_TextDrawing parseLastWordfromString:[_TextDrawing getCurrentText]] withVoice:self.slt];
            
        } else if ([bi getAverageYValue] - 100 < [reg locationInView:reg.view].y && [reg locationInView:reg.view].x >= backSpaceBuf) {
            [_TextDrawing removeCharacter]; // Calls TextOut's removeCharacter()
            AudioServicesPlaySystemSound(backspaceSound);
        }
    }
}

- (void)clearText:(UIPinchGestureRecognizer *)reg {
    /**
        Clears Text
     */
}

- (void)sixFingerLong:(UILongPressGestureRecognizer *)reg{
    /**
        Six finger long press gesture calls this and switches the app into typing mode
     */
    
    switch (reg.state) {
        case 1:
            [self setUpTyping:reg];
            break;
            
        case 3:
            [self beginTyping];
            [sixFingerHold setEnabled:NO];
            break;
            
        default:
            break;
    }
}

- (void)setUpTyping:(UILongPressGestureRecognizer *)reg {
    NSArray *rawTouch;
    NSArray *sortedTouchPoints;
    NSArray *fingerIDs = @[@3,@2,@1,@4,@5,@6];
    NSSortDescriptor *sortXValues = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:TRUE];
    NSArray *sorters = @[ sortXValues ];
    
    // Enable Braille Recognizers
    [BROneTap setEnabled:YES];
    [BRTwoTap setEnabled:YES];
    [BRThreeTap setEnabled:YES];
    [BRFourTap setEnabled:YES];
    [BRFiveTap setEnabled:YES];
    [BRSixTap setEnabled:YES];
    [doubleTapExit setEnabled:YES];
    
    // Set callibration points
    rawTouch = @[
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:0 inView:reg.view] withTmpID:@0],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:1 inView:reg.view] withTmpID:@1],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:2 inView:reg.view] withTmpID:@2],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:3 inView:reg.view] withTmpID:@3],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:4 inView:reg.view] withTmpID:@4],
                 [[CalibrationPoint alloc] initWithCGPoint:[reg locationOfTouch:5 inView:reg.view] withTmpID:@5]
                 ];
    
    sortedTouchPoints = [rawTouch sortedArrayUsingDescriptors:sorters];
    for (int i = 0; i < 6; i++){
        CalibrationPoint *tmp = [sortedTouchPoints objectAtIndex:i];
        [tmp setNewID:[fingerIDs objectAtIndex:i]];
        [cpByFinger setValue:tmp forKey:[[tmp getCurrentID] stringValue]];
        [bi addCalibrationPoint:tmp];
    }
    // Configure radius and buffers in BI
    [bi setUpCalibration];
    
    // Audio feedback tone up
    AudioServicesPlaySystemSound(enabledSound);
    enabled.enable = true;
    [enabled setNeedsDisplay];
}

- (void)beginTyping {
    /**
        Starts the typing mode
     */
    
    _TextDrawing.end = [[NSDate alloc] init];
    
    if (!isTypingMode){
        // Start timer and switch to typing mode
        typingTimeout = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(endTyping) userInfo:nil repeats:false];
        isTypingMode = true;
        [enabled removeFromSuperview];
        [self.view addSubview:enabled];
        [_TextDrawing typingDidStart];
        
    } else {
        // Reset timer if in typing mode
        [typingTimeout invalidate];
        typingTimeout = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(endTyping) userInfo:nil repeats:false];
    }
}

- (void)exitTyping:(UITapGestureRecognizer *)reg{
    /**
        Double tap to exit typing mode if above typing location
     */
    if ([bi getAverageYValue] > ([reg locationInView:reg.view].y + [bi getMaxYDelta])) {
        [self endTyping];
    }
}

- (void)endTyping{
    /**
        Disables the typing mode
     */
    // End Timer
    [typingTimeout invalidate];
//    NSLog(@"End Typing");
    // Disable Typing
    AudioServicesPlaySystemSound(disabledSound);
    isTypingMode = false;
    enabled.enable = false;
    [_TextDrawing typingDidEnd];
    [enabled setNeedsDisplay];
    // Disable Braille Recognizers
    [BROneTap setEnabled:NO];
    [BRTwoTap setEnabled:NO];
    [BRThreeTap setEnabled:NO];
    [BRFourTap setEnabled:NO];
    [BRFiveTap setEnabled:NO];
    [BRSixTap setEnabled:NO];
    [doubleTapExit setEnabled:NO];
    // Enable Navigation Gestures
    [sixFingerHold setEnabled:YES];
    // Clear subview
    for (Drawing *v in [self.view subviews]){
        if ([v isKindOfClass:[Drawing class]]) {
            [v removeFromSuperview];
        }
    }
    [self updateLastValue:[_TextDrawing getCurrentText]];
    // Audio feedback tone down
}

#pragma mark - Access Core Data Methods

- (void)updateLastValue:(NSString *)content {
    /**
        Update CoreData object for this controller with new typed value. Creates a new row if one does not exist.
     */
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:@"BrailleTyper" inManagedObjectContext:app.managedObjectContext]];
    NSArray *results = [app.managedObjectContext executeFetchRequest:req error:NULL];
    if ([results count] == 0) {
        // Add row if empty
        BrailleTyper *cdEntry = (BrailleTyper *)[NSEntityDescription insertNewObjectForEntityForName:@"BrailleTyper" inManagedObjectContext:app.managedObjectContext];
        [cdEntry setTypedString:content];
        [cdEntry setTimeStamp:[NSDate date]];
        [app.managedObjectContext save:nil];
    } else {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setEntity:[NSEntityDescription entityForName:@"BrailleTyper" inManagedObjectContext:app.managedObjectContext]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [req setSortDescriptors:@[sortDescriptor]];
        NSArray *results = [app.managedObjectContext executeFetchRequest:req error:NULL];
        BrailleTyper *updateEntity = [results objectAtIndex:0];
        [updateEntity setTypedString:content];
        [updateEntity setTimeStamp:[NSDate date]];
        [app.managedObjectContext save:nil];
    }
}

- (NSString *)getLastItemInTable {
    /**
        Returns the last row from the CoreData object for this controller. Returns empty string if no table exists.
     */
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:@"BrailleTyper" inManagedObjectContext:app.managedObjectContext]];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
    [req setSortDescriptors:@[sortDescriptor]];
    
    NSArray *results = [app.managedObjectContext executeFetchRequest:req error:NULL];
    if ([results count] == 0){
        return @"";
    }
    BrailleTyper *latestEntity = [results objectAtIndex:0];
    
//    NSLog(@"%@ pulled from table", latestEntity.typedString);
    return latestEntity.typedString;
}

# pragma mark - TTS Methods and Audio

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

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
