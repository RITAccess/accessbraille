//
//  ViewController.h
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"
#import <CoreData/CoreData.h>

#import <ABKeyboard/ABKeyboard.h>
#import <ABKeyboard/ABBrailleOutput.h>

@interface BrailleTyperController : UIViewController <ABKeyboard>

@property (weak, nonatomic) IBOutlet UILabel *textOutput;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end
