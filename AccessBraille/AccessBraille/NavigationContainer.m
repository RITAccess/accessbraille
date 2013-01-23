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
#import "newViewControllerTemplate.h"
#import <Twitter/Twitter.h>

@implementation NavigationContainer {
    NavigationView *nav;
    
    UITapGestureRecognizer *tapToCloseMenu;
    UIBezelGestureRecognizer *leftSideSwipe;
    UIPanGestureRecognizer *menuTrav;
    
    UIViewController *currentVC;
}

-(void)viewDidLoad {
    [self switchToController:[self.storyboard instantiateViewControllerWithIdentifier:@"brailleTyper"] animated:NO];
}

-(void)loadNavIntoView {
    // Nav pullout
    nav = [[NavigationView alloc] initWithFrame:CGRectMake(-100, 0, 100, 748)];
    [nav setParentViewController:self];
    [self.view addSubview:nav];
    
    leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    tapToCloseMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    [tapToCloseMenu setNumberOfTapsRequired:1];
    [tapToCloseMenu setEnabled:NO];
    menuTrav = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    [menuTrav setMinimumNumberOfTouches:1];
    [menuTrav setMaximumNumberOfTouches:1];
    [menuTrav setEnabled:NO];
    
    [self.view addGestureRecognizer:leftSideSwipe];
    [self.view addGestureRecognizer:tapToCloseMenu];
    [self.view addGestureRecognizer:menuTrav];
}

-(void)switchToController:(UIViewController*)controller animated:(BOOL)animated {
    
    for (UIView *subview in self.view.subviews){
        [subview removeFromSuperview]; // animated not taken into account yet
    }
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController removeFromParentViewController];
    }
    
    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    [self loadNavIntoView];
    
    [controller didMoveToParentViewController:self];
    
}

// Navigation Logic
-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
            printf(".");
            [nav updateWithCGPoint:touch];
            break;
            
        case UIGestureRecognizerStateBegan:
            [tapToCloseMenu setEnabled:TRUE];
            [menuTrav setEnabled:TRUE];
            NSLog(@"State Started");
            break;
            
        case UIGestureRecognizerStateEnded:
            printf("\n");
            NSLog(@"State Ended");
            if (touch.x < 100) {
                [self closeMenu:reg];
            }
            break;
            
        default:
            break;
    }
}

-(void)panMenu:(UIPanGestureRecognizer *)reg{
    // Swipe navigation logic
    switch (reg.state){
        case UIGestureRecognizerStateChanged:
            [nav updateMenuWithCGPoint:[reg translationInView:self.view]];
            break;
        case UIGestureRecognizerStateBegan:
            [nav setStartNavigation];
            break;
    }
}

-(void)closeMenu:(UIGestureRecognizer *)reg {
    if ([reg isKindOfClass:[UIBezelGestureRecognizer class]]) {
        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
    if ([reg locationOfTouch:0 inView:self.view].x > 100) {
        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end