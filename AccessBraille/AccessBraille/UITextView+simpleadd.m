//
//  UITextField+simpleadd.m
//  AccessBraille
//
//  Created by Michael Timbrook on 6/24/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "UITextView+simpleadd.h"
#import "ABParser.h"

@implementation UITextView (simpleadd)

- (void)replaceLastWordWithString:(NSString *)string
{
    NSArray *words = [ABParser arrayOfCharactersFromWord:self.text];
    NSString *lastWord = [words lastObject];
    NSString *newString = [self.text substringWithRange:NSMakeRange(0, self.text.length - lastWord.length)];
    self.text = [newString stringByAppendingString:string];
}

@end
