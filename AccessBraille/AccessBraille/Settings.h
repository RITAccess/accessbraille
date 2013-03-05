//
//  Settings.h
//  AccessBraille
//
//  Created by Michael Timbrook on 2/20/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface Settings : UIViewController {
    // Voice Over
    
    FliteController *fliteController;
    Slt *slt;
}
- (IBAction)buttonPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@end
