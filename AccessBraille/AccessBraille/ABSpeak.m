//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABSpeak.h"

@implementation ABSpeak

@synthesize fliteController;
@synthesize emma;

- (void)speakString:(NSString *)string {
    
    [self.fliteController sayWithNeatSpeech:string withVoice:self.emma];

}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Emma *)emma {
	if (emma == nil) {
		emma = [[Emma alloc] initWithPitch:0.2f speed:0.0f transform:0.0f];
	}
	return emma;
}


@end
