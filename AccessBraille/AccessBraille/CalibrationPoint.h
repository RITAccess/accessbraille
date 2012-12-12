//
//  CalibrationPoint.h
//  AccessBraille
//
//  Created by Michael on 12/11/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalibrationPoint : NSObject

- (id)initWithCGPoint:(CGPoint)point withTmpID:(NSNumber *)finger;
- (int)tapInRadius:(CGPoint)touchPoint;
- (void)setRadius:(NSNumber *)radius;
- (void)setNewID:(NSNumber *)newID;
- (NSNumber *)getCurrentID;

@property CGPoint point;
@property float x;

@end
