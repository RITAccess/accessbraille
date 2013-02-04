//
//  BrailleTyper.h
//  AccessBraille
//
//  Created by Michael Timbrook on 2/4/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BrailleTyper : NSManagedObject

@property (nonatomic, retain) NSString * typedString;

@end
