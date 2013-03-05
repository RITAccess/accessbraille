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

}

-(void)loadNavIntoView {
    /**
        Will load the navigation views into the controller's view
     */
    
    nav = [[NavigationView alloc] initWithFrame:CGRectMake(-100, 0, 100, 748)];
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
    
    [nav setControllerWithBlock:^(NSString *storyboardInstance, BOOL menu, BOOL animated) {
        [self switchToController:[self.storyboard instantiateViewControllerWithIdentifier:storyboardInstance] animated:animated withMenu:menu];
    }];
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{ return TRUE; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return TRUE; }

- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)menu {
    /**
        Takes in a UIViewController and switches the view to that controller
     */
    if (animated) {
        
        for (UIView *subview in self.view.subviews){
            [subview removeFromSuperview];
        }
        for (UIViewController *childViewController in self.childViewControllers){
            [childViewController removeFromParentViewController];
        }
        
        [self addChildViewController:controller];
        
        [self.view addSubview:controller.view];
        [controller viewDidAppear:animated];
        if (menu) {
            [self loadNavIntoView];
        }
        [controller didMoveToParentViewController:self];
        
        
    } else {
        for (UIView *subview in self.view.subviews){
            [subview removeFromSuperview]; 
        }
        for (UIViewController *childViewController in self.childViewControllers){
            [childViewController removeFromParentViewController];
        }
        
        [self addChildViewController:controller];
        
        [self.view addSubview:controller.view];
        [controller viewDidAppear:animated];
        if (menu) {
            [self loadNavIntoView];
        }        
        [controller didMoveToParentViewController:self];
    }
}

// Navigation Logic
-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    /**
        Called by gesture framework and opens the navigation menu
     */
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
//            printf(".");
            [nav updateWithCGPoint:touch];
            break;
            
        case UIGestureRecognizerStateBegan:
            [tapToCloseMenu setEnabled:TRUE];
            [menuTrav setEnabled:TRUE];
//            NSLog(@"State Started");
            break;
            
        case UIGestureRecognizerStateEnded:
//            printf("\n");
//            NSLog(@"State Ended");
            if (touch.x < 100) {
                [self closeMenu:reg];
            }
            break;
            
        default:
            break;
    }
}

-(void)panMenu:(UIPanGestureRecognizer *)reg{
    /**
        Called by gesture framework to navigate the menu
     */
    switch (reg.state){
        case UIGestureRecognizerStateChanged:
            [nav updateMenuWithCGPoint:[reg translationInView:self.view]];
            break;
        case UIGestureRecognizerStateBegan:
            [nav setStartNavigation];
            break;
        default:
            break;
    }
}

-(void)closeMenu:(UIGestureRecognizer *)reg {
    /**
        Closes the menu
     */
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
