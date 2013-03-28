//
//  AccessBrailleTests.m
//  AccessBrailleTests
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "AccessBrailleTests.h"
#import "CalibrationPoint.h"
#import "BrailleInterpreter.h"
#import "BrailleTyperController.h"
#import "MainMenu.h"

@implementation AccessBrailleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    
    MainMenu *testMenu = [[MainMenu alloc] init];
    
    [testMenu moveMenuItemsByDelta:20];
    
    [super tearDown];
}

@end
