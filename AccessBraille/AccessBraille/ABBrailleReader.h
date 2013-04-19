//
//  ABBrailleReader.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTouchLayer.h"
#import "ABKeyboard.h"

@interface ABBrailleReader : NSObject <ABTouchReciever>

+ (NSString *)brailleStringFromTouchIDs:(NSArray *)touchIDs;
- (id)initWithAudioTarget:(id)target selector:(SEL)selector;

@property (nonatomic) id<ABKeyboard> delegate;
@property (nonatomic) NSString *wordTyping;
@end
