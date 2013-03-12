//
//  TestKeyboardViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "TestKeyboardViewController.h"

#import "ABActivateKeyboardGestureRecognizer.h"
#import "ABKeyboard.h"

@interface TestKeyboardViewController ()

@end

@implementation TestKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"View loaded");
    
    ABActivateKeyboardGestureRecognizer *activateKeyboard = [[ABActivateKeyboardGestureRecognizer alloc] initWithTarget:self action:@selector(startKeyboard:)];
    
    [self.view addGestureRecognizer:activateKeyboard];
    
}

- (void)startKeyboard:(UISwipeGestureRecognizer *)reg {
    NSLog(@"Bring up keyboard");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
