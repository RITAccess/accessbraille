//
//  ABParser.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABParser.h"

@implementation ABParser

/**
 * Parses a sentence into an array
 */
+ (NSArray *)arrayOfWordsFromSentence:(NSString *)sentence {
    // Checks to see if the string is empty
    if ([sentence isEqualToString:@""]){
        return false;
    }
    // regex to check for punctuation
    NSRegularExpression *punct = [[NSRegularExpression alloc] initWithPattern:@"[.,:;]" options:NSRegularExpressionSearch error:nil];
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSString *nextWord = @"";
    // Cycles through sentance to check each character for spaces or punctuation
    for(int index = 0; index <=[sentence length] - 1; index++){
        if ([sentence characterAtIndex:index] == ' '){
            [chars addObject:nextWord];
            nextWord = @"";
        } else {
            NSString *nextChar = [NSString stringWithFormat:@"%c", [sentence characterAtIndex:index]];
            NSArray *match = [punct matchesInString:nextChar options:NSMatchingCompleted range:NSMakeRange(0, nextChar.length)];
            if (match.count > 0) {
                continue;
            }
            nextWord = [nextWord stringByAppendingString:nextChar];
        }
    }
    [chars addObject:nextWord];
    nextWord = @"";
    return chars;
}

/**
 * Parses a word to an array of its chars all upper case.
 */
+ (NSArray *)arrayOfCharactersFromWord:(NSString *)word {
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:word.length];
    for (int i = 0; i < word.length; i++){
        char check = [word characterAtIndex:i];
        if (check == ' ') {
            return nil;
        } else if (ispunct(check)) {
            continue;
        }
        [characters addObject:[NSString stringWithFormat:@"%c", toupper(check)]];
    }
    return characters;
}

@end
