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
#import <CoreData/CoreData.h>

@interface BrailleTyperController ()

@end

#pragma mark - Implementation

@implementation BrailleTyperController {
    // Layout
    ABKeyboard *keyboard;
    ABBrailleOutput *output;
    
    UITapGestureRecognizer *doubleTap;
}

# pragma mark - ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add Keyboard
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];
    [keyboard setOutput:_textField];
    [[NSUserDefaults standardUserDefaults] boolForKey:@"GradeTwoSelection"] ? [keyboard setGrade:ABGradeTwo] : [keyboard setGrade:ABGradeOne]; // Setting Grade.
    
    output = [[ABBrailleOutput alloc] init];
    [output setFrame:CGRectMake(25, 300, 100, 30)];
    [output setText:@""];
    [self.view addSubview:output];
    [self.view bringSubviewToFront:output];

    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDisplayMenu:)];
    [self.view addGestureRecognizer:doubleTap];
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

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setFrame:self.parentViewController.view.frame];
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

@end
