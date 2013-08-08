//
//  InstructionsMenu.m
//  AccessBraille
//
//  Created by Piper Chester on 3/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsMenu.h"

@implementation InstructionsMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
