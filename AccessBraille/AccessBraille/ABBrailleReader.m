//
//  ABBrailleReader.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABBrailleReader.h"
#import "ABKeyboard.h"
#import "ABSpeak.h"
#import "UITextView+simpleadd.h"

@implementation ABBrailleReader {
    
    // Look ups
    NSDictionary *grade2Lookup;
    NSDictionary *numberLookup;
    NSDictionary *prefixLevelTwo;
    NSDictionary *prefixLevelThree;
    NSDictionary *prefixLevelFour;
    NSDictionary *prefixLevelFive;
    NSDictionary *prefixLevelSix;
    NSDictionary *prefixLevelSeven;
    NSDictionary *shortHandlookup;
    
    BOOL numberMode;
    id target;
    SEL selector;
    
    ABSpeak *speak;
    
    // Grade 2 parsing
    __strong NSString *prefix;
    
}

- (id)initWithAudioTarget:(id)tar selector:(SEL)sel {
    self = [super init];
    if (self) {
        // init lookups
        NSString *path = [[NSBundle mainBundle] bundlePath];
        grade2Lookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"grade2lookup.plist"]];
        numberLookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"numberLookup.plist"]];
        prefixLevelTwo = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelTwo.plist"]];
        prefixLevelThree = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelThree.plist"]];
        prefixLevelFour = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelFour.plist"]];
        prefixLevelFive = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelFive.plist"]];
        prefixLevelSix = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelSix.plist"]];
        prefixLevelSeven = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelSeven.plist"]];
        shortHandlookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"shortHandLookup.plist"]];
        
        // Typing store
        _wordTyping = @"";
        
        // Default grade
        _grade = ABGradeTwo;
        
        // Setup parser
        prefix = @"";
        
        // Audio
        target = tar;
        selector = sel;
        speak = [[ABSpeak alloc] init];
    
    }
    return self;
}

/**
 * Takes an array of NSNumbers corresponding to finger placement on screen (left
 * to right) and returns the look up string for the braille dictionary
 */
+ (NSString *)brailleStringFromTouchIDs:(NSArray *)touchIDs {
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:6];
    [str setString:@"000000"];
    for (NSNumber *i in touchIDs) {
        if (i.intValue == 0) {
            [str replaceCharactersInRange:NSMakeRange(2, 1) withString:@"1"];
        } else if (i.intValue == 2) {
            [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@"1"];
        } else {
            [str replaceCharactersInRange:NSMakeRange(i.intValue, 1) withString:@"1"];
        }
    }
    return str;
}

/**
 * Receives character from touchLayer in form of braille string
 */
- (void)characterReceived:(NSString *)brailleString
{
    [self sendCharacter:[self processString:brailleString]];
}

+ (BOOL)isValidPrefix:(NSString *)braille
{
    return ([braille isEqualToString:ABPrefixLevelOne] ||
            [braille isEqualToString:ABPrefixLevelTwo] ||
            [braille isEqualToString:ABPrefixLevelThree] ||
            [braille isEqualToString:ABPrefixLevelFour] ||
            [braille isEqualToString:ABPrefixLevelFive] ||
            [braille isEqualToString:ABPrefixLevelSix] ||
            [braille isEqualToString:ABPrefixLevelSeven]);
}

/**
 * Handles grade parsing
 */
- (NSString *)processString:(NSString *)brailleString
{
    // Intercept prefix operators
    if ([ABBrailleReader isValidPrefix:prefix] && (_grade == ABGradeTwo) && ![brailleString isEqualToString:ABSpaceCharacter]) {
        // Handle prefix
        NSString *postfix = @"";
        if ([prefix isEqualToString:ABPrefixNumber] && [[numberLookup allKeys] containsObject:brailleString]) {
            postfix = numberLookup[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelTwo] && [[prefixLevelTwo allKeys] containsObject:brailleString]) {
            postfix = prefixLevelTwo[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelThree] && [[prefixLevelThree allKeys] containsObject:brailleString]) {
            postfix = prefixLevelThree[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelFour] && [[prefixLevelFour allKeys] containsObject:brailleString]) {
            postfix = prefixLevelFour[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelFive] && [[prefixLevelFive allKeys] containsObject:brailleString]) {
            postfix = prefixLevelFive[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelSix] && [[prefixLevelSix allKeys] containsObject:brailleString]) {
            postfix = prefixLevelSix[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelSeven] && [[prefixLevelSeven allKeys] containsObject:brailleString]) {
            postfix = prefixLevelSeven[brailleString];
        }
        _wordTyping = [_wordTyping stringByAppendingString:postfix];
        if (![prefix isEqualToString:ABPrefixNumber]) {
            prefix = @"";
        }
        return postfix;
        
    } else {
        prefix = brailleString;
        if ([ABBrailleReader isValidPrefix:prefix] && (_grade == ABGradeTwo)) {
            // return if a valid prefix is set
            return @"";
        }
        // if space proccess last typed word if grade two
        if ([brailleString isEqualToString:ABSpaceCharacter]) {
            NSString *word = @"";
            switch (_grade) {
                case ABGradeOne:
                    word = ABSpaceCharacter;
                    break;
                case ABGradeTwo:
                    if ([[shortHandlookup allKeys] containsObject:_wordTyping]) {
                        word = shortHandlookup[_wordTyping];
                    } else {
                        word = ABSpaceCharacter;
                    }
                    break;
            }
            [self sendWord:word];
            prefix = @"";
            _wordTyping = @"";
            return @"";
        }
        // Backspace
        if ([brailleString isEqualToString:ABBackspace]) {
            return ABBackspace;
        }
        
        // Is typed character
        if (_grade == ABGradeOne && [grade2Lookup[brailleString] length] > 1) {
            return @"";
        } else {
            if ([[grade2Lookup allKeys] containsObject:brailleString]) {
                _wordTyping = [_wordTyping stringByAppendingString:grade2Lookup[brailleString]];
                return grade2Lookup[brailleString];
            } else {
                return @"";
            }
        }
    }
}

- (void)sendCharacter:(NSString *)string
{
    
    if ([string isEqualToString:@""]) {
        return;
    }
    
    if ([string isEqualToString:ABSpaceCharacter]) {
        [_fieldOutput insertText:@" "];
        [_delegate characterTyped:@" " withInfo:@{ABGestureInfoStatus : @(YES),
                                                         ABSpaceTyped : @(YES),
                                                  ABBackspaceReceived : @(NO)}];
    } else if ([string isEqualToString:ABBackspace]) {
        [_fieldOutput deleteBackward];
        [_delegate characterTyped:@"" withInfo:@{ABGestureInfoStatus : @(YES),
                                                        ABSpaceTyped : @(NO),
                                                 ABBackspaceReceived : @(YES)}];
        [target performSelector:selector withObject:ABBackspaceSound];
    } else {
        [speak speakString:string];
        [_fieldOutput insertText:string];
        [_delegate characterTyped:string withInfo:@{ABGestureInfoStatus : @(YES),
                                                           ABSpaceTyped : @(NO),
                                                    ABBackspaceReceived : @(NO)}];
    }
}

- (void)sendWord:(NSString *)string
{
    [speak speakString:string];
    if (![string isEqualToString:ABSpaceCharacter]) {
        [_fieldOutput replaceLastWordWithString:string];
    }
    [_fieldOutput insertText:@" "];
}

@end
