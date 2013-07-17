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
#import "ABParser.h"
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

- (id)init
{
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

    }
    return self;
}

- (id)initWithAudioTarget:(id)tar selector:(SEL)sel {
    self = [self init];
    if (self) {
        // Audio
        target = tar;
        selector = sel;
        speak = [ABSpeak sharedInstance];
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
- (NSString *)characterReceived:(NSString *)brailleString
{    
    NSString *returnChar = [self processString:brailleString];
    if ([returnChar isEqualToString:ABBackspace]) {
        [self sendBackspace];
    } else if (returnChar) {
        [self sendCharacter:returnChar];
    }
    return returnChar;
}

/**
 * Checks if a braille string is a prefix
 */
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
    // Backspace
    if ([brailleString isEqualToString:ABBackspace]) {
        if (_wordTyping.length > 0)
            _wordTyping = [_wordTyping substringWithRange:NSMakeRange(0, _wordTyping.length - 1)];
        return ABBackspace;
    }
    
    // Intercept prefix operators
    if ((_grade == ABGradeTwo) && [ABBrailleReader isValidPrefix:prefix] && ![brailleString isEqualToString:ABSpaceCharacter]) {
        // Handle prefix
        NSString *postfixChar = @"";
        if ([prefix isEqualToString:ABPrefixNumber] && [[numberLookup allKeys] containsObject:brailleString]) {
            postfixChar = numberLookup[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelTwo] && [[prefixLevelTwo allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelTwo[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelThree] && [[prefixLevelThree allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelThree[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelFour] && [[prefixLevelFour allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelFour[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelFive] && [[prefixLevelFive allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelFive[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelSix] && [[prefixLevelSix allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelSix[brailleString];
        } else if ([prefix isEqualToString:ABPrefixLevelSeven] && [[prefixLevelSeven allKeys] containsObject:brailleString]) {
            postfixChar = prefixLevelSeven[brailleString];
        }
        _wordTyping = [_wordTyping stringByAppendingString:postfixChar];
        if (![prefix isEqualToString:ABPrefixNumber]) {
            // If prefix is not a number prefix, clear it
            prefix = @"";
        }
        // return as a send char
        return postfixChar;
        
    } else {
        prefix = brailleString;
        // return if a valid prefix is set because it's not a character.
        if ([ABBrailleReader isValidPrefix:prefix])
            return nil;
        
        // if space proccess last typed word if grade two for shorthand lookup.
        if ([brailleString isEqualToString:ABSpaceCharacter]) {
            if (_grade == ABGradeTwo) {
                if ([[shortHandlookup allKeys] containsObject:_wordTyping]) {
                    _wordTyping = shortHandlookup[_wordTyping];
                    // Handle updating textview corrently
                }
            }
            [self sendWord:_wordTyping];
            prefix = @"";
            _wordTyping = @"";
            return nil; // return nil to not send character
        }
        
        // Is typed character
        if ([[grade2Lookup allKeys] containsObject:brailleString]) {
            NSString *lookup = grade2Lookup[brailleString];
            switch (_grade) {
                case ABGradeOne:
                    if (lookup.length == 1) { // Grade one is only single char
                        // Check shift/caps
                        if(_layer.shift) {
                            lookup = [lookup uppercaseString];
                            _layer.shift = NO;
                            [_layer setNeedsDisplay];
                        }
                        if (_layer.caps) {
                            lookup = [lookup uppercaseString];
                        }
                        _wordTyping = [_wordTyping stringByAppendingString:lookup];
                        return lookup;
                    }
                    break;
                case ABGradeTwo:
                    // Check shift/caps
                    if(_layer.shift) {
                        lookup = [NSString stringWithFormat:@"%@%@", [[lookup substringToIndex:1] uppercaseString], [lookup substringFromIndex:1]];;
                        _layer.shift = NO;
                        [_layer setNeedsDisplay];
                    }
                    if (_layer.caps) {
                        lookup = [lookup uppercaseString];
                    }
                    _wordTyping = [_wordTyping stringByAppendingString:lookup];
                    return lookup;
                    break;
            }
        }
    }
    return nil;
}

#pragma mark Handle updating with infomation

- (void)sendCharacter:(NSString *)string
{
    // Speak
    [speak speakString:string];
    
    // Update _fieldOutput
    if (_fieldOutput)
        _fieldOutput.text = [_fieldOutput.text stringByAppendingString:string];
    
    // Return char to delegate
    [self respondToDelegateWithInfo:@{ABGestureInfoStatus : @(YES),
                                      ABSpaceTyped : @(NO),
                                      ABBackspaceReceived : @(NO)}
                          wordTyped:NO
                             string:string];
}

- (void)sendWord:(NSString *)string
{
    // Speak
    [speak speakString:string];
    
    // Update _fieldOutput
    if (_fieldOutput) {
        NSArray *words = [ABParser arrayOfWordsFromSentence:_fieldOutput.text];
        NSString *newSent = @"";
        for (int i = 0; i < words.count - 1; i++) {
            newSent = [newSent stringByAppendingString:words[i]];
            newSent = [newSent stringByAppendingString:@" "];
        }
        _fieldOutput.text = [newSent stringByAppendingString:string];
        [_fieldOutput insertText:@" "];
    }
    // Return word to delegate
    [self respondToDelegateWithInfo:@{ABGestureInfoStatus : @(YES),
                                      ABSpaceTyped : @(YES),
                                      ABBackspaceReceived : @(NO)}
                          wordTyped:NO
                             string:ABSpaceCharacter];
    [self respondToDelegateWithInfo:@{ABGestureInfoStatus : @(YES),
                                      ABSpaceTyped : @(NO),
                                      ABBackspaceReceived : @(NO)}
                          wordTyped:YES
                             string:string];
}

- (void)sendBackspace
{
    // Update _fieldOutput
    
    if (_fieldOutput && _fieldOutput.text.length > 0)
        _fieldOutput.text = [_fieldOutput.text substringWithRange:NSMakeRange(0, _fieldOutput.text.length - 1)];
    
    // Return backspace to delegate
    [self respondToDelegateWithInfo:@{ABGestureInfoStatus : @(YES),
                                      ABSpaceTyped : @(NO),
                                      ABBackspaceReceived : @(YES)}
                          wordTyped:NO
                             string:ABBackspace];
    
    // Backspace sound
    [target performSelector:selector withObject:ABBackspaceSound];
}

- (void)respondToDelegateWithInfo:(NSDictionary *)info wordTyped:(BOOL)word string:(NSString *)string
{
    if (!word && [_delegate respondsToSelector:@selector(characterTyped:withInfo:)]) {
        [_delegate characterTyped:string withInfo:info];
    } else if (word && [_delegate respondsToSelector:@selector(wordTyped:withInfo:)]) {
        [_delegate wordTyped:string withInfo:info];
    }
}
@end
