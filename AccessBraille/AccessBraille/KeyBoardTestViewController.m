//
//  KeyBoardTestViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/22/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "KeyBoardTestViewController.h"
#import "ABActivateKeyboardGestureRecognizer.h"
#import "ABKeyboard.h"

@interface KeyBoardTestViewController ()

@end

@implementation KeyBoardTestViewController {
    ABKeyboard *keyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    keyboard = [[ABKeyboard alloc] init];
    [keyboard setDelegate:self];
    
    ABActivateKeyboardGestureRecognizer *activate = [[ABActivateKeyboardGestureRecognizer alloc] initWithTarget:self  action:@selector(activateKeyboard:)];
    
    [self.view addGestureRecognizer:activate];
    
}

/**
 * Log statement called by AB to log
 */
- (void)ABLog:(NSString *)log {
    NSLog(@"AB - %@", log);
}

- (void)activateKeyboard:(ABActivateKeyboardGestureRecognizer *)reg {
    [keyboard ABKeyboardRecognized:reg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}

@end
