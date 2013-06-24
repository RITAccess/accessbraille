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
#import "NavigationContainer.h"
#import "UIBezelGestureRecognizer.h"
#import "Enabled.h"
#import "BrailleTyperOutputView.h"
#import "AppDelegate.h"
#import "BrailleTyper.h"
#import <CoreData/CoreData.h>
#import "ABKeyboard.h"

@interface BrailleTyperController ()



@end

#pragma mark Implementation

@implementation BrailleTyperController {
    // Layout
    Enabled *enabled;
    ABKeyboard *keyboard;
}

@synthesize typingStateOutlet = _typingStateOutlet;
@synthesize DrawingView = _DrawingView;

# pragma mark - ViewController Methods

- (void)viewDidLoad {

    [super viewDidLoad];
        
    // Draw views
    enabled = [[Enabled alloc] initWithFrame:CGRectMake(971.5, 695.5, 44, 44)];
    enabled.enable = FALSE;
    [self.view addSubview:enabled];
    
    // Add Keyboard
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [keyboard setActiveStateWithTarget:self withSelector:@selector(active)];
    [keyboard setDectiveStateWithTarget:self withSelector:@selector(deactive)];
    
    [keyboard setOutput:_textField];
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
    [_textField setText:[self getLastItemInTable]];
}

-(void)saveState {
    [self updateLastValue:_textField.text];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    keyboard = nil;
    enabled = nil;
    self.view.gestureRecognizers = nil;
    [self setDrawingView:nil];
    [self setTextOutput:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}

# pragma mark - Typing Methods

- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    NSLog(@"Typed: %@", character);
}

- (void)wordTyped:(NSString *)word withInfo:(NSDictionary *)info {
    NSLog(@"Typed word: %@", word);
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
        [req setEntity:[NSEntityDescription entityForName:@"BrailleTyper" inManagedObjectContext:app.managedObjectContext]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [req setSortDescriptors:@[sortDescriptor]];
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

@end
