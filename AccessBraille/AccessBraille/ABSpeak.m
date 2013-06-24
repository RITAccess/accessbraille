//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABSpeak.h"

@implementation ABSpeak {
    NSOperationQueue *speakQueue;
}

@synthesize fliteController;
@synthesize slt;

- (id)init
{
    self = [super init];
    if (self) {
        speakQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)speakString:(NSString *)string {
    [speakQueue addOperationWithBlock:^{
        [self.fliteController say:string withVoice:self.slt];
    }];
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
