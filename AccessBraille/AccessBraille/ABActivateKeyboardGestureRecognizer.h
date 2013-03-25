//
//  ABActivateKeyboardGestureRecognizer.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ABGestureDirection : NSUInteger ABGestureDirection;
enum ABGestureDirection : NSUInteger {
    ABGestureDirectionUP,
    ABGestureDirectionDOWN
};

@interface ABActivateKeyboardGestureRecognizer : UIGestureRecognizer

@property (nonatomic) ABGestureDirection activateDirection;
@property (nonatomic) float translationFromStart;

@end
