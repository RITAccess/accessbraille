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

- (void)switchToControllerWithID:(NSNumber *)vcID;

@end
