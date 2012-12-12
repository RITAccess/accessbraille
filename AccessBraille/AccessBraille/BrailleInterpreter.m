//
//  BrailleInterpreter.m
//  AccessBraille
//
//  Created by Michael on 12/12/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "BrailleInterpreter.h"
#import "CalibrationPoint.h"

@implementation BrailleInterpreter{
    
    NSDictionary *grad1LookUp;
    NSMutableDictionary *touchPoints;
    
}

- (id)init {
    if (self = [super init]) {
        touchPoints = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"grade1lookup.plist"];
        grad1LookUp = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    }
    return self;
}

- (void)addCalibrationPoint:(CalibrationPoint *)cp withCGPoint:(CGPoint)point withState:(NSNumber *)state {
    [touchPoints setObject:@[cp, [NSValue valueWithCGPoint:point], state] forKey:[[cp getCurrentID] stringValue]];
}

- (NSString *)getChar{
    NSString *brailleCode = @"";
    for (int i = 1; i <= 6; i++){
        NSString *index = [[NSNumber numberWithInt:i] stringValue];
        if ([touchPoints valueForKey:index]){
            brailleCode = [brailleCode stringByAppendingString:@"1"];
        } else {
            brailleCode = [brailleCode stringByAppendingString:@"0"];
        }
    }
    
    NSString *letter = [grad1LookUp valueForKey:brailleCode];
    NSString *returnLetter = [letter length] == 1 ? letter : @"invalid";
    return returnLetter;
}


@end
