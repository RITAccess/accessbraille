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
    NSMutableDictionary *CPPPoints;
    
}

- (id)init {
    if (self = [super init]) {
        CPPPoints = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"grade1lookup.plist"];
        grad1LookUp = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    }
    return self;
}

- (void)addCalibrationPoint:(CalibrationPoint *)cp {
    [CPPPoints setObject:cp forKey:[cp getCurrentID]];
}

- (void)setUpCalibration {
    NSMutableArray *deltas = [self findDeltas];
    
    float minDelta = [deltas[0] floatValue];
    int minIndex = 0;
    for (int i = 1; i <= 4; i++) {
        if ([deltas[i] floatValue] < minDelta) {
            minDelta = [deltas[i] floatValue];
            minIndex = i;
        }
    }
    
    for (int n = 1; n <= 6; n++){
        NSNumber *i = [NSNumber numberWithInt:n];
        CalibrationPoint *tmp = [CPPPoints objectForKey:i];
        [tmp setRadius:[NSNumber numberWithFloat:( minDelta / 2.0 )]];
    }

    
}

- (NSMutableArray *)findDeltas{
    NSMutableArray *deltas = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 5; i++) {
        CalibrationPoint *tmp1 = [CPPPoints objectForKey:[NSNumber numberWithInt:i]];
        CalibrationPoint *tmp2 = [CPPPoints objectForKey:[NSNumber numberWithInt:i + 1]];
        NSNumber *delta = [NSNumber numberWithFloat:(
            sqrtf(powf(tmp1.point.x - tmp2.point.x, 2) - powf(tmp1.point.y - tmp2.point.y, 2))
        )];
        [deltas addObject:delta];
    }
    return deltas;
}

- (NSString *)getChar{
    NSString *brailleCode = @"";
    for (int i = 1; i <= 6; i++){
        NSString *index = [[NSNumber numberWithInt:i] stringValue];
        if ([CPPPoints valueForKey:index]){
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
