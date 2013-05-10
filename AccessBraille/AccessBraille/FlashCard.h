//
//  FlashCard.h
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABKeyboard.h"

NSString *const instructionsText = @"In Flash Card mode, users will type out words using the ABKeyboard to complete the word.The word will be spoken to the user letter by letter.";
NSString *const settingsText = @"The user is able to adjust the settings later within the application.";
NSString *const welcomeText = @"Welcome to Flash Card mode! Tap once to hear the instructions, tap twice to hear settings, or swipe to the right of the screen to start playing.";

NSInteger const maxEasyCards = 30;
NSInteger const maxMediumCards = 60;
NSInteger const maxHardCards = 20;

@interface FlashCard : UIViewController <ABKeyboard> {

}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UILabel *easyModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardModeLabel;

@end
