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
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    
    BOOL isPlaying, doorUnlocked, sailAttached, chestOpened, litRoom, collectedSilver;
}

@property NSDictionary *texts;
@property UITextView *typedText, *infoText;
@property NSMutableString *stringFromInput;
@property NSMutableArray *pack, *rooms;
@property NSString *currentLocation, *path, *playerName;

@end
