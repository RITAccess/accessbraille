//
//  MainMenu.h
//  AccessBraille
//
//  Created by Michael Timbrook on 2/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuNavigation.h"
#import "MainMenuItemImage.h"

@interface MainMenu : UIViewController <MenuImageTap>

@property (strong, nonatomic) IBOutlet MainMenuNavigation *menuView;
@property (weak, nonatomic) IBOutlet UILabel *OverlayTitle;
@property (weak, nonatomic) IBOutlet UITextView *OverlayDiscription;

- (void)switchToControllerWithID:(NSNumber *)vcID;
- (void)loadMenuItemsAnimated:(BOOL)animated;

@end
