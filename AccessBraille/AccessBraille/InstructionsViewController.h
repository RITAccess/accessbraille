//
//  InstructionsViewController.h
//  AccessBraille
//
//  Created by Piper Chester on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ABKeyboard/ABSpeak.h>

extern NSString *const InstructionsStoryBoardID;

@interface InstructionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *outputText;

@end
