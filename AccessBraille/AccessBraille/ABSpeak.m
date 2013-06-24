//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABSpeak.h"

#if __IPHONE_7_0

#import <AVFoundation/AVSpeechSynthesis.h>

#endif


@implementation ABSpeak

@synthesize fliteController;
@synthesize slt;

- (void)speakString:(NSString *)string {
    
#if __IPHONE_7_0
    
    AVSpeechSynthesizer *speak = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *talk = [AVSpeechUtterance speechUtteranceWithString:string];
    [speak speakUtterance:talk];
    
#else
    
    [self.fliteController say:string withVoice:self.slt];
    
#endif
    
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
