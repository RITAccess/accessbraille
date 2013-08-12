//
//  TestABBrailleParsing.m
//  AccessBraille
//
//  Created by Michael Timbrook on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ABBrailleInterpreter.h"

@interface ABBrailleInterpreter ()

@end

@interface TestABBrailleParsing : SenTestCase

@property ABBrailleInterpreter *testABT;

@end

@implementation TestABBrailleParsing

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _testABT = [ABBrailleInterpreter new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testShiftLetter
{
    [_testABT.wordGraph removeAllObjects];
    [_testABT processBrailleString:@"100000" isShift:YES];
    STAssertTrue([[_testABT.wordGraph lastObject] isEqualToString:@"A"], @"String failed to capitalize, returned: %@", [_testABT.wordGraph lastObject]);
    
    [_testABT.wordGraph removeAllObjects];
    [_testABT processBrailleString:@"100000"];
    STAssertTrue([[_testABT.wordGraph lastObject] isEqualToString:@"a"], @"String failed to capitalize, returned: %@", [_testABT.wordGraph lastObject]);
}

- (void)testAddingToWordGraph
{
    [_testABT.wordGraph removeAllObjects];
    [_testABT processBrailleString:@"100000" isShift:YES];
    [_testABT processBrailleString:@"110000" isShift:NO];
    [_testABT processBrailleString:@"100100"];
    [_testABT processBrailleString:@"000111" isShift:YES];
    [_testABT processBrailleString:@"001111"];
    
    STAssertEqualObjects(_testABT.wordGraph[0], @"A", @"Not equal");
    STAssertEqualObjects(_testABT.wordGraph[1], @"b", @"Not equal");
    STAssertEqualObjects(_testABT.wordGraph[2], @"c", @"Not equal");
    STAssertEqualObjects(_testABT.wordGraph[3], @"000111", @"Not equal");
    STAssertEqualObjects(_testABT.wordGraph[4], @"001111", @"Not equal");
}

@end
