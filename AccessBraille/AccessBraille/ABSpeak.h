//
//  ABSpeak.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Emma/emma.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <NeatSpeechDemo/FliteController+NeatSpeech.h>

@interface ABSpeak : NSObject {
    
    FliteController *fliteController;
    Emma *emma;

}


@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Emma *emma;

- (void)speakString:(NSString *)string;

@end
