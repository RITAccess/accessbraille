//
//  Settings.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/20/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "Settings.h"
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation Settings

@synthesize fliteController;
@synthesize slt;

- (void)viewDidLoad {
    
}


- (IBAction)buttonPress:(id)sender {
    NSLog(@"Testing");
    [self.fliteController say:@"testing" withVoice:self.slt];
    
}
- (void)viewDidUnload {
    [self setLabel:nil];
    [super viewDidUnload];
}
@end