//
//  ABParser.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABParser : NSObject

/* Parses a sentance into an array of words */
+ (NSArray *)arrayOfWordsFromSentence:(NSString *)sentence;

/* Parses word down to array of chararacters */
+ (NSArray *)arrayOfCharactersFromWord:(NSString *)word;

@end
