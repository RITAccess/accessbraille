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

- (void)testABReaderGrade1 {
    
    ABBrailleReader *reader = [[ABBrailleReader alloc] initWithAudioTarget:nil selector:nil];

    // Test Grade 1
    [reader setGrade:ABGradeOne];
    
    STAssertEqualObjects(@"a", [reader processString:@"100000"], @"failed");
    STAssertEqualObjects(@"b", [reader processString:@"110000"], @"failed");
    STAssertEqualObjects(@"c", [reader processString:@"100100"], @"failed");
    STAssertEqualObjects(@"l", [reader processString:@"111000"], @"failed");
    STAssertEqualObjects(@"k", [reader processString:@"101000"], @"failed");
    STAssertEqualObjects(@"o", [reader processString:@"101010"], @"failed");
    STAssertEqualObjects(@"w", [reader processString:@"010111"], @"failed");
    STAssertEqualObjects(@"m", [reader processString:@"101100"], @"failed");
    STAssertEqualObjects(@"abclkowm", reader.wordTyping, @"did not store word correctly");
    STAssertEqualObjects(@"", [reader processString:ABSpaceCharacter], @"Did not return space");
    STAssertEqualObjects(@"", reader.wordTyping, @"did not store word correctly");
    
    // Attempt grade two lookup
    STAssertFalseNoThrow([@"and" isEqualToString:[reader processString:@"111101"]], @"and returned");
    
    reader = nil;
}

- (void)testABBrailleReaderGrade2 {
    
    ABBrailleReader *reader = [[ABBrailleReader alloc] initWithAudioTarget:nil selector:nil];
    
    // Test grade two
    [reader setGrade:ABGradeTwo];
    
    // test none grade two lookups
    STAssertEqualObjects(@"a", [reader processString:@"100000"], @"failed");
    STAssertEqualObjects(@"b", [reader processString:@"110000"], @"failed");
    STAssertEqualObjects(@"c", [reader processString:@"100100"], @"failed");
    STAssertEqualObjects(@"l", [reader processString:@"111000"], @"failed");
    STAssertEqualObjects(@"k", [reader processString:@"101000"], @"failed");
    STAssertEqualObjects(@"o", [reader processString:@"101010"], @"failed");
    STAssertEqualObjects(@"w", [reader processString:@"010111"], @"failed");
    STAssertEqualObjects(@"m", [reader processString:@"101100"], @"failed");
    STAssertEqualObjects(@"abclkowm", reader.wordTyping, @"did not store word correctly");
    STAssertEqualObjects(@"", [reader processString:ABSpaceCharacter], @"Did not return space");
    STAssertEqualObjects(@"", reader.wordTyping, @"did not store word correctly");
    
    // Grade two lookups no options
    STAssertEqualObjects(@"and", [reader processString:@"111101"], @"failed");
    STAssertEqualObjects(@"for", [reader processString:@"111111"], @"failed");
    STAssertEqualObjects(@"with", [reader processString:@"011111"], @"failed");
    [reader processString:ABSpaceCharacter];
    STAssertEqualObjects(@"", reader.wordTyping, @"work not cleared");
    
    // Grade two prefix tests
    // Test level two lookups
    // Type phone
    [reader processString:@"111100"];
    [reader processString:@"110010"];
    [reader processString:@"000010"];
    [reader processString:@"101010"];
    STAssertEqualObjects(reader.wordTyping, @"phone", @"failed to type phone");
    [reader processString:ABSpaceCharacter];
    
    // Test numbers
    [reader processString:@"001111"];
    [reader processString:@"100000"];
    [reader processString:@"010110"];
    [reader processString:@"100000"];
    [reader processString:@"100010"];
    STAssertEqualObjects(reader.wordTyping, @"1015", @"failed to handle numbers");
    [reader processString:ABSpaceCharacter];
    
    // test level three lookup
    // type manyhadspirit
    [reader processString:@"000111"];
    [reader processString:@"101100"];
    [reader processString:@"000111"];
    [reader processString:@"110010"];
    [reader processString:@"000111"];
    [reader processString:@"011100"];
    STAssertEqualObjects(reader.wordTyping, @"manyhadspirit", @"failed to type manyhadspirt");
    [reader processString:ABSpaceCharacter];
    
    // level four
    // count
    [reader processString:@"100100"];
    [reader processString:@"000101"];
    [reader processString:@"011110"];
    STAssertEqualObjects(reader.wordTyping, @"count", @"failed to type count");
    [reader processString:ABSpaceCharacter];
    
    
    
    reader = nil;
}

@end
