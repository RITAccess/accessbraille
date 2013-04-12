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
+ (NSArray *)arrayOfWordsFromSentance:(NSString *)sentance;

@end
