//
//  NavigationContainer.m
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationContainer.h"
#import "BrailleTyperController.h"
#import "UIBezelGestureRecognizer.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSArray+ObjectSubsets.h"
#import "UIView+quickRemove.h"
#import "TextAdventure.h"
#import "MainMenu.h"

@implementation NavigationContainer {
    
    UIViewController *currentVC;
    
    UIPanGestureRecognizer *scroll;
    float menuPosRef;
    
    MainMenu *_mainMenu;
    
}

-(void)viewDidLoad {
    
    _mainMenu = [[MainMenu alloc] init];
    [self addChildViewController:_mainMenu];
    [self.view addSubview:_mainMenu.view];
    [self.view sendSubviewToBack:_mainMenu.view];
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{ return TRUE; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return TRUE; }

/**
 Takes in a UIViewController and switches the view to that controller
 */
- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)withmenu {
        
    [self.view removeSubviews];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController removeFromParentViewController];
    }
    
    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    [controller viewDidAppear:animated];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    [controller.view setFrame:frame];
    
    currentVC = controller;
    
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menu setFrame:CGRectMake(2, 2, 100, 30)];
    [menu addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [menu setTitle:@"Menu" forState:UIControlStateNormal];
    [menu setEnabled:YES];
    [menu setTintColor:[UIColor blackColor]];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    
    [controller didMoveToParentViewController:self];
}

- (void)menu:(id)sender
{
    [_mainMenu.view removeSubviews];
    [self addChildViewController:_mainMenu];
    [self.view addSubview:_mainMenu.view];
    [self.view sendSubviewToBack:_mainMenu.view];
    [_mainMenu loadMenuItemsAnimated:YES];
    
    CGAffineTransform scale = CGAffineTransformMakeScale(0.6, 0.6);
    [currentVC.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:1.0 animations:^{
        currentVC.view.transform = scale;
        [currentVC.view setCenter:CGPointMake(600, 384)];
        [self.view setBackgroundColor:[UIColor blueColor]];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
