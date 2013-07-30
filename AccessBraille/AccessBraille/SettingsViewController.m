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
    [self.gradeTwoSwitch setOn:[userDefaults boolForKey:GradeTwoSet]];
    [self.trans setValue:[userDefaults floatForKey:KeyboardTransparency]];
    [_fontSizeSlider setValue:[userDefaults floatForKey:ABFontSize]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

/**
 * Toggles the NSUserDefault of GradeTwoSelection either on, or off.
 */
- (IBAction)gradeSelectionToggle:(UISwitch *)sender
{
    [userDefaults setBool:sender.on forKey:GradeTwoSet];
}

- (IBAction)transChanged:(UISlider *)sender
{
    [userDefaults setFloat:sender.value forKey:KeyboardTransparency];
}

- (IBAction)fontSizeChange:(UISlider *)sender
{
    [userDefaults setFloat:sender.value forKey:ABFontSize];
}


@end
