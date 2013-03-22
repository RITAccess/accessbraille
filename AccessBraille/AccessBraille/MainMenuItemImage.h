//
//  MainMenuItemImage.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuImageTap <NSObject>

- (void)switchToControllerWithID:(NSNumber *)vcID;

@end

@interface MainMenuItemImage : UIImageView

@property (strong, nonatomic) id delegate;

- (void)tapMenuItem:(UITapGestureRecognizer *)reg;

@end
