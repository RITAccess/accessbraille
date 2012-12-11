//
//  CalibrationPoint.m
//  AccessBraille
//
//  Created by Michael on 12/11/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "CalibrationPoint.h"

@implementation CalibrationPoint {
    NSNumber *detectRadius;
    NSNumber *fingerID;
}

@synthesize point = _point;
@synthesize x = _x;

- (id)initWithCGPoint:(CGPoint)point withTmpID:(NSNumber *)finger{
    if (self = [super init]) {
        _point = point;
        _x = point.x;
        fingerID = finger;
    }
    return self;
}

- (NSNumber *)getCurrentID{
    return fingerID;
}

- (void)setRadius:(NSNumber *)radius{
    detectRadius = radius;
}

- (void)setNewID:(NSNumber *)newID{
    fingerID = newID;
}

@end
