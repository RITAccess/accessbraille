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
- (void)characterReceived:(NSString *)brailleString;
- (id)initWithAudioTarget:(id)target selector:(SEL)selector;

// Testing
- (NSString *)proccessString:(NSString *)brailleString;

@property (nonatomic) id<ABKeyboard> delegate;
@property (nonatomic) ABKeyboard *keyboardInterface;
@property (nonatomic) NSString *wordTyping;
@property (nonatomic) NSUInteger grade;
@end
