//
//  ABBrailleOutput.m
//  AccessBraille
//
//  Created by Michael Timbrook on 7/2/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABBrailleOutput.h"

@implementation ABBrailleOutput {
    NSMutableDictionary *reverseLookup;
    float width;
    UIImage *block;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSDictionary *grade2Lookup = [[NSDictionary alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"grade2lookup.plist"]];
        NSArray *keys = [grade2Lookup allKeys];
        NSArray *values = [grade2Lookup allValues];
        reverseLookup = [NSMutableDictionary dictionary];
        for (int i = 0; i < keys.count; i++) {
            if ([(NSString *)values[i] length] > 1)
                continue;
            reverseLookup[values[i]] = keys[i];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    width = _text.length * (30.0 * 2.0/3.0) + (5 * (_text.length - 1));
    block = [self imageWithHeight:30.0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
    [self setNeedsDisplay];
}

- (UIImage *)imageWithHeight:(float)height
{
    
    CGRect dot1 = CGRectMake(1, 1, 8, 8);
    CGRect dot2 = CGRectMake(1, 11, 8, 8);
    CGRect dot3 = CGRectMake(1, 21, 8, 8);
    CGRect dot4 = CGRectMake(11, 1, 8, 8);
    CGRect dot5 = CGRectMake(11, 11, 8, 8);
    CGRect dot6 = CGRectMake(11, 21, 8, 8);
    CGRect dots[6] = {dot1, dot2, dot3, dot4, dot5, dot6};
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    [[UIColor blackColor] setFill];
    
    for (int c = 0; c < _text.length; c++) {
        NSString *ch = [_text substringWithRange:NSMakeRange(c, 1)];
        if ([ch isEqualToString:@" "]) {
            for (int i = 0; i < 6; i++) {
                dots[i].origin.x += ((height * 2.0/3.0) + 5);
            }
            continue;
        }
        NSString *braille = reverseLookup[ch.lowercaseString];
        
        // Draw loop
        for (int d = 0; d < 6; d++) {
            unichar chd = [braille characterAtIndex:d];
            if (chd == '1') {
                CGContextFillEllipseInRect(context, dots[d]);
            }
        }
        
        // Shift dots
        for (int i = 0; i < 6; i++) {
            dots[i].origin.x += ((height * 2.0/3.0) + 5);
        }
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawRect:(CGRect)rect
{
    [block drawAsPatternInRect:rect];
}

@end
