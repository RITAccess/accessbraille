//
//  NSString+helpers.m
//  AccessBraille
//
//  Created by Michael Timbrook on 5/28/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "NSString+helpers.h"

@implementation NSString (helpers)

- (NSString *)removeLastCharacter {
    return [self substringWithRange:NSMakeRange(0, self.length - 1)];
}

@end
