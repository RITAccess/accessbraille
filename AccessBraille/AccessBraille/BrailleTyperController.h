//
//  ViewController.h
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"
#import "BrailleTyperOutputView.h"
#import <CoreData/CoreData.h>
#import "ABKeyboard.h"

@interface BrailleTyperController : UIViewController <NSFetchedResultsControllerDelegate, ABKeyboard>

-(void)saveState;

@property (strong, nonatomic) IBOutlet Drawing *DrawingView;
@property (weak, nonatomic) IBOutlet UILabel *typingStateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *textOutput;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet BrailleTyperOutputView *TextDrawing;
@end
