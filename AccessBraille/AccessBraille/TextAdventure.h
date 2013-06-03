//
//  TextAdventure.h
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABKeyboard.h"
#import "ABSpeak.h"

NSString* const helpText = @"Type the name of the object to pick it up, or type LOOK to survey the area.";

@interface TextAdventure : UIViewController <ABKeyboard> { // Follow the ABKeyboard protocol

    ABKeyboard* keyboard;
    ABSpeak* speaker;
    
    UITextView *typedText;
    NSMutableString *stringFromInput;
    
    NSMutableArray* inventory;
    
}
@end
