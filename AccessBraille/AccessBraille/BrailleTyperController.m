//
//  ViewController.m
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "BrailleTyperController.h"
#import "Drawing.h"
#import "NavigationContainer.h"
#import "AppDelegate.h"
#import "BrailleTyper.h"
#import <CoreData/CoreData.h>

@interface BrailleTyperController ()

@end

#pragma mark - Implementation

@implementation BrailleTyperController {
    // Layout
    ABKeyboard *keyboard;
    ABBrailleOutput *output;
}

# pragma mark - ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add Keyboard
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [keyboard setActiveStateWithTarget:self withSelector:@selector(active)];
    [keyboard setDectiveStateWithTarget:self withSelector:@selector(deactive)];
    [keyboard setOutput:_textField];
    [[NSUserDefaults standardUserDefaults] boolForKey:@"GradeTwoSelection"] ? [keyboard setGrade:ABGradeTwo] : [keyboard setGrade:ABGradeOne]; // Setting Grade.
    
    output = [[ABBrailleOutput alloc] init];
    [output setFrame:CGRectMake(25, 300, 100, 30)];
    [output setText:@""];
    [self.view addSubview:output];
    [self.view bringSubviewToFront:output];
}

- (void)tapToDisplayMenu:(UITapGestureRecognizer *)gesture
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self saveState];
    NSLog(@"View did disappear.");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setFrame:self.parentViewController.view.frame];
    [_textField setText:[self getLastItemInTable]];
}

-(void)saveState
{
    [self updateLastValue:_textField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    keyboard = nil;
    self.view.gestureRecognizers = nil;
    [self setTextOutput:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}

# pragma mark - Typing Methods

- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info
{
    NSLog(@"Typed: %@", character);
    [output setText:_textField.text];
}

- (void)wordTyped:(NSString *)word withInfo:(NSDictionary *)info
{
    NSLog(@"Typed word: %@", word);
}

#pragma mark - Access Core Data Methods

/**
 * Update CoreData object for this controller with new typed value. Creates a new row if one does not exist.
 */
- (void)updateLastValue:(NSString *)content
{
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
- (NSString *)getLastItemInTable
{
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
    
    return latestEntity.typedString;
}

@end
