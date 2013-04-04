//
//  NSArray+ObjectSubsets.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/11/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ObjectSubsets)

/* Returns a sub array from array */
+ (NSArray *)arrayFromArray:(NSArray *)array passingTest:(BOOL (^)(id obj1))compare;

/* Adds arrays together and keeps them sorted **ONLY UITOUCHES** */
+ (NSArray *)addToArrayCopiesfrom:(NSArray *)arrayAdd withReferanceToView:(UIView *)view intoArray:(NSArray *)parentArray;

/* Makes a nice one line statement */
- (NSString *)oneLineNSStringOfArray;
- (NSString *)oneLineNSStringOfArrayWithDescriptionBlock:(NSString * (^)(id obj))toString;

@end
