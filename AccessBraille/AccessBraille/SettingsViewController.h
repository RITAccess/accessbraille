//
//  SettingsViewController.h
//  AccessBraille
//
//  Created by Piper Chester on 7/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

// Choosing between Grade 1 and Grade 2.
- (IBAction)gradeSelectionToggle:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *gradeTwoSwitch;

@end
