//
//  TextAdventure.h
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ABKeyboard/ABKeyboard.h>
#import <ABKeyboard/ABSpeak.h>

@interface TextAdventure : UIViewController <ABKeyboard> {

    NSDictionary* texts;
    
    ABKeyboard* keyboard;
    ABSpeak* speaker;
    
    UITextView *typedText;
    UITextView *infoText;
    NSMutableString *stringFromInput;
    
    NSMutableArray* pack;
    NSString* currentLocation;
    
    NSString *finalPath;
    NSString *path;
}
@end
