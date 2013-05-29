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
@synthesize slt;

- (void)speakString:(NSString *)string {
    
    [self.fliteController say:string withVoice:self.slt];

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
