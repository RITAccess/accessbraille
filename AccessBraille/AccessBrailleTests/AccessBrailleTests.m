//
//  AccessBrailleTests.m
//  AccessBrailleTests
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "AccessBrailleTests.h"
#import <UIKit/UIKit.h>
#import "ABTypes.h"

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

- (void)testABVectors {
    
    ABVector testVector = ABVectorMake(CGPointMake(0, 0), CGPointMake(10, 10));
    
    STAssertEquals(testVector.start.x, 0, @"Not Equal");
    
}
@end
