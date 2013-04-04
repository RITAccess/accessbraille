//
//  ABTypes.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/29/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/* Defines the gestures direction to work for both activation and deactivation */
typedef enum ABGestureDirection : NSUInteger ABGestureDirection;
enum ABGestureDirection : NSUInteger {
    ABGestureDirectionUP,
    ABGestureDirectionDOWN
};

/* String Constansts for keys in info dictionary */
static NSString *const ABGestureInfoStatus = @"ABGestureInfoStatus";

/* ABVector */
typedef struct {
    CGPoint start;
    CGPoint end;
} ABVector;

ABVector ABVectorMake(CGPoint start, CGPoint end);
NSString* ABVectorPrintable(ABVector vectors[]);
