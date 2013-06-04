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

NSString* const initialText = @"Would you care to start an exciting text-based adventure? Tap once to begin.";
NSString* const wakeupText = @"You wake up in your bed. Type LOOK to see what's around you.";
NSString* const helpText = @"Type the name of the object to put it in your pack or use it. Type LOOK to survey the area.";

NSString* const roomDescription = @"You're in a dark room. A book lies in front of you. I wonder what it says...";
NSString* const waterfrontDescription = @"You're at the waterfront. You see a boat in front of you and an island in the distance.";

NSString* const bookDescription = @"The book is full of hints! The first hint says: use the boat to get to the island.";

@interface TextAdventure : UIViewController <ABKeyboard> { // Follow the ABKeyboard protocol

    ABKeyboard* keyboard;
    ABSpeak* speaker;
    
    UITextView *typedText;
    UITextView *infoText;
    NSMutableString *stringFromInput;
    
    NSMutableArray* pack;
    NSString* currentLocation;
}
@end
