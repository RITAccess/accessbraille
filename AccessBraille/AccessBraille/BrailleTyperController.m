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

@implementation BrailleTyperController {
    // Layout
    ABKeyboard *keyboard;
    ABBrailleOutput *output;
    
    UITapGestureRecognizer *doubleTap;
    
    BOOL isZoomed;
}

#pragma mark - View Control

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
    
    UITapGestureRecognizer *tapToZoom = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToZoom:)];
    [tapToZoom setNumberOfTapsRequired:2];
    [_textField addGestureRecognizer:tapToZoom];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_textField setFont:[UIFont boldSystemFontOfSize:[defaults floatForKey:ABFontSize]]];
    
    isZoomed = NO;
}

- (void)viewDidUnload
{
    keyboard = nil;
    self.view.gestureRecognizers = nil;
    [self setTextOutput:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.view setFrame:self.parentViewController.view.frame];
}

#pragma mark - Gesture Handling

- (void)tapToZoom:(UITapGestureRecognizer *)gesture
{
    isZoomed ? [_textField setFont:[UIFont systemFontOfSize:17]] : [_textField setFont:[UIFont boldSystemFontOfSize:55]];
    isZoomed = !isZoomed;
}

- (void)tapToDisplayMenu:(UITapGestureRecognizer *)gesture
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
