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
    
    _tapToCloseMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    [self.view addGestureRecognizer:_tapToCloseMenu];
    
    [self.view addSubview:nav.view];
    [self.view bringSubviewToFront:nav.view];
    
}

- (void)tapToClose:(UITapGestureRecognizer *)reg {
    NSLog(@"Tap");
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{ return TRUE; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return TRUE; }

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
