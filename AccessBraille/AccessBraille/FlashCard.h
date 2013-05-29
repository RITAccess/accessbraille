//
//  FlashCard.h
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABKeyboard.h"

NSString *const welcomeText = @"Welcome to Flash Card mode! Swipe UP to select easy mode, RIGHT for medium mode, and DOWN for hard mode.";

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
