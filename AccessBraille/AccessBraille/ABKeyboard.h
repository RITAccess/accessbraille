//
//  ABKeyboard.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ABActivateKeyboardGestureRecognizer.h"

@protocol ABKeyboard <NSObject>

@optional

/* Option to recieve status logs from keyboard */
- (void)ABLog:(NSString *)log;

@end

@interface ABKeyboard : UIView

/* Delegate */
@property (strong, nonatomic) id delegate;

/* Init methods to set up the Keyboard Controller */
- (id)init;
- (void)ABKeyboardRecognized:(ABActivateKeyboardGestureRecognizer *)reg;

@end
