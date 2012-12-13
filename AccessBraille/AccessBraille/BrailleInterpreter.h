//
//  BrailleInterpreter.h
//  AccessBraille
//
//  Created by Michael on 12/12/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalibrationPoint.h"

@interface BrailleInterpreter : NSObject

- (id)init;
- (void)addCalibrationPoint:(CalibrationPoint *)cp;
- (void)setUpCalibration;
- (NSString *)getChar;

@end
