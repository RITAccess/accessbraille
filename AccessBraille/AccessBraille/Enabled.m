//
//  Enabled.m
//  AccessBraille
//
//  Created by Michael on 1/24/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "Enabled.h"

@implementation Enabled {
    
    UIPanGestureRecognizer *move;
    CGPoint origin;
    
}

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
    
    move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [move setMinimumNumberOfTouches:1];
    [move setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:move];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, enable ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor);
    CGRect rectangle = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
}

- (void)move:(UIPanGestureRecognizer *)reg {
    
    CGPoint tran = [reg translationInView:self.superview];
    
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            origin = [reg locationInView:self.superview];
            NSLog(@"%f,%f", origin.x, origin.y);
            break;
        case UIGestureRecognizerStateChanged:

            [self setFrame:CGRectMake(origin.x + tran.x, origin.y + tran.y, self.frame.size.width, self.frame.size.height)];
            
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
        default:
            break;
    }
    
}

@end
