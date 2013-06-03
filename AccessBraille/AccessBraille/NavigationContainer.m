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

@implementation NavigationContainer {
    
    SidebarViewController *nav;    
    UIViewController *currentVC;
}

-(void)viewDidLoad {

}

-(void)loadNavIntoView {

    nav = [[SidebarViewController alloc] init];
    
    _leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    [self.view addGestureRecognizer:_leftSideSwipe];
    
    _tapToCloseMenu = [[UITapGestureRecognizer alloc] initWithTarget:nav action:@selector(tapToClose:)];
    [_tapToCloseMenu setEnabled:NO];
    [self.view.superview addGestureRecognizer:_tapToCloseMenu];
    
    [self.view addSubview:nav.view];
    [self.view bringSubviewToFront:nav.view];
    
    [self addChildViewController:nav];
    [nav didMoveToParentViewController:self];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{ return TRUE; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return TRUE; }

/**
 Takes in a UIViewController and switches the view to that controller
 */
- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)menu {

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

/**
 Called by gesture framework and opens the navigation menu
 */
-(void)navSideBarActions:(UIBezelGestureRecognizer *)reg {
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
            [nav updateMenuPosition:touch.x];
            break;
            
        case UIGestureRecognizerStateBegan:
            [_tapToCloseMenu setEnabled:TRUE];
            [_menuTrav setEnabled:TRUE];
            break;
            
        case UIGestureRecognizerStateEnded:
            if (touch.x < 100) {
                
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
