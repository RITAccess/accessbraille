//
//  Drawing.m
//  AccessBraille
//
//  Created by Michael on 12/17/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "Drawing.h"

@implementation Drawing

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point radius:(int)radius {
    CGRect drawArea = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
    self = [super initWithFrame:drawArea];
    if (self){
       self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,[UIColor blueColor].CGColor);
    CGRect rectangle = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
}

@end
