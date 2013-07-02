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
#import "SidebarViewController.h"
#import "NSArray+ObjectSubsets.h"
#import "UIView+quickRemove.h"
#import "TextAdventure.h"
#import "MainMenu.h"

@implementation NavigationContainer {
    
    SidebarViewController *nav;    
    UIViewController *currentVC;
    
    // For navigation
    NSArray *navigationGestures;
    __strong NSArray *storedGestures;
    BOOL openActive;
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

-(void)loadNavIntoView {

    nav = [[SidebarViewController alloc] init];
    
    _leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    scroll = [[UIPanGestureRecognizer alloc] initWithTarget:nav action:@selector(moveMenuItems:)];
    navigationGestures = @[tapToClose];
    
    [self.view addGestureRecognizer:_leftSideSwipe];
    
    [self.view addSubview:nav.view];
    [self.view sendSubviewToBack:nav.view];
    
    [self addChildViewController:nav];
    [nav didMoveToParentViewController:self];
    
    openActive = NO;
    
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
    [menu addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    [menu setTitle:@"Menu" forState:UIControlStateNormal];
    [menu setEnabled:YES];
    [menu setTintColor:[UIColor blackColor]];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    
    [controller didMoveToParentViewController:self];
}

- (IBAction)testAction:(id)sender
{
    TextAdventure *ta = [[TextAdventure alloc] init];
    [self switchToController:ta animated:YES withMenu:NO];
    
}

- (void)menu
{

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

# pragma mark - Navigation Logic

/**
 Called by gesture framework and opens the navigation menu
 */
-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged: {
            CGRect frame = currentVC.view.frame;
            frame.origin.x = touch.x;
            if (touch.x <= 100) {
                [currentVC.view setFrame:frame];
            } else {
                // Menu is open
                if (!openActive) {
                    openActive = YES;
                    frame.origin.x = 100;
                    [currentVC.view setFrame:frame];   
                    storedGestures = currentVC.view.gestureRecognizers;
                    [currentVC.view setGestureRecognizers:navigationGestures];
                    [self.view addGestureRecognizer:scroll];
                }
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if (touch.x < 100) {
                [UIView animateWithDuration:.2 animations:^{
                    CGRect frame = currentVC.view.frame;
                    frame.origin.x = 0;
                    [currentVC.view setFrame:frame];
                }];
            }
            break;
            
        default:
            break;
    }
}

/**
 * Handles closing the menu
 */
- (void)tapToClose:(UIGestureRecognizer *)reg {
    [currentVC.view setGestureRecognizers:storedGestures];
    [self.view removeGestureRecognizer:scroll];
    openActive = NO;
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = currentVC.view.frame;
        frame.origin.x = 0;
        [currentVC.view setFrame:frame];
    }];
}


/**
 * Called by gesture framework to navigate the menu.
*/
-(void)panMenu:(UIPanGestureRecognizer *)reg{
    
    switch (reg.state){
        case UIGestureRecognizerStateChanged:
//            [nav updateMenuWithCGPoint:[reg translationInView:self.view]];
            break;
        case UIGestureRecognizerStateBegan:
//            [nav setStartNavigation];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
