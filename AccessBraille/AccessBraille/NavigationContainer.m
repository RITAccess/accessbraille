//
//  NavigationContainer.m
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationContainer.h"
#import "BrailleTyperController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSArray+ObjectSubsets.h"
#import "UIView+quickRemove.h"
#import "TimetripViewController.h"
#import "MainMenu.h"

@implementation NavigationContainer {
    UIViewController *currentVC;
    
    UIPanGestureRecognizer *scroll;
    float menuPosRef;
    
    NSArray *gestures;
    
    MainMenu *_mainMenu;
    UIButton *menu;
    CGRect menuOut, menuIn;
    
    UITapGestureRecognizer *doubleTap;
}

-(void)viewDidLoad
{    
    _mainMenu = [[MainMenu alloc] init];
    [self addChildViewController:_mainMenu];
    [self.view addSubview:_mainMenu.view];
    [self.view sendSubviewToBack:_mainMenu.view];
    
    menuIn = CGRectMake(2, 0, 100, 76);
    menuOut = CGRectMake(2, -30, 100, 0);
    
    menu = [UIButton buttonWithType:UIButtonTypeCustom];
    [menu addTarget:self action:@selector(tapToShowMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:@"menuTag.png"];
    [menu setBackgroundImage:img forState:UIControlStateNormal];
    [menu setAlpha:0.6];
    [menu setFrame:menuOut];
    [menu setEnabled:YES];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{ return TRUE; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return TRUE; }

/**
 Takes in a UIViewController and switches the view to that controller.
 */
- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)withmenu
{
    [self.view removeSubviews];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController removeFromParentViewController];
    }
    
    [self addChildViewController:controller];
    
    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShowMenu:)];
    doubleTap.numberOfTapsRequired = 2;
    [controller.view addGestureRecognizer:doubleTap];
    
    [self.view addSubview:controller.view];
    [controller viewDidAppear:animated];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    [controller.view setFrame:frame];
    
    currentVC = controller;
    
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [menu setFrame:menuIn];
    
    [controller didMoveToParentViewController:self];
}

- (void)tapToShowMenu:(id)sender
{
    [_mainMenu.view removeSubviews];
    [self addChildViewController:_mainMenu];
    [self.view addSubview:_mainMenu.view];
    [self.view sendSubviewToBack:_mainMenu.view];
    [_mainMenu loadMenuItemsAnimated:YES];
    
    gestures = currentVC.view.gestureRecognizers;
    UITapGestureRecognizer *tapToReturn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptoreturn:)];
    [tapToReturn setCancelsTouchesInView:YES];
    [currentVC.view setGestureRecognizers:@[tapToReturn]];
    
    
    /* Scales main controller down. */
    CGAffineTransform scale = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.3 animations:^{
        currentVC.view.transform = scale;
        [currentVC.view setCenter:CGPointMake(650, 384)];
        [self.view setBackgroundColor:[UIColor blueColor]];
        [menu setFrame:menuOut];
    }];
}

- (void)taptoreturn:(UITapGestureRecognizer *)reg
{
    [currentVC.view setGestureRecognizers:gestures];
    CGAffineTransform scale = CGAffineTransformMakeScale(1.0, 1.0);

    [UIView animateWithDuration:0.3 animations:^{
        currentVC.view.transform = scale;
        [currentVC.view setCenter:CGPointMake(512, 384)];
        [menu setFrame:menuIn];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
