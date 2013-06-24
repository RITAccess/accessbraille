//
//  FlashCard.h
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABKeyboard.h"
#import "ABSpeak.h"

NSString *const welcomeText = @"Welcome to Flash Card mode! Swipe UP to select easy mode, RIGHT for medium mode, and DOWN for hard mode. Once playing, swipe 6 fingers up to initialize the typing keyboard.";

NSInteger const maxEasyCards = 30;
NSInteger const maxMediumCards = 60;
NSInteger const maxHardCards = 20;

@interface FlashCard : UIViewController <ABKeyboard> {
    UITextView *typedText, *cardText, *pointsText, *infoText;
    NSMutableArray *cards;
    NSArray *card, *letters;
    NSMutableString *stringFromInput;
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    int points;
    NSString *finalPath, *path;
    SystemSoundID correctSound, incorrectSound;
}

@end
