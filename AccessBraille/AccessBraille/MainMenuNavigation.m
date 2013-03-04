//
//  MainMenuNavigation.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/15/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenuNavigation.h"

@implementation MainMenuNavigation


- (void)drawRect:(CGRect)rect {
    
}

- (void)setVisible:(bool)visible {
    NSLog(@"Is Visible: %@", visible ? @"true" : @"false");
}

- (void)setLocation:(CGPoint)point {
    NSLog(@"%f", point.y);
}

@end
