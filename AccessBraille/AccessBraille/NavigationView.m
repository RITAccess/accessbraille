//
//  NavigationView.m
//  AccessBraille
//
//  Created by Michael on 1/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NavigationView.h"
#import "NavigationContainer.h"

@implementation NavigationView {
    
    void (^activateController)(NSString *storyboardInstance, BOOL menu, BOOL animated);
    
    UIImageView *item1;
    UIImageView *item2;
    UIImageView *item3;
    UIImageView *item4; // Instructions Image
    
    CGPoint sItem1;
    CGPoint sItem2;
    CGPoint sItem3;
    CGPoint sItem4; // Instructions Point
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"slideOutMenu.png"]]];
        
        UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 1]];
        item1 = [[UIImageView alloc] initWithFrame:CGRectMake(-75, 20, 75, 75)];
        item1.userInteractionEnabled = true;
        [item1 setImage:img1];
        [self addSubview:item1];
        
        UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 0]];
        item2 = [[UIImageView alloc] initWithFrame:CGRectMake(-100, 100, 75, 75)];
        item2.userInteractionEnabled = true;
        [item2 setImage:img2];
        [self addSubview:item2];
        
        UIImage *img3 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 2]];
        item3 = [[UIImageView alloc] initWithFrame:CGRectMake(-100, 100, 75, 75)];
        item3.userInteractionEnabled = true;
        [item3 setImage:img3];
        [self addSubview:item3];
        
        // Instructions Image
        UIImage *img4 = [UIImage imageNamed:[NSString stringWithFormat:@"menuItem%d", 3]];
        item4 = [[UIImageView alloc] initWithFrame:CGRectMake(-100, 100, 75, 75)];
        item4.userInteractionEnabled = true;
        [item4 setImage:img4];
        [self addSubview:item4];
        
        [self setGesturesWithSelector];
    }
    return self;
}

-(void)setControllerWithBlock:(void (^)(NSString *storyboardInstance, BOOL menu, BOOL animated))callback {
    
    activateController = callback;
    
}

-(void)setGesturesWithSelector {
    
    UITapGestureRecognizer *menuSelect1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
    UITapGestureRecognizer *menuSelect2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
    UITapGestureRecognizer *menuSelect3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
    UITapGestureRecognizer *menuSelect4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
    [item1 addGestureRecognizer:menuSelect1];
    [item1 setTag:1];
    [item2 addGestureRecognizer:menuSelect2];
    [item2 setTag:2];
    [item3 addGestureRecognizer:menuSelect3];
    [item3 setTag:3];
    [item4 addGestureRecognizer:menuSelect4];
    [item4 setTag:4];
}

-(void)menuItemTapped:(UITapGestureRecognizer *)reg {
    
    switch ([[reg view] tag]) {
        case 1:
            activateController(@"menu", NO, YES);
            break;
        case 2:
            activateController(@"brailleTyper", YES, YES);
            break;
        case 3:
            activateController(@"settings", YES, YES);
            break;
        case 4:
            activateController(@"InstructionsMenu", YES, YES);
            break;
            
        default:
            break;
    }
    
}

-(void)setStartNavigation{
    sItem1 = CGPointMake(10, self.frame.size.height - item1.frame.origin.y);
    sItem2 = CGPointMake(10, self.frame.size.height - item2.frame.origin.y);
    sItem3 = CGPointMake(10, self.frame.size.height - item3.frame.origin.y);
    sItem4 = CGPointMake(10, self.frame.size.height - item4.frame.origin.y);
}

-(void)updateWithCGPoint:(CGPoint)touchLocation {
    int xpos = touchLocation.x <= 100 ? touchLocation.x - 100 : 0;
    [super setFrame:CGRectMake(xpos, 0, 100, 748)];
    if ([self isActive]) {
        [self activeMenuItems];
    }
}

-(void)updateMenuWithCGPoint:(CGPoint)touchTran {
    [item1 setFrame:CGRectMake(10, self.frame.size.height - (touchTran.y + sItem1.y), 75, 75)];
    [item2 setFrame:CGRectMake(10, self.frame.size.height - (touchTran.y + sItem2.y), 75, 75)];
    [item3 setFrame:CGRectMake(10, self.frame.size.height - (touchTran.y + sItem3.y), 75, 75)];
    [item4 setFrame:CGRectMake(10, self.frame.size.height - (touchTran.y + sItem4.y), 75, 75)];
}

-(void)close {
    [UIView animateWithDuration:0.5 animations:^{
        [super setFrame:CGRectMake(-100, 0, 100, 748)];
        
        [item1 setFrame:CGRectMake(10, -100, 75, 75)];
        [item2 setFrame:CGRectMake(10, -100, 75, 75)];
        [item3 setFrame:CGRectMake(10, -100, 75, 75)];
        [item4 setFrame:CGRectMake(10, -100, 75, 75)];
    }];
}

-(void)activeMenuItems{
    
    [UIView animateWithDuration:0.5 animations:^{
        [item1 setFrame:CGRectMake(10, 300, 75, 75)];
        [item2 setFrame:CGRectMake(10, 380, 75, 75)];
        [item3 setFrame:CGRectMake(10, 460, 75, 75)];
        [item4 setFrame:CGRectMake(10, 540, 75, 75)];
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
