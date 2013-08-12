//
//  KeyboardResponder.h
//  AccessBraille
//
//  Created by Michael Timbrook on 8/8/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardResponder <NSObject>

- (void)newCharacterFromInterpreter:(NSString *)string;
- (void)backspaceRecieved;
- (void)spaceRecieved;
- (void)enterRecieved;

@end
