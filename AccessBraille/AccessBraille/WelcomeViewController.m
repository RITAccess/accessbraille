//
//  WelcomeViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 7/3/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "WelcomeViewController.h"
#import <ABKeyboard/ABSpeak.h>

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *infoText;

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[[ABSpeak alloc]init]speakString:_infoText.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
