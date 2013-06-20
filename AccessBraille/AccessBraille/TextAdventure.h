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

@interface TextAdventure : UIViewController <ABKeyboard>
{
    ABKeyboard* keyboard;
    ABSpeak* speaker;
    
    BOOL isPlaying;
}

@property NSDictionary *texts;
@property UITextView *typedText;
@property UITextView *infoText;
@property NSMutableString *stringFromInput;
@property NSMutableArray *pack;
@property NSString *currentLocation;
@property NSString *path;
@property NSString *playerName;
@property NSMutableArray *rooms;

@end
