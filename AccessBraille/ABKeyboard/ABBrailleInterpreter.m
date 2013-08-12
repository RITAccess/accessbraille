//
//  ABBrailleInterpreter.m
//  AccessBraille
//
//  Created by Michael Timbrook on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABBrailleInterpreter.h"

@implementation ABBrailleInterpreter
{
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
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Load in dictionaries
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
        // Init wordgraph
        _wordGraph = [NSMutableArray new];
        // Set default grade
        _grade = ABGradeTwo;
    }
    return self;
}

#pragma mark Processing

- (void)processBrailleString:(NSString *)braille
{
    [self processBrailleString:braille isShift:NO];
}
- (void)processBrailleString:(NSString *)braille isShift:(BOOL)shift
{
    if (_grade == ABGradeOne)
        goto gradeLookup;
    
    if ([ABBrailleInterpreter isValidPrefix:braille]) {
        [_wordGraph addObject:braille];
        return;
    }
    
    if (_wordGraph.count == 0) {
        if ([[grade2Lookup allKeys] containsObject:braille]) {
            NSString *ch = grade2Lookup[braille];
            ch = shift ? ch.uppercaseString : ch.lowercaseString;
            [_wordGraph addObject:ch];
            [self passToResponder:ch];
        }
        return;
    }
    
    if ([ABBrailleInterpreter isValidPrefix:_wordGraph.lastObject]) {
        NSString *ch = [self getPostfixCharacter:braille withPrefix:_wordGraph.lastObject];
        ch = shift ? ch.uppercaseString : ch.lowercaseString;
        [_wordGraph addObject:ch];
        [self passToResponder:ch];
        return;
    }

gradeLookup:
    
    if ([[grade2Lookup allKeys] containsObject:braille]) {
        NSString *ch = grade2Lookup[braille];
        ch = shift ? ch.uppercaseString : ch.lowercaseString;
        [_wordGraph addObject:ch];
        if (_grade == ABGradeOne && ch.length == 1) {
            [self passToResponder:ch];
        } else {
            [self passToResponder:ch];
        }
    }
    
}

- (NSString *)getPostfixCharacter:(NSString *)brailleString withPrefix:(NSString *)prefix
{
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
    return postfixChar;
}

- (void)passToResponder:(NSString *)character
{
    if ([_responder respondsToSelector:@selector(newCharacterFromInterpreter:)]) {
        [_responder newCharacterFromInterpreter:character];
    }
}

- (void)reset
{
    [_wordGraph removeAllObjects];
}

- (void)dropEndOffGraph
{
    if (_wordGraph.count > 0) {
        [_wordGraph removeLastObject];
    }
}

- (NSString *)getCurrentWord;
{
    NSString *word = @"";
    for (NSString *str in _wordGraph) {
        if (![ABBrailleInterpreter isValidPrefix:str]) {
            word = [word stringByAppendingString:str];
        }
    }
    return word;
}

#pragma mark Helpers

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

@end
