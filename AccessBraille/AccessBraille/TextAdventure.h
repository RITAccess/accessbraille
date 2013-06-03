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
NSString* const roomDescription = @"You're in a dark room. A book lies in front of you. I wonder what it says...";
NSString* const waterfrontDescription = @"You're at the waterfront. You see a boat in front of you and an island in the distance.";

@interface TextAdventure : UIViewController <ABKeyboard> { // Follow the ABKeyboard protocol

    ABKeyboard* keyboard;
    ABSpeak* speaker;
    
    UITextView *typedText;
    NSMutableString *stringFromInput;
    
    NSMutableArray* pack;
    NSString* currentLocation;
}
@end
