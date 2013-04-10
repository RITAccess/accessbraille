//
//  FlashCard.h
//  AccessBraille
//
//  Created by Piper Chester on 3/26/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import "ABKeyboard.h"

@interface FlashCard : UIViewController <ABKeyboard> {
    FliteController *fliteController;
    Slt *slt;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@end
