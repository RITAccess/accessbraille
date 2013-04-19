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
static NSString *const ABSpaceTyped = @"ABSpaceTyped";
static NSString *const ABBackspaceReceived = @"ABBackspaceTyped";

/* String Space Constant */
static NSString *const ABSpaceCharacter = @"(SPACE)";
static NSString *const ABBackspace = @"(BACKSPACE)";

/* Audio Constants */
static NSString *const ABBackspaceSound = @"BS";
static NSString *const ABEnableSound = @"ES";
static NSString *const ABDisableSound = @"DS";

/* ABVector */
typedef struct {
    CGPoint start;
    CGPoint end;
    float angle;
} ABVector;

/* Creates an ABVector from two CGPoints */
ABVector ABVectorMake(CGPoint start, CGPoint end);

/* Returns a printable vertion of an ABVector array */
NSString* ABVectorPrintable(ABVector vectors[]);
