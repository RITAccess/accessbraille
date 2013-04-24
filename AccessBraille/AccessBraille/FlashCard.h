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
NSString *const welcomeText = @"Welcome to Flash Card mode! Tap to the left of the screen to adjust settings, in the center to read the instructions, or to the right of the screen to start playing.";

@interface FlashCard : UIViewController <ABKeyboard> {

}

@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)displayInstructionsFromButtonClick:(id)sender;
- (IBAction)displaySettingsFromButtonClick:(id)sender;
- (IBAction)enterCardModeFromButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

@end
