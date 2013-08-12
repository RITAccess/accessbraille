//
//  ABBrailleInterpreter.h
//  AccessBraille
//
//  Created by Michael Timbrook on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardResponder.h"
#import "ABTypes.h"

// Prefix constants
static NSString *const ABPrefixLevelOne = @"001111";
static NSString *const ABPrefixNumber = @"001111";
static NSString *const ABPrefixLevelTwo = @"000010";
static NSString *const ABPrefixLevelThree = @"000111";
static NSString *const ABPrefixLevelFour = @"000101";
static NSString *const ABPrefixLevelFive = @"000011";
static NSString *const ABPrefixLevelSix = @"000001";
static NSString *const ABPrefixLevelSeven = @"000110";

@interface ABBrailleInterpreter : NSObject

/* The array of letters that build a word */
@property NSMutableArray *wordGraph;

/* Responder for class */
@property (retain, nonatomic) id<KeyboardResponder> responder;

/* Grade */
@property ABGrade grade;

/**
 * Process the braille string recieved from the braille typer and passes the
 * found character to the keyboard responder, default shift is NO
 */
- (void)processBrailleString:(NSString *)braille;
- (void)processBrailleString:(NSString *)braille isShift:(BOOL)shift;

/**
 * Resets the state of the Interpreter
 */
- (void)reset;

/**
 * Removes one off the end of the word graph
 */
- (void)dropEndOffGraph;

/**
 * Gets the current "Build" of the word
 */
- (NSString *)getCurrentWord;

/**
 * Checks if a braille string is a prefix
 */
+ (BOOL)isValidPrefix:(NSString *)braille;

@end
