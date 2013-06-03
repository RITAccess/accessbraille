//
//  ABTouchView.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/5/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABTouchColumn <NSObject>
@required
/* Sends touch interface to ABTouchLayer to be processed */
- (void)touchWithId:(NSInteger)tapID tap:(BOOL)tapped;
- (CGPoint)locationInDelegate:(UITapGestureRecognizer *)reg;
- (float)averageY;
- (void)updateYAverage:(float)newPoint;
- (void)space;

@end

@interface ABTouchView : UIView

/* Delegate */
@property id<ABTouchColumn> delegate;

@end
