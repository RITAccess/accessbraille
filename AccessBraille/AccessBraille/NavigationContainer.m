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
#import <AudioToolbox/AudioToolbox.h>
#import "SidebarViewController.h"

@implementation NavigationContainer {
    
    SidebarViewController *nav;
    UITapGestureRecognizer *tapToCloseMenu;
    UIBezelGestureRecognizer *leftSideSwipe;
    UIPanGestureRecognizer *menuTrav;
    
    UIViewController *currentVC;
    
    // Audio
    SystemSoundID openNavSound;
}

-(void)viewDidLoad {
    
    openNavSound = [self createSoundID:@"navClick.aiff"];

}

-(void)loadNavIntoView {

    leftSideSwipe = [[UIBezelGestureRecognizer alloc] initWithTarget:self action:@selector(navSideBarActions:)];
    
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
    NSLog(@"Test");
    CGPoint touch = [reg locationInView:self.view];
    switch (reg.state) {
        case UIGestureRecognizerStateChanged:
//            [nav updateWithCGPoint:touch];
            AudioServicesPlaySystemSound(openNavSound);
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

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}
@end
