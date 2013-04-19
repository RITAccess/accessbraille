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
    
    NSDictionary *grad1Lookup;
    id target;
    SEL selector;
    
}

- (id)initWithAudioTarget:(id)tar selector:(SEL)sel {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"grade1lookup.plist"];
        grad1Lookup = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
        _wordTyping = @"";
        
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
- (void)characterReceived:(NSString *)brailleString {
    // If Space
    if ([brailleString isEqualToString:ABSpaceCharacter]) {
        if (![_wordTyping isEqualToString:@""]) {
            [_delegate characterTyped:@" " withInfo:@{ABGestureInfoStatus : @(YES),
                                                             ABSpaceTyped : @(YES)}];
            [_delegate wordTyped:_wordTyping withInfo:@{ABGestureInfoStatus : @(YES),
                                                               ABSpaceTyped : @(YES),
                                                           ABBackspaceReceived : @(NO)}];
            _wordTyping = @"";
        }
    }
    
    // If Backspace
    
    if ([brailleString isEqualToString:ABBackspace]) {
        [(ABKeyboard *)target performSelector:selector withObject:ABBackspaceSound];
        [_delegate characterTyped:@"" withInfo:@{ABGestureInfoStatus : @(YES),
                                                        ABSpaceTyped : @(NO),
                                                    ABBackspaceReceived : @(YES)}];
        if (_wordTyping.length > 0) {
            _wordTyping = [_wordTyping substringWithRange:NSMakeRange(0, _wordTyping.length - 1)];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(characterTyped:withInfo:)]) {
        NSString *character = grad1Lookup[brailleString];
        if (character.length == 0) {
            return;
        }
        _wordTyping = [_wordTyping stringByAppendingString:character];
        [_delegate characterTyped:character withInfo:@{ABGestureInfoStatus : @(YES),
                                                              ABSpaceTyped : @(NO),
                                                          ABBackspaceReceived : @(NO)}];
    }
    
}

@end
