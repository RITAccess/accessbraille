//
//  ABBrailleReader.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABBrailleReader.h"
#import "ABKeyboard.h"

@implementation ABBrailleReader {
    
    NSDictionary *grad2Lookup;
    id target;
    SEL selector;
    
}

- (id)initWithAudioTarget:(id)tar selector:(SEL)sel {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"grade2lookup.plist"];
        grad2Lookup = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
        _wordTyping = @"";
        
        // Default grade
        _grade = ABGradeTwo;
        
        // Audio
        target = tar;
        selector = sel;
    
    }
    return self;
}

/**
 * Takes an array of NSNumbers corresponding to finger placement on screen (left
 * to right) and returns the look up string for the braille dictionary
 */
+ (NSString *)brailleStringFromTouchIDs:(NSArray *)touchIDs {
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:6];
    [str setString:@"000000"];
    for (NSNumber *i in touchIDs) {
        if (i.intValue == 0) {
            [str replaceCharactersInRange:NSMakeRange(2, 1) withString:@"1"];
        } else if (i.intValue == 2) {
            [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@"1"];
        } else {
            [str replaceCharactersInRange:NSMakeRange(i.intValue, 1) withString:@"1"];
        }
    }
    return str;
}

/**
 * Receives character from touchLayer in form of braille string
 */
- (void)characterReceived:(NSString *)brailleString
{
    [self sendCharacter:[self proccessString:brailleString]];
}

- (NSString *)proccessString:(NSString *)brailleString
{
    // if space proccess last typed word if grade two
    if ([brailleString isEqualToString:ABSpaceCharacter]) {
        NSString *word = @"";
        switch (_grade) {
            case ABGradeOne: {
                word = ABSpaceCharacter;
            }
            case ABGradeTwo: {
                
                if ([brailleString isEqualToString:@""]) {
                    
                } else {
                    // Not special case
                    word = ABSpaceCharacter;
                }
                
                
            }
        }
        _wordTyping = @"";
        return word;
    }
    // Backspace
    if ([brailleString isEqualToString:ABBackspace]) {
        return ABBackspace;
    }
    
    // Is typed character
    if (_grade == ABGradeOne && [grad2Lookup[brailleString] length] > 1) {
        return nil;
    } else {
        _wordTyping = [_wordTyping stringByAppendingString:grad2Lookup[brailleString]];
        return grad2Lookup[brailleString];
    }
}

- (void)sendCharacter:(NSString *)string
{
    if ([string isEqualToString:ABSpaceCharacter]) {
        [_delegate characterTyped:@" " withInfo:@{ABGestureInfoStatus : @(YES),
                                                         ABSpaceTyped : @(YES),
                                                  ABBackspaceReceived : @(NO)}];
    } else if ([string isEqualToString:ABBackspace]) {
        [_delegate characterTyped:@"" withInfo:@{ABGestureInfoStatus : @(YES),
                                                        ABSpaceTyped : @(NO),
                                                 ABBackspaceReceived : @(YES)}];
        [target performSelector:selector withObject:ABBackspaceSound];
    } else {
        [_delegate characterTyped:string withInfo:@{ABGestureInfoStatus : @(YES),
                                                           ABSpaceTyped : @(NO),
                                                    ABBackspaceReceived : @(NO)}];
    }
}

- (void)sendWord:(NSString *)string
{
    NSLog(@"Word: %@", string);
}

@end
