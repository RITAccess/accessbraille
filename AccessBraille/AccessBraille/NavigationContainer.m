//
//  NavigationContainer.m
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationContainer.h"
#import "BrailleTyperController.h"
#import "NavigationView.h"
#import "UIBezelGestureRecognizer.h"
#import "NavigationViewController.h"

@implementation NavigationContainer {
    
    NSMutableDictionary *_subViewControllers;
 
}


-(void)viewDidLoad {
    
    NSLog(@"Container did load");
    
    // Set up container stuff
    
    BrailleTyperController *brailleTyper = [[BrailleTyperController alloc] init];
    NavigationViewController *nav = [[NavigationViewController alloc] init];
    _subViewControllers = [[NSMutableDictionary alloc] initWithDictionary:@{@"braille":brailleTyper, @"nav":nav}];
    [self addChildViewController:brailleTyper];

}

@end
