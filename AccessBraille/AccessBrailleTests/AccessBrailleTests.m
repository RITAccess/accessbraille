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
#import "MainMenuItemImage.h"
#import "NSArray+ObjectSubsets.h"
#import "MainMenu.h"
#import "MainMenuItemImage.h"
#import "ABBrailleOutput.h"

@interface ABKeyboard ()

@property (retain) ABBrailleReader *brailleReader;

@end

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
    
    ABBrailleReader *reader = [ABBrailleReader new];

    // Test Grade 1
    [reader setGrade:ABGradeOne];
    
    STAssertEqualObjects(@"a", [reader characterReceived:@"100000"], @"failed");
    STAssertEqualObjects(@"b", [reader characterReceived:@"110000"], @"failed");
    STAssertEqualObjects(@"c", [reader characterReceived:@"100100"], @"failed");
    STAssertEqualObjects(@"l", [reader characterReceived:@"111000"], @"failed");
    STAssertEqualObjects(@"k", [reader characterReceived:@"101000"], @"failed");
    STAssertEqualObjects(@"o", [reader characterReceived:@"101010"], @"failed");
    STAssertEqualObjects(@"w", [reader characterReceived:@"010111"], @"failed");
    STAssertEqualObjects(@"m", [reader characterReceived:@"101100"], @"failed");
    STAssertEqualObjects(@"abclkowm", reader.wordTyping, @"did not store word correctly");
    STAssertEqualObjects(nil, [reader characterReceived:ABSpaceCharacter], @"Did not return space");
    STAssertEqualObjects(@"", reader.wordTyping, @"did not store word correctly");

    reader = nil;
}

- (void)testGradeTwoLookUpInGradeOne
{
    ABBrailleReader *reader = [ABBrailleReader new];
    [reader setGrade:ABGradeOne];
    // Attempt grade two lookup
    STAssertFalseNoThrow([@"and" isEqualToString:[reader characterReceived:@"111101"]], @"and returned");
    STAssertFalseNoThrow([@"ch" isEqualToString:[reader characterReceived:@"100001"]], @"and returned");
    reader = nil;
}

- (void)testABBrailleReaderGrade2_test1
{
    
    ABBrailleReader *reader = [ABBrailleReader new];
    
    // Test grade two
    [reader setGrade:ABGradeTwo];
    
    // test none grade two lookups
    STAssertEqualObjects(@"a", [reader characterReceived:@"100000"], @"failed");
    STAssertEqualObjects(@"b", [reader characterReceived:@"110000"], @"failed");
    STAssertEqualObjects(@"c", [reader characterReceived:@"100100"], @"failed");
    STAssertEqualObjects(@"l", [reader characterReceived:@"111000"], @"failed");
    STAssertEqualObjects(@"k", [reader characterReceived:@"101000"], @"failed");
    STAssertEqualObjects(@"o", [reader characterReceived:@"101010"], @"failed");
    STAssertEqualObjects(@"w", [reader characterReceived:@"010111"], @"failed");
    STAssertEqualObjects(@"m", [reader characterReceived:@"101100"], @"failed");
    STAssertEqualObjects(@"abclkowm", reader.wordTyping, @"did not store word correctly");
    STAssertEqualObjects(nil, [reader characterReceived:ABSpaceCharacter], @"Did not return space");
    STAssertEqualObjects(@"", reader.wordTyping, @"did not store word correctly");
    
    reader = nil;
}

- (void)testABBrailleReaderGrade2_test2
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // Grade two lookups no options
    STAssertEqualObjects(@"and", [reader characterReceived:@"111101"], @"failed");
    STAssertEqualObjects(@"for", [reader characterReceived:@"111111"], @"failed");
    STAssertEqualObjects(@"with", [reader characterReceived:@"011111"], @"failed");
    [reader characterReceived:ABSpaceCharacter];
    STAssertEqualObjects(@"", reader.wordTyping, @"work not cleared");
    reader = nil;
}

- (void)testABBrailleReaderGrade2_test3
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // Grade two prefix tests
    // Test level two lookups
    // Type phone
    [reader characterReceived:@"111100"];
    [reader characterReceived:@"110010"];
    [reader characterReceived:@"000010"];
    [reader characterReceived:@"101010"];
    STAssertEqualObjects(reader.wordTyping, @"phone", @"failed to type phone");
    [reader characterReceived:ABSpaceCharacter];
    reader = nil;
}
- (void)testABBrailleReaderGrade2_test4
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // Test numbers
    [reader characterReceived:@"001111"];
    [reader characterReceived:@"100000"];
    [reader characterReceived:@"010110"];
    [reader characterReceived:@"100000"];
    [reader characterReceived:@"100010"];
    STAssertEqualObjects(reader.wordTyping, @"1015", @"failed to handle numbers");
    [reader characterReceived:ABSpaceCharacter];
    reader = nil;
}
- (void)testABBrailleReaderGrade2_test5
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // test level three lookup
    // type manyhadspirit
    [reader characterReceived:@"000111"];
    [reader characterReceived:@"101100"];
    [reader characterReceived:@"000111"];
    [reader characterReceived:@"110010"];
    [reader characterReceived:@"000111"];
    [reader characterReceived:@"011100"];
    STAssertEqualObjects(reader.wordTyping, @"manyhadspirit", @"failed to type manyhadspirt");
    [reader characterReceived:ABSpaceCharacter];
    reader = nil;
}
- (void)testABBrailleReaderGrade2_test6
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // level four
    // count
    [reader characterReceived:@"100100"];
    [reader characterReceived:@"000101"];
    [reader characterReceived:@"011110"];
    STAssertEqualObjects(reader.wordTyping, @"count", @"failed to type count");
    [reader characterReceived:ABSpaceCharacter];
    reader = nil;
}

- (void)testABBrailleReaderGrade2_test7
{
    ABBrailleReader *reader = [ABBrailleReader new];
    // Prefix followed by non recongnized post
    [reader characterReceived:@"000010"];
    [reader characterReceived:@"100000"];
    // Check should have typed nothing
    STAssertEqualObjects(reader.wordTyping, @"", @"Char was typed that shouldn't have");
    [reader characterReceived:@"100000"];
    // An A should have been typed
    STAssertEqualObjects(reader.wordTyping, @"a", @"An A should have been typed");
    reader = nil;
}

- (void)testCapsMethod
{
    NSString *string = @"test";
    string = [NSString stringWithFormat:@"%@%@", [[string substringToIndex:1] uppercaseString], [string substringFromIndex:1]];
    STAssertEqualObjects(string, @"Test", @"Did not caps");
}

- (void)testABKeyboardTyping_test1
{
    ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:nil];
    ABBrailleReader *reader = keyboard.brailleReader;
    UITextView *output = [UITextView new];
    [keyboard setOutput:output];
    
    [reader characterReceived:@"101100"];
    [reader characterReceived:@"101111"];
    [reader characterReceived:ABSpaceCharacter];
    [reader characterReceived:@"111100"];
    [reader characterReceived:@"110010"];
    [reader characterReceived:@"000010"];
    [reader characterReceived:@"101010"];
    [reader characterReceived:ABSpaceCharacter];
    
    STAssertEqualObjects(output.text, @"my phone ", @"Did not type to output correctly");
}

- (void)testABKeyboardTyping_test2
{
    ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:nil];
    ABBrailleReader *reader = keyboard.brailleReader;
    UITextView *output = [UITextView new];
    [keyboard setOutput:output];
    
    [reader characterReceived:@"101100"];
    [reader characterReceived:@"101111"];
    [reader characterReceived:ABSpaceCharacter];
    [reader characterReceived:@"111100"];
    [reader characterReceived:@"110010"];
    [reader characterReceived:@"000010"];
    [reader characterReceived:@"101010"];
    [reader characterReceived:ABSpaceCharacter];
    [reader characterReceived:ABBackspace];
    [reader characterReceived:ABBackspace];
    [reader characterReceived:ABBackspace];
    [reader characterReceived:ABBackspace];
    
    STAssertEqualObjects(output.text, @"my ph", @"Did not type to output correctly");
    
}

@end
