//
//  NSArray+ObjectSubsets.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/11/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ObjectSubsets)

+ (NSArray *)arrayFromArray:(NSArray *)array passingTest:(BOOL (^)(id obj1))compare;

@end
