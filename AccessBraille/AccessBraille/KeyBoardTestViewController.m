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
    
    keyboard = [[ABKeyboard alloc] initWithDelegate:self];

}

/**
 * Log statement called by AB to log
 */
- (void)ABLog:(NSString *)log {
    NSLog(@"AB - %@", log);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}

@end
