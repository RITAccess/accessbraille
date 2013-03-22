//
//  MainMenuItemImage.m
//  AccessBraille
//
//  Created by Michael Timbrook on 3/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenuItemImage.h"

@implementation MainMenuItemImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)tapMenuItem:(UITapGestureRecognizer *)reg {
    int tag = self.tag;
    if ([_delegate respondsToSelector:@selector(switchToControllerWithID:)]) {
        [_delegate switchToControllerWithID:@(tag - 31)];
    }
}

@end
