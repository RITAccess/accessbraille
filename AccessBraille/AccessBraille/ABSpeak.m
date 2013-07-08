//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//


#import <Availability.h>
#import "ABSpeak.h"
#import "AppDelegate.h"

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    #import <AVFoundation/AVSpeechSynthesis.h>
#endif

@implementation ABSpeak {
    AVSpeechSynthesizer *speaker;
}

@synthesize fliteController;
@synthesize slt;

+ (instancetype)sharedInstance
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if (!app.speaker)
        app.speaker = [[ABSpeak alloc] init];
    
    return app.speaker;
}

- (void)speakString:(NSString *)string {
    
    if(NSClassFromString(@"AVSpeechSynthesizer")) {
        
        speaker = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *currentUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        [speaker speakUtterance:currentUtterance];
        
    } else {
        [self.fliteController say:string withVoice:self.slt];
    }
    
}

- (void)stopSpeaking
{
    // TODO Stop fliteController
    self.fliteController = nil;
    self.fliteController = [self fliteController];
    [speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

@end
