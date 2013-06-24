//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Availability.h>
#import "ABSpeak.h"

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    #import <AVFoundation/AVSpeechSynthesis.h>
#endif

@implementation ABSpeak
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
@synthesize fliteController;
@synthesize slt;
#endif

- (void)speakString:(NSString *)string {
    
    if(NSClassFromString(@"AVSpeechSynthesizer")) {
        
        AVSpeechSynthesizer *speak = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *talk = [AVSpeechUtterance speechUtteranceWithString:string];
        [speak speakUtterance:talk];
        
    } else {

        [self.fliteController say:string withVoice:self.slt];
    
    }
    
}

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

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

#endif

@end
