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
#import "newViewControllerTemplate.h"
#import <Twitter/Twitter.h>
#import "SidebarViewController.h"

@implementation NavigationContainer {
    
    SidebarViewController *nav;
    UITapGestureRecognizer *tapToCloseMenu;
    UIBezelGestureRecognizer *leftSideSwipe;
    UIPanGestureRecognizer *menuTrav;
    
    UIViewController *currentVC;
}

-(void)viewDidLoad {

}

-(void)loadNavIntoView {

    leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    [self.view addGestureRecognizer:leftSideSwipe];
    
    nav = [[SidebarViewController alloc] init];
    
    
    [self.view addSubview:nav.view];
    [self.view bringSubviewToFront:nav.view];
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

# pragma mark - Navigation Logic

-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
            [nav updateMenuPosition:touch.x];
            break;
            
        case UIGestureRecognizerStateBegan:
            [tapToCloseMenu setEnabled:TRUE];
            [menuTrav setEnabled:TRUE];
            break;
            
        case UIGestureRecognizerStateEnded:
            if (touch.x < 100) {
                [self closeMenu:reg];
            }
            break;
            
        default:
            break;
    }
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

/**
 * Closes the menu.
*/
-(void)closeMenu:(UIGestureRecognizer *)reg {
    
    if ([reg isKindOfClass:[UIBezelGestureRecognizer class]]) {
//        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
    if ([reg locationOfTouch:0 inView:self.view].x > 100) {
//        [nav close];
        [tapToCloseMenu setEnabled:NO];
        [menuTrav setEnabled:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
