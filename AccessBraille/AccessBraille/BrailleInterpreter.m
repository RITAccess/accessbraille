//
//  BrailleInterpreter.m
//  AccessBraille
//
//  Created by Michael on 12/12/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "BrailleInterpreter.h"
#import "CalibrationPoint.h"
#import "Drawing.h"
#import "BrailleTyperController.h"

@implementation BrailleInterpreter{
    
    NSDictionary *grad1LookUp;
    NSMutableDictionary *CPPPoints;
    UIViewController *mainView;
    
}

@synthesize delta = _delta;

- (id)initWithViewController:(UIViewController *)view {
    if (self = [super init]) {
        CPPPoints = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"grade1lookup.plist"];
        grad1LookUp = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
        mainView = view;
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
    
    for (NSNumber *key in CPPPoints){
        CalibrationPoint *cp = [CPPPoints objectForKey:key];
        NSNumber *rad = [NSNumber numberWithFloat:( minDelta / 2.0 )];
        NSLog(@"%@", rad);
        [cp setRadius:[rad floatValue] < [@25 floatValue] ? @25 : rad];
        Drawing *touch = [[Drawing alloc] initWithPoint:[cp point] radius:[[cp getRadius] intValue]];
        [mainView.view addSubview:touch];
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
    _delta = deltas;
    return deltas;
}

- (NSString *)getChar:(NSMutableDictionary *)touchPoints{
    NSString *lookupKey = @"";
    for (int s = 1; s <= 6; s++){
        NSNumber *key = [NSNumber numberWithInt:s];
        if ([touchPoints objectForKey:key]) {
            lookupKey = [lookupKey stringByAppendingString:@"1"];
        } else {
            lookupKey = [lookupKey stringByAppendingString:@"0"];
        }
    }
    NSString *letter = [grad1LookUp objectForKey:lookupKey] ? [grad1LookUp objectForKey:lookupKey] : @"not";
    return letter;
}

- (float)getAverageYValue {
    float count = 0;
    for (NSNumber *key in CPPPoints){
        CalibrationPoint *cp = [CPPPoints objectForKey:key];
        count += cp.point.y;
    }
    return count / 6;
}

- (float)getMaxYDelta{
    float max = 0;
    float min = INFINITY;
    for (NSNumber *key in CPPPoints) {
        CalibrationPoint *tmp = [CPPPoints objectForKey:key];
        if (tmp.point.y > max) {
            max = tmp.point.y;
        }
        if (tmp.point.y < min) {
            min = tmp.point.y;
        }
    }
    return max - min;
}

- (NSString *)description{
    NSString *builder = @"BrailleInterpreter Dump\n";
    for (NSNumber *key in CPPPoints){
        CalibrationPoint *tmp = [CPPPoints objectForKey:key];
        builder = [builder stringByAppendingFormat:@"%@\n", [tmp description]];
    }
    return builder;
}

@end










