//
//  ABTouchLayer.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/4/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABTypes.h"
#import "ABTouchView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ABBrailleInterpreter.h"
#import "KeyboardResponder.h"

@interface ABTouchLayer : UIView <ABTouchColumn>

- (void)resetView;
- (void)subViewsAdded;

/* Set sounds enabled */
@property BOOL sound;

/* responder and interpreter */
@property (strong) ABBrailleInterpreter *interpreter;
@property id<KeyboardResponder> reponder;

@property int ajt;
@end
