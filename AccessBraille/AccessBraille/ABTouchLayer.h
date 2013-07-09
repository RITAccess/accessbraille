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

@protocol ABTouchReciever <NSObject>
@required
- (void)characterReceived:(NSString *)brailleString;
@end

@interface ABTouchLayer : UIView <ABTouchColumn>

- (void)resetView;
- (void)subViewsAdded;

@property BOOL shift;
@property BOOL caps;

/* Set sounds enabled */
@property BOOL sound;

@property (nonatomic) id<ABTouchReciever> delegate;
@property int ajt;
@end
