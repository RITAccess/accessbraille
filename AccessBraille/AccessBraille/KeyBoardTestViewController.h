//
//  KeyBoardTestViewController.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/22/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABKeyboard.h"

@interface KeyBoardTestViewController : UIViewController <ABKeyboard>

- (void)ABLog:(NSString *)log;

@end
