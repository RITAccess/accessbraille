//
//  FlashCard.m
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "FlashCard.h"

@interface FlashCard ()

@end

@implementation FlashCard {
 
    UILabel *title;
    NSTimer *speechTimer;
    NSMutableArray *cards;
}

/** Called when view loads. */
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Title
    title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 60)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"Flash Card Mode"];
    title.center = CGPointMake(550, 50);
    [title setFont: [UIFont fontWithName:@"Trebuchet MS" size:30.0f]];
    [[self view] addSubview:title];
}


/** Test method to pick a card from an array and call speak() to say the card. */
- (NSString*)chooseCard{
    cards = [NSArray arrayWithObjects:@"cat",@"red",@"top",nil];
    
    NSString *card = [cards objectAtIndex:1];
    
    return card;
}

@end
