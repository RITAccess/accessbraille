//
//  MainMenu.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenu.h"
#import "NavigationContainer.h"
#import "BrailleInterpreter.h"

@implementation MainMenu

-(void)viewDidLoad{
    
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)buttonPressed:(id)sender {
    
    NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:@"brailleTyper"] animated:NO withMenu:YES];
    
}
@end
