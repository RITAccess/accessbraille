//
//  AboutViewController.m
//  AccessBraille
//
//  Created by Piper Chester on 6/10/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *contents = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@".rtf"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:contents];
    
    [_aboutView loadRequest:request];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
