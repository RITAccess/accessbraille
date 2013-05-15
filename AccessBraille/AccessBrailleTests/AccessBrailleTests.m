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
#import "ABBrailleReader.h"
#import "ABParser.h"
#import "SidebarViewController.h"
#import "MainMenuItemImage.h"
#import "NSArray+ObjectSubsets.h"
#import "MainMenu.h"
#import "MainMenuItemImage.h"

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

- (void)testStringBrailleBits {
    
    NSArray *test = @[@2,@3];
    STAssertEqualObjects([ABBrailleReader brailleStringFromTouchIDs:test], @"100100",@"Not Equal: %@", [ABBrailleReader brailleStringFromTouchIDs:test]);
    
}

- (void)testABVectors {
    // Test 45
    ABVector testVector = ABVectorMake(CGPointMake(0, 0), CGPointMake(10, 10));
    STAssertEquals(testVector.angle, (float)M_PI_4, @"Not Equal : %f != %f", testVector.angle, M_PI_4);
    
    // Test Vertical
    ABVector testVector2 = ABVectorMake(CGPointMake(0, 0), CGPointMake(0, 10));
    STAssertEquals(testVector2.angle, (float)M_PI_2, @"Not Equal : %f != %f", testVector2.angle, M_PI_2);
    
    // Test Horizontal
    ABVector testVector3 = ABVectorMake(CGPointMake(0, 0), CGPointMake(10, 0));
    STAssertEquals(testVector3.angle, -0.0f, @"Not Equal : %f != %f", testVector3.angle, -0);
    
    // Test 30
    ABVector testVector4 = ABVectorMake(CGPointMake(0, 0), CGPointMake(3, sqrtf(3)));
    STAssertEquals(testVector4.angle, (float)(M_PI/6), @"Not Equal : %f != %f", testVector4.angle, (M_PI/6));
    
    // Test 60
    ABVector testVector5 = ABVectorMake(CGPointMake(0, 0), CGPointMake(sqrtf(3),3));
    STAssertEquals(testVector5.angle, (float)(M_PI/3), @"Not Equal : %f != %f", testVector5.angle, (M_PI/3));
    
    // Test 30 with backward points
    ABVector testVector6 = ABVectorMake(CGPointMake(3, sqrtf(3)), CGPointMake(0,0));
    STAssertEquals(testVector6.angle, (float)(M_PI/6), @"Not Equal : %f != %f", testVector6.angle, (M_PI/6));

    // Test -60
    ABVector testVector7 = ABVectorMake(CGPointMake(0, 0), CGPointMake(-sqrtf(3),3));
    STAssertEquals(testVector7.angle, -(float)(M_PI/3), @"Not Equal : %f != %f", testVector7.angle, -(M_PI/3));
}

- (void)testABParser {
    
    // Sentance parser
    NSString *test = @"This is a, test sentace.";
    NSArray *testArray = @[@"This", @"is", @"a", @"test", @"sentace"];
    
    NSArray *parsedArray = [ABParser arrayOfWordsFromSentence:test];
    
    STAssertEqualObjects(parsedArray, testArray, @"Arrays are not equal");
    
    // Word parser
    NSString *t1 = @"basic"; // B A S I C
    NSString *t2 = @"multi word"; // nil;
    NSString *t3 = @"it's"; // I T S
    
    NSArray *p1 = @[@"B",@"A",@"S",@"I",@"C"];
    NSArray *p2 = nil;
    NSArray *p3 = @[@"I",@"T",@"S"];
    
    STAssertEqualObjects([ABParser arrayOfCharactersFromWord:t1], p1, @"One word failed");
    STAssertEqualObjects([ABParser arrayOfCharactersFromWord:t2], p2, @"Multi word failed");
    STAssertEqualObjects([ABParser arrayOfCharactersFromWord:t3], p3, @"Did not remove punc");
    
}

- (void)testLoadingMenu {
    
#if 0
    
    // Test menu 4
    MainMenu *menu = [[MainMenu alloc] init];
    
    NSArray *loadedContent = [NSArray arrayFromArray:menu.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    
    // Tester
    MainMenuItemImage *menuItem = [[MainMenuItemImage alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", 0]]];
    [menuItem setUserInteractionEnabled:YES];
    [menuItem setFrame:CGRectMake(30, 293, 180, 180)];
    [menuItem setTag:31];
    // add gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menuItem action:@selector(tapMenuItem:)];
    [tap setNumberOfTapsRequired:1];
    [menuItem addGestureRecognizer:tap];
    
    STAssertEqualObjects(loadedContent[0], menuItem, @"Menu Items not loaded correctly");
    
#endif
    
}

@end




















