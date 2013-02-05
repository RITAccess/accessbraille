//
//  TextOut.m
//  AccessBraille
//
//  Created by Michael on 1/28/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "TextOut.h"

@implementation TextOut {
    UILabel *textOut;
    NSMutableArray *wordList;
    bool loaded;
    
    UILongPressGestureRecognizer *clearText;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        NSLog(@"Init");
        loaded = NO;
        _buf = @"";
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    // Text Output
    NSLog(@"drawRect");
    textOut = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width, 50)];
    textOut.backgroundColor = [UIColor clearColor];
    wordList = [[NSMutableArray alloc] init];
    [self addSubview:textOut];
    [self setWordsToOutput:_buf];
    
    // Clear Text
    clearText = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clearText)];
    [clearText setNumberOfTouchesRequired:3];
    [self addGestureRecognizer:clearText];
    
    
    // Style
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Colors
    UIColor *fillBox = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    UIColor *fillBoxShadow = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    
    CGRect box = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
    // Shadow
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1.0, fillBoxShadow.CGColor);
    CGContextAddRect(context, box);
    CGContextFillPath(context);
    // Box
    CGContextSetFillColorWithColor(context, fillBox.CGColor);
    CGContextAddRect(context, box);
    
    CGContextFillPath(context);
    
}

- (NSMutableArray *)stringToArray:(NSString *)str {
    if ([str isEqualToString:@""]){
        return false;
    }
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSString *buildWord = @"";
    for(int index = 0; index<=[str length]-1; index++){
        if ([str characterAtIndex:index] == 32){
            [chars addObject:buildWord];
            buildWord = @"";
        } else {
            buildWord = [buildWord stringByAppendingString:[NSString stringWithFormat:@"%c", [str characterAtIndex:index]]];
        }
    }
    [chars addObject:buildWord];
    buildWord = @"";
    return chars;
}


- (void)setWordsToOutput:(NSString *)buf {
    [wordList removeAllObjects];
    if ([self stringToArray:buf]) {
        [wordList addObjectsFromArray:[self stringToArray:buf]];
    }
    [self rewrite];
}

- (void)appendToText:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        NSLog(@"Completed Word");
        NSString *tmp = [textOut.text stringByAppendingString:string];
        [textOut setText:tmp];
        [wordList removeAllObjects];
        [wordList addObjectsFromArray:[self stringToArray:tmp]];
    } else {
        NSLog(@"Appending %@ to %@", string, textOut.text);
        NSString *tmp = [textOut.text stringByAppendingString:string];
        [textOut setText:tmp];
    }
    NSLog(@"%@", wordList);
}

-(NSString *)parseLastWordfromString:(NSString *)string {
    /**
        Depricated
     */
    
    const char *charArray = [string UTF8String];
    int charLength = (int)[string length];
    NSString *word = @"";
    int offset = charArray[charLength - 1] == 32 ? 2 : 1;
    for (int i = charLength - offset; i >= 0; i--) {
        if (charArray[i] == 32){
            break;
        }
        word = [NSString stringWithFormat:@"%c%@",charArray[i],word];
    }
    const char *trim = [word UTF8String];
    NSString *returned = @"";
    for (int i = 0; i < [word length]; i++){
        returned = [NSString stringWithFormat:@"%@%c",returned, trim[i]];
    }
    return returned;
}

-(void)typingDidStart {

}

-(void)typingDidEnd {
    NSLog(@"Typing Ended");
    [wordList removeAllObjects];
    [wordList addObjectsFromArray:[self stringToArray:textOut.text]];
    [self rewrite];
    NSLog(@"%@", wordList);
}

- (void)rewrite {
    textOut.text = @" ";
    for(NSString *word in wordList){
        if ([word isEqualToString:@""]) {
            continue;
        }
        textOut.text = [textOut.text stringByAppendingString:word];
        textOut.text = [textOut.text stringByAppendingString:@" "];
    }
}

-(void)updateOutputWithFormat {
    
}

- (NSString *)getCurrentText{
    return textOut.text;
}

-(void)clearText{
    NSLog(@"Cleared Text");
    [textOut setText:@""];
    [wordList removeAllObjects];
    [self rewrite];
}

@end
