//
//  TimetripViewController.h
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <ABKeyboard/ABKeyboard.h>
#import <ABKeyboard/ABSpeak.h>

@interface TimetripViewController : UIViewController <ABKeyboard, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UITextView *typedText;
@property (nonatomic) UITapGestureRecognizer *tapToStart;
@property (nonatomic) NSDictionary *texts;

@end
