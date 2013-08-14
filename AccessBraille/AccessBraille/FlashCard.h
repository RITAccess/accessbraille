//
//  FlashCard.h
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ABKeyboard/ABKeyboard.h>
#import <ABKeyboard/ABSpeak.h>

@interface FlashCard : UIViewController <ABKeyboard>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextView *cardTextView;
@property (weak, nonatomic) IBOutlet UITextView *typedTextView;
@property (weak, nonatomic) IBOutlet UIImageView *pointsTagView;

@end
