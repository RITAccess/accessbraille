//
//  NSArray+ObjectSubsets.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/11/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NSArray+ObjectSubsets.h"

@implementation NSArray (ObjectSubsets)

+ (NSArray *)arrayFromArray:(NSArray *)array passingTest:(BOOL (^)(id obj1))compare {
    NSMutableArray *subset = [[NSMutableArray alloc] init];
    for (int i=0; i < array.count; i++){
        if (compare(array[i])){
            [subset addObject:array[i]];
        }
    }
    return [[NSArray alloc] initWithArray:subset];
}


@end
