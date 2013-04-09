//
//  NSArray+ObjectSubsets.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/11/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NSArray+ObjectSubsets.h"

@implementation NSArray (ObjectSubsets)

/**
 * Returns a sub array from array of objects that pass comare block
 */
+ (NSArray *)arrayFromArray:(NSArray *)array passingTest:(BOOL (^)(id obj1))compare {
    NSMutableArray *subset = [[NSMutableArray alloc] init];
    for (int i=0; i < array.count; i++){
        if (compare(array[i])){
            [subset addObject:array[i]];
        }
    }
    return [[NSArray alloc] initWithArray:subset];
}

/**
 * Adds two arrays together and sorts them by the touch points x value
 */
+ (NSArray *)addToArrayCopiesfrom:(NSArray *)arrayAdd withReferanceToView:(UIView *)view intoArray:(NSArray *)parentArray {
    
    NSArray *all = [parentArray arrayByAddingObjectsFromArray:arrayAdd];
    
    NSMutableArray *final = [[NSMutableArray alloc] initWithArray:all copyItems:YES];    
    
    return [final sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([(UITouch *)obj1 locationInView:view].x < [(UITouch *)obj2 locationInView:view].x) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

/**
 * Displays an array on a single line output using default description
 */
- (NSString *)oneLineNSStringOfArray {
    NSString *returnString = @"";
    for (id obj in self){
        returnString = [returnString stringByAppendingString:[obj description]];
        returnString = [returnString stringByAppendingString:@" | "];
    }
    return returnString;
}

/**
 * Displays an array on a single line output using a discription block
 */
- (NSString *)oneLineNSStringOfArrayWithDescriptionBlock:(NSString * (^)(id obj))toString {
    NSString *returnString = @"";
    for (id obj in self){
        returnString = [returnString stringByAppendingString:toString(obj)];
        returnString = [returnString stringByAppendingString:@" | "];
    }
    return returnString;
}


@end
