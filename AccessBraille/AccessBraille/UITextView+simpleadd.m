//
//  UITextField+simpleadd.m
//  AccessBraille
//
//  Created by Michael Timbrook on 6/24/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "UITextView+simpleadd.h"
#import "ABParser.h"

@implementation UITextView (simpleadd)

- (void)replaceLastWordWithString:(NSString *)string
{
    NSArray *words = [self arrayOfWordsFromSentence:self.text];
    NSLog(@"%@", words);
    NSString *lastWord = [words lastObject];
    NSString *newString = [self.text substringWithRange:NSMakeRange(0, self.text.length - lastWord.length)];
    self.text = [newString stringByAppendingString:string];
}

- (NSArray *)arrayOfWordsFromSentence:(NSString *)sentence {
    // Checks to see if the string is empty
    if ([sentence isEqualToString:@""]){
        return false;
    }
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSString *nextWord = @"";
    // Cycles through sentance to check each character for spaces or punctuation
    for(int index = 0; index < [sentence length]; index++){
        if ([sentence characterAtIndex:index] == ' '){
            [chars addObject:nextWord];
            nextWord = @"";
        } else {
            NSString *nextChar = [NSString stringWithFormat:@"%c", [sentence characterAtIndex:index]];
            nextWord = [nextWord stringByAppendingString:nextChar];
        }
    }
    [chars addObject:nextWord];
    return chars;
}

@end
