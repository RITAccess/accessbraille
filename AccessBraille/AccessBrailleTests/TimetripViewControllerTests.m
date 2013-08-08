//
//  TimetripViewControllerTests.m
//  AccessBraille
//
//  Created by Piper Chester on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TimetripViewController.h"

@interface TimetripViewControllerTests : SenTestCase

@end

@interface TimetripViewController (TimetripTest)

- (void)clearStrings;

@end

@implementation TimetripViewControllerTests
{
    TimetripViewController *timetrip;
}

- (void)setUp
{
    [super setUp];
    timetrip = [TimetripViewController new];
    timetrip.typedText = [UITextView new];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testClearPrompts
{
    [timetrip.typedText setText:@"Testing..."];
    [timetrip clearStrings];
    STAssertTrue([timetrip.typedText.text isEqualToString:@""], @"Text was not cleared...");
}

@end
