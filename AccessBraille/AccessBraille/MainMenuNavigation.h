//
//  MainMenuNavigation.h
//  AccessBraille
//
//  Created by Michael Timbrook on 2/15/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuNavigation : UIView

/* Access the display properties */
@property (nonatomic) BOOL visible;

/* Access and set the output text */
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *discription;

- (void)makeClear;

@end
