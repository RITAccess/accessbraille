//
//  ABActivateKeyboardGestureRecognizer.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Defines the gestures direction to work for both activation and deactivation */
typedef enum ABGestureDirection : NSUInteger ABGestureDirection;
enum ABGestureDirection : NSUInteger {
    ABGestureDirectionUP,
    ABGestureDirectionDOWN
};

/* String Constansts for keys in info dictionary */
static NSString *const ABGestureInfoStatus = @"ABGestureInfoStatus";

@protocol ABGestureRecognizerDelegate <NSObject>

@required

/* Gives the information about the touch locations for the keyboard */
- (void)touchColumnsWithInfo:(NSDictionary *)info;

@end

@interface ABActivateKeyboardGestureRecognizer : UIGestureRecognizer

/* State Properties */
@property (nonatomic) ABGestureDirection activateDirection;
@property (nonatomic) float translationFromStart;

/* Delegate for ABGestureRecognizer */
@property (strong, nonatomic) id touchDelegate;

/* Stops the gesture recognition and starts the keyboard area parsing */
- (void)getTouchInfo;

@end
