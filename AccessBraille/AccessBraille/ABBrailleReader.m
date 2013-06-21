//
//  ABBrailleReader.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABBrailleReader.h"
#import "ABKeyboard.h"

@implementation ABBrailleReader {
    
    // Look ups
    NSDictionary *grad2Lookup;
    NSDictionary *numberLookup;
    NSDictionary *prefixLevelTwo;
    NSDictionary *prefixLevelThree;
    
    BOOL numberMode;
    id target;
    SEL selector;
    
    // Grade 2 parsing
    __strong NSString *prefix;
    
}

- (id)initWithAudioTarget:(id)tar selector:(SEL)sel {
    self = [super init];
    if (self) {
        // init lookups
        NSString *path = [[NSBundle mainBundle] bundlePath];
        grad2Lookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"grade2lookup.plist"]];
        numberLookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"numberLookup.plist"]];
        prefixLevelTwo = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelTwo.plist"]];
        prefixLevelThree = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"prefixLevelThree.plist"]];
        
        // Typing store
        _wordTyping = @"";
        
        // Default grade
        _grade = ABGradeTwo;
        
        // Setup parser
        prefix = @"";
        
        // Audio
        target = tar;
        selector = sel;
    
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
    [self sendCharacter:[self proccessString:brailleString]];
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
- (NSString *)proccessString:(NSString *)brailleString
{
    // Intercept prefix operators
    if ([ABBrailleReader isValidPrefix:prefix] && (_grade == ABGradeTwo) && ![brailleString isEqualToString:ABSpaceCharacter]) {
        // Handle prefix
        NSString *postfix = @"";
        if ([prefix isEqualToString:ABPrefixNumber]) {
            postfix = numberLookup[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelTwo]) {
            postfix = prefixLevelTwo[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelThree]) {
            postfix = prefixLevelThree[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelFour]) {
        
        } else if ([prefix isEqualToString:ABPrefixLevelFive]) {
            
        } else if ([prefix isEqualToString:ABPrefixLevelSix]) {
            
        } else if ([prefix isEqualToString:ABPrefixLevelSeven]) {
        
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
                    // Handle single letter cases
                    word = ABSpaceCharacter;
                    break;
            }
            [self sendWord:_wordTyping];
            prefix = @"";
            _wordTyping = @"";
            return word;
        }
        // Backspace
        if ([brailleString isEqualToString:ABBackspace]) {
            return ABBackspace;
        }
        
        // Is typed character
        if (_grade == ABGradeOne && [grad2Lookup[brailleString] length] > 1) {
            return @"";
        } else {
            _wordTyping = [_wordTyping stringByAppendingString:grad2Lookup[brailleString]];
            return grad2Lookup[brailleString];
        }
    }
}

- (void)sendCharacter:(NSString *)string
{
    if ([string isEqualToString:ABSpaceCharacter]) {
        [_delegate characterTyped:@" " withInfo:@{ABGestureInfoStatus : @(YES),
                                                         ABSpaceTyped : @(YES),
                                                  ABBackspaceReceived : @(NO)}];
    } else if ([string isEqualToString:ABBackspace]) {
        [_delegate characterTyped:@"" withInfo:@{ABGestureInfoStatus : @(YES),
                                                        ABSpaceTyped : @(NO),
                                                 ABBackspaceReceived : @(YES)}];
        [target performSelector:selector withObject:ABBackspaceSound];
    } else {
        [_delegate characterTyped:string withInfo:@{ABGestureInfoStatus : @(YES),
                                                           ABSpaceTyped : @(NO),
                                                    ABBackspaceReceived : @(NO)}];
    }
}

- (void)sendWord:(NSString *)string
{
    NSLog(@"Word: %@", string);
}

@end
