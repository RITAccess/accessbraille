//
//  ABTypes.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/29/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTypes.h"

ABVector ABVectorMake(CGPoint start, CGPoint end) {
    ABVector *v = calloc(1,sizeof(ABVector));
    v->start = start;
    v->end = end;
    v->angle = -atan((start.y - end.y)/(end.x - start.x));
    return *v;
}

NSString* ABVectorPrintable(ABVector vectors[]) {
    int size = 6;
    NSString *stringVector = [NSString stringWithFormat:@"Array Size: %d\n", size];
    for (int i = 0; i < size; i++){
        stringVector = [stringVector stringByAppendingFormat:@"(%.1f,%.1f)->(%.1f,%.1f)", vectors[i].start.x, vectors[i].start.y, vectors[i].end.x, vectors[i].end.y];
        if (i < size - 1) {
            stringVector = [stringVector stringByAppendingString:@",\n"];
        }
    }
    return stringVector;
}
