//
//  NavigationViewController.m
//  AccessBraille
//
//  Created by Michael on 1/18/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationViewController.h"
#import "NavigationView.h"
#import "UIBezelGestureRecognizer.h"

@implementation NavigationViewController {
    // Nav
    NavigationView *nav;
    
    UITapGestureRecognizer *tapToCloseMenu;
    UIBezelGestureRecognizer *leftSideSwipe;
    UIPanGestureRecognizer *menuTrav;
}

-(void)viewDidLoad{
    // Nav pullout
    nav = [[NavigationView alloc] initWithFrame:CGRectMake(-100, 0, 100, 748) setSuper:self];
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


@end
