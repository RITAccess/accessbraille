//
//  CalibrationPoint.m
//  AccessBraille
//
//  Created by Michael on 12/11/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

/**
    Object to store the information about finger calibration points
 */

#import "CalibrationPoint.h"

@implementation CalibrationPoint {
    NSNumber *detectRadius;
    NSNumber *fingerID;
    NSNumber *buffer;
}

@synthesize point = _point;
@synthesize x = _x;


- (id)initWithCGPoint:(CGPoint)point withTmpID:(NSNumber *)finger{
    /**
        Takes a point and finger id to set position data.
     */
    if (self = [super init]) {
        _point = point;
        _x = point.x;
        fingerID = finger;
    }
    return self;
}

- (int)tapInRadius:(CGPoint)touchPoint {
    /**
        checks the status of a point and returns status by
            0 : False
            1 : True
            2 : In Buffer
     */
    float dx = ABS(_point.x - touchPoint.x);
    float dy = ABS(_point.y - touchPoint.y);
    float d = sqrtf(powf(dx, 2) + powf(dy, 2));
    if (d <= [detectRadius floatValue]) {
        return 1;
    } if (d - [buffer floatValue] <= [detectRadius floatValue]) {
        return 2;
    } else {
        return 0;
    }
}

- (NSNumber *)getCurrentID{
    return fingerID;
}

- (void)setRadius:(NSNumber *)radius{
    detectRadius = radius;
}

- (NSNumber *)getRadius{
    return detectRadius;
}

- (void)setBuffer:(NSNumber *)bufferRF {
    buffer = bufferRF;
}

- (void)setNewID:(NSNumber *)newID{
    fingerID = newID;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CP %@ at (%f,%f) radius %@", fingerID, _point.x, _point.y, detectRadius];
    
}

@end
