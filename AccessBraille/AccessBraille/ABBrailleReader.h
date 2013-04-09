//
//  ABBrailleReader.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTouchLayer.h"
#import "ABKeyboard.h"

@interface ABBrailleReader : NSObject <ABTouchReciever>

+ (NSString *)brailleStringFromTouchIDs:(NSArray *)touchIDs;

@property (nonatomic) id<ABKeyboard> delegate;

@end
