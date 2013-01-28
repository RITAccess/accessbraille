//
//  Enabled.m
//  AccessBraille
//
//  Created by Michael on 1/24/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "Enabled.h"

@implementation Enabled

@synthesize enable;
    
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        enable = FALSE;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, enable ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor);
    CGRect rectangle = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
}

@end
