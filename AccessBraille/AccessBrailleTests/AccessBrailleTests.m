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

- (void)testBrailleInterpreter
{
    // Set up CP's ## Currently failing case - unknown reason ##
    CalibrationPoint *a = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(658, 587.5) withTmpID:@1];
    CalibrationPoint *b = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(721.5, 431.5) withTmpID:@1];
    CalibrationPoint *c = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(840.5, 294) withTmpID:@1];
    CalibrationPoint *d = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(225.5, 346.5) withTmpID:@1];
    CalibrationPoint *e = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(354.5, 591) withTmpID:@1];
    CalibrationPoint *f = [[CalibrationPoint alloc] initWithCGPoint:CGPointMake(302.5, 447.5) withTmpID:@1];
    
    UIViewController *testView = [[UIViewController alloc] initWithNibName:@"testingViewController" bundle:nil];
    [testView loadView];
    
    BrailleInterpreter *bi = [[BrailleInterpreter alloc] initWithViewController:testView];
    [bi addCalibrationPoint:a];
    [bi addCalibrationPoint:b];
    [bi addCalibrationPoint:c];
    [bi addCalibrationPoint:d];
    [bi addCalibrationPoint:e];
    [bi addCalibrationPoint:f];
    
    [bi setUpCalibration];
    
    
    
}

@end
