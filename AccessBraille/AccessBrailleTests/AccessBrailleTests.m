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
    
    [super tearDown];
}

- (void)testTest {
    STAssertEquals(1+2, 3, @"1+2 doesn not equal three");
}
@end
