//
//  MainMenu.h
//  AccessBraille
//
//  Created by Michael Timbrook on 2/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuNavigation.h"

@interface MainMenu : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *BrailleTyperButton;
@property (strong, nonatomic) IBOutlet MainMenuNavigation *menuView;
- (IBAction)brailleTyper:(id)sender;
- (IBAction)settings:(id)sender;

@end
