//
//  AccessBrailleTests.m
//  AccessBrailleTests
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "AccessBrailleTests.h"
#import "CalibrationPoint.h"

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

- (void)testRadius
{
    CGPoint point;
    point.x = 0;
    point.y = 0;
    CGPoint testTouch;
    testTouch.x = 25;
    testTouch.y = 25;
    CGPoint notInTouch;
    notInTouch.x = 100;
    notInTouch.y = 100;
    CGPoint edgeCase;
    edgeCase.x = 0;
    edgeCase.y = 50;
    
    
    CalibrationPoint *test = [[CalibrationPoint alloc] initWithCGPoint:point withTmpID:@1];
    [test setRadius:@50];
    
    STAssertTrue([test tapInRadius:testTouch], @"Touch is valid");
    STAssertFalse([test tapInRadius:notInTouch], @"Toush not valid");
    STAssertTrue([test tapInRadius:edgeCase], @"Touch on edge");

}

@end
