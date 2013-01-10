//
//  NavigationView.m
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView 

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(void)updateWithCGPoint:(CGPoint)touchLocation {
    int xpos = touchLocation.x <= 100 ? touchLocation.x - 100 : 0;
    [super setFrame:CGRectMake(xpos, 0, 100, 748)];
}

-(void)close {
    [UIView animateWithDuration:0.5 animations:^{
        [super setFrame:CGRectMake(-100, 0, 100, 748)];
    }];
}

-(Boolean)isActive {
    
    CGPoint navPoint = [super frame].origin;
    NSLog(@"%f", navPoint.x);
    if (navPoint.x == 0) {
        return true;
    }
    
    return false;
}


@end
