//
//  ViewController.h
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"

@interface BrailleTyperController : UIViewController
@property (strong, nonatomic) IBOutlet Drawing *DrawingView;
@property (weak, nonatomic) IBOutlet UILabel *typingStateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *textOutput;

@end
