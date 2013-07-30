//
//  SettingsViewController.h
//  AccessBraille
//
//  Created by Piper Chester on 7/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ABKeyboard/ABTypes.h>

static NSString *const GradeTwoSet = @"GradeTwoSelection";

@interface SettingsViewController : UITableViewController

// Choosing between Grade 1 and Grade 2.
- (IBAction)gradeSelectionToggle:(id)sender;
- (IBAction)transChanged:(id)sender;
- (IBAction)fontSizeChange:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *gradeTwoSwitch;
@property (weak, nonatomic) IBOutlet UISlider *trans;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;

@end
