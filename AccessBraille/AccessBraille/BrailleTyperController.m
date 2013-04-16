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
#import "ABKeyboard.h"

@interface BrailleTyperController ()



@end

#pragma mark Implementation

@implementation BrailleTyperController {
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

- (void)viewDidLoad {

    [super viewDidLoad];
        
    // Draw views
    enabled = [[Enabled alloc] initWithFrame:CGRectMake(971.5, 695.5, 44, 44)];
    enabled.enable = FALSE;
    [self.view addSubview:enabled];
    
    // Audio
    enabledSound = [self createSoundID:@"hop.mp3"];
    disabledSound = [self createSoundID:@"disable.mp3"];
    backspaceSound = [self createSoundID:@"backspace.aiff"];
    
    // Add Keyboard
    ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidAppear:(BOOL)animated {

    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveState];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setFrame:self.parentViewController.view.frame];
    _TextDrawing.buf = [self getLastItemInTable];
}

-(void)saveState {
    [self updateLastValue:[_TextDrawing getCurrentText]];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDrawingView:nil];
    [self setTextOutput:nil];
    [self setTextDrawing:nil];
    [super viewDidUnload];
}

# pragma mark - Typing Methods

- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    if (![info[ABBackspaceReceived] boolValue]) {
        [_TextDrawing appendToText:character];
    } else {
        [_TextDrawing removeCharacter];
    }
}

- (void)wordTyped:(NSString *)word withInfo:(NSDictionary *)info {
    NSLog(@"Typed %@", word);
}


#pragma mark - Access Core Data Methods

/**
 * Update CoreData object for this controller with new typed value. Creates a new row if one does not exist.
 */
- (void)updateLastValue:(NSString *)content {
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

/**
 * Returns the last row from the CoreData object for this controller. Returns empty string if no table exists.
 */
- (NSString *)getLastItemInTable {
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

/**
 * Creates system sound
 */
- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
