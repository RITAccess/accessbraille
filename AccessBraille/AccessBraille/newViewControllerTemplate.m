//
//  newViewControllerTemplate.m
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

/**
    Test ViewController
 */


#import "newViewControllerTemplate.h"

@implementation newViewControllerTemplate

-(void)viewDidLoad{
    
}

-(void)didMoveToParentViewController:(UIViewController *)parent{

}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}


@end
