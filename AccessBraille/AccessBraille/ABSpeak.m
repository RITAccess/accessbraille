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
{
    NSOperationQueue *speakQueue;
}

@synthesize fliteController;
@synthesize slt;

+ (instancetype)sharedInstance
{
    
    
    
    return nil;
}

- (void)speakString:(NSString *)string {
    
    if (speakQueue)
        speakQueue = [[NSOperationQueue alloc] init];
    
    if(NSClassFromString(@"AVSpeechSynthesizer")) {
        
        AVSpeechSynthesizer *speak = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *talk = [AVSpeechUtterance speechUtteranceWithString:string];
        [speakQueue addOperationWithBlock:^{
            [speak speakUtterance:talk];
        }];
        
    } else {
        [speakQueue addOperationWithBlock:^{
            [self.fliteController say:string withVoice:self.slt];
        }];
    }
    
}

- (void)stopSpeaking
{
    [speakQueue cancelAllOperations];
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
