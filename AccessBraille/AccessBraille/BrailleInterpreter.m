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
    [CPPPoints setObject:cp forKey:[[cp getCurrentID] stringValue]];
}

- (void)setUpCalibration{
    [self findDeltas];
    
}

- (NSMutableDictionary *)findDeltas{
    NSMutableDictionary *deltas = [[NSMutableDictionary alloc] init];
    for (int i = 1; i <= 6; i++) {
        NSNumber *tmpID = [NSNumber numberWithInt:i];
        
        NSLog(@"%@", [[CPPPoints objectForKey:tmpID] stringValue]);
        
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
