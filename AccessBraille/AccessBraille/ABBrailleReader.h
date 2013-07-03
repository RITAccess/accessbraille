//
//  ABBrailleReader.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTouchLayer.h"
#import "ABKeyboard.h"

// Prefix constants
static NSString *const ABPrefixLevelOne = @"001111";
static NSString *const ABPrefixNumber = @"001111"; // Level one and number are interchangable
static NSString *const ABPrefixLevelTwo = @"000010";
static NSString *const ABPrefixLevelThree = @"000111";
static NSString *const ABPrefixLevelFour = @"000101";
static NSString *const ABPrefixLevelFive = @"000011";
static NSString *const ABPrefixLevelSix = @"000001";
static NSString *const ABPrefixLevelSeven = @"000110";

@interface ABBrailleReader : NSObject <ABTouchReciever>

+ (NSString *)brailleStringFromTouchIDs:(NSArray *)touchIDs;
- (void)characterReceived:(NSString *)brailleString;
- (id)initWithAudioTarget:(id)target selector:(SEL)selector;

// Testing
- (NSString *)processString:(NSString *)brailleString;

@property (nonatomic) id<ABKeyboard> delegate;
@property (nonatomic) ABKeyboard *keyboardInterface;
@property (nonatomic) NSString *wordTyping;
@property (nonatomic) UITextView *fieldOutput;
@property (nonatomic) NSUInteger grade;
@end
