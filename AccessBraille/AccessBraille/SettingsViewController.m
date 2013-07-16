//
//  SettingsViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 7/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController (){
    NSUserDefaults *userDefaults;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Sets the switch view depending on its status (ON or OFF).
    [userDefaults boolForKey:@"GradeTwoSelection"] ? [self.gradeTwoSwitch setOn:YES] : [self.gradeTwoSwitch setOn:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

/**
 * Toggles the NSUserDefault of GradeTwoSelection either on, or off.
 */
- (IBAction)gradeSelectionToggle:(id)sender
{
    [userDefaults setBool:![userDefaults boolForKey:@"GradeTwoSelection"] forKey:@"GradeTwoSelection"];
}
@end
