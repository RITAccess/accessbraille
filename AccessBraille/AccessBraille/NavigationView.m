//
//  NavigationView.m
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView {
    
    CGPoint lastTouchLocation;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(void)updateWithCGPoint:(CGPoint)touchLocation {
    NSLog(@"Touch Point update called");
    
    int locationXDelta = 0;
    int xpos = touchLocation.x <= 100 ? touchLocation.x - 100 : 0;
    [super setFrame:CGRectMake(xpos, 0, 100, 748)];
    
    lastTouchLocation = touchLocation;
}



@end
