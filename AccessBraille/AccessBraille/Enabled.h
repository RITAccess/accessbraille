//
//  Enabled.h
//  AccessBraille
//
//  Created by Michael on 1/24/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Enabled : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)drawRect:(CGRect)rect;
@property(readwrite) BOOL enable;

@end
