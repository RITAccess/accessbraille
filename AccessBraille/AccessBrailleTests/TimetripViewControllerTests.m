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
- (void)startGame:(UITapGestureRecognizer *)gesture;

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
    timetrip.tapToStart = [UITapGestureRecognizer new];
    timetrip.tapToStart.enabled = NO;
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testClearPrompts
{
    STAssertNotNil(timetrip, @"View controller should not be nil.");
    STAssertNotNil(timetrip.typedText, @"String should not be nil.");
    [timetrip.typedText setText:@"Testing..."];
    [timetrip clearStrings];
    STAssertTrue([timetrip.typedText.text isEqualToString:@""], @"Text was not cleared.");
}

- (void)testDisableGestureOnTapStart
{
    STAssertNotNil(timetrip, @"View controller should not be nil.");
    STAssertNotNil(timetrip.tapToStart, @"Gesture should not be nil.");
    
    [timetrip startGame:nil];
    
    if (!timetrip.tapToStart.enabled){
        STFail(@"Gesture was not disabled.");
    }
}

@end
