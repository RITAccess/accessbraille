//
//  newViewControllerTemplate.m
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "newViewControllerTemplate.h"

@implementation newViewControllerTemplate

-(void)viewDidLoad{

}

-(void)didMoveToParentViewController:(UIViewController *)parent{

}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
}


@end
