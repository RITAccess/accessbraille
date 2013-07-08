//
//  ABSpeak.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//
//  ABSpeak framework of ABKeyboard. ABSpeak handles coordinating all the Text
//  to Speech (TTS) needed for the framework. Here it is publicly available to
//  framework users if they want to use any TTS. Using Open Ears in builds > iOS 7
//  and the new AVSpeechSynthesizer in iOS 7. Only one instance of ABSpeak will
//  be active at a time.
//
//  To use ABSpeak please add this to your app delegate
//  @property ABSpeak *speaker;
//

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

// TODO add documentation

@interface ABSpeak : NSObject {
    FliteController *fliteController;
    Slt *slt;
}

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

+ (instancetype)sharedInstance;

- (void)speakString:(NSString *)string;
- (void)stopSpeaking;


@end
