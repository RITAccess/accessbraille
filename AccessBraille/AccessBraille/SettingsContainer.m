//
//  SettingsContainer.m
//  AccessBraille
//
//  Created by Michael Timbrook on 7/22/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "SettingsContainer.h"

@interface SettingsContainer ()

@end

@implementation SettingsContainer

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

@end
