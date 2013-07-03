//
//  TextAdventure.h
//  AccessBraille
//
//  Created by Piper Chester on 6/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <ABKeyboard/ABKeyboard.h>
#import <ABKeyboard/ABSpeak.h>

@interface TextAdventure : UIViewController <ABKeyboard, AVAudioPlayerDelegate>
{
    ABKeyboard *keyboard;
    ABSpeak *speaker;
    
    AVAudioPlayer *avPlayer;
    
    BOOL isPlaying, doorUnlocked, sailAttached, chestOpened, caveLit, collectedSilver;
}

@property NSDictionary *texts;
@property UITextView *typedText, *infoText;
@property NSMutableString *stringFromInput;
@property NSMutableArray *pack, *rooms;
@property NSString *currentLocation, *path, *playerName;
@property NSURL *crashURL, *forestCrunchURL, *keyDropURL, *lakeURL, *doorOpenURL;

@end
