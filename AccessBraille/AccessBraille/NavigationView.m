//
//  NavigationView.m
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView {
    
    UIImageView *item1;
    UIImageView *item2;
    UIImageView *item3;
    UIImageView *item4;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor orangeColor];
        
        UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 1]];
        item1 = [[UIImageView alloc] initWithFrame:CGRectMake(-75, 20, 75, 75)];
        [item1 setImage:img1];
        [self addSubview:item1];
        
        UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 1]];
        item2 = [[UIImageView alloc] initWithFrame:CGRectMake(-100, 100, 75, 75)];
        [item2 setImage:img2];
        [self addSubview:item2];
        
        UIImage *img3 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 1]];
        item3 = [[UIImageView alloc] initWithFrame:CGRectMake(-125, 180, 75, 75)];
        [item3 setImage:img3];
        [self addSubview:item3];
        
        UIImage *img4 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 1]];
        item4 = [[UIImageView alloc] initWithFrame:CGRectMake(-150, 260, 75, 75)];
        [item4 setImage:img4];
        [self addSubview:item4];
    }
    return self;
}

-(void)updateWithCGPoint:(CGPoint)touchLocation {
    int xpos = touchLocation.x <= 100 ? touchLocation.x - 100 : 0;
    [super setFrame:CGRectMake(xpos, 0, 100, 748)];
    if ([self isActive]) {
        [self activeMenuItems];
    }
}

-(void)updateMenuWithCGPoint:(CGPoint)touchLocation {
    float Y = touchLocation.y;
    float Yi = 748 - Y;
    
    float pos = Yi / 2;
    
    NSLog(@"test Y: %f", pos);
    
    
}

-(void)close {
    [UIView animateWithDuration:0.5 animations:^{
        [super setFrame:CGRectMake(-100, 0, 100, 748)];
        [item1 setFrame:CGRectMake(-75, 20, 75, 75)];
        [item2 setFrame:CGRectMake(-100, 100, 75, 75)];
        [item3 setFrame:CGRectMake(-125, 180, 75, 75)];
        [item4 setFrame:CGRectMake(-150, 260, 75, 75)];
    }];
}

-(void)activeMenuItems{
    
    [UIView animateWithDuration:0.5 animations:^{
        [item1 setFrame:CGRectMake(10, 20, 75, 75)];
        [item2 setFrame:CGRectMake(10, 100, 75, 75)];
        [item3 setFrame:CGRectMake(10, 180, 75, 75)];
        [item4 setFrame:CGRectMake(10, 260, 75, 75)];
    }];
    
}



-(Boolean)isActive {
    CGPoint navPoint = [super frame].origin;
    if (navPoint.x == 0) {
        return true;
    }
    return false;
}


@end
