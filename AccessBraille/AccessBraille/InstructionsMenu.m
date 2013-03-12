//
//  InstructionsMenu.m
//  AccessBraille
//
//  Created by Piper Chester on 3/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "InstructionsMenu.h"
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation InstructionsMenu

@synthesize fliteController;
@synthesize slt;



- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init];
    }
    return fliteController;
}

- (Slt *)slt {
    if (slt == nil) {
        slt = [[Slt alloc] init];
    }
    return slt;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 60)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"Instructions Menu"]; /// Will be passed in from external class
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Arial" size:30.0f]];
    [[self view] addSubview:title];
    
    // TextField
    UITextField *instructionsInfo = [[UITextField alloc] initWithFrame:CGRectMake(deviceHeight / 4, 150, deviceHeight - 100, 500)];
    [instructionsInfo setBackgroundColor:[UIColor clearColor]];
    [instructionsInfo setFont:[UIFont fontWithName:@"Arial" size:18.0f]];
    [instructionsInfo setUserInteractionEnabled:NO];
    [[self view] addSubview:instructionsInfo];
    
    // Bulleteted List
    NSArray *instructions = [NSArray arrayWithObjects:@"Swipe from the left at any time to bring up the navigation menu.",  nil];
    NSMutableString *bulletList = [NSMutableString stringWithCapacity:instructions.count*30];
    for (NSString *item in instructions)
    {
        [bulletList appendFormat:@"\u2022 %@\n", item];
        
    }
    instructionsInfo.text = bulletList;
    
    for (NSInteger i = 0; i < sizeof(instructions); i++){
        [self.fliteController say:[instructions objectAtIndex:i] withVoice:self.slt];
        sleep(10);
     }
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
