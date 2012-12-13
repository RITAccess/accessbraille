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

- (int)tapInRadius:(CGPoint)touchPoint {
    
    float dx = ABS(_point.x - touchPoint.x);
    float dy = ABS(_point.y - touchPoint.y);
    float d = sqrtf(powf(dx, 2) + powf(dy, 2));
    if (d <= [detectRadius floatValue]) {
        return 1;
    } if (d - 25 <= [detectRadius floatValue]) {
        return 2;
    } else {
        return 0;
    }
}

- (NSNumber *)getCurrentID{
    return fingerID;
}

- (void)setRadius:(NSNumber *)radius{
    detectRadius = radius < @25 ? @25 : radius;
}

- (void)setNewID:(NSNumber *)newID{
    fingerID = newID;
}

- (id)stringValue{
    return [NSString stringWithFormat:@"CP %@ at (%f,%f)", fingerID, _point.x, _point.y];
}

@end
