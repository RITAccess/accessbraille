//
//  TextOut.h
//  AccessBraille
//
//  Created by Michael on 1/28/13.
//  Edited by Piper on 3/6/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrailleTyperOutputView : UIView

-(void)appendToText:(NSString *)string;
-(NSString *)getCurrentText;
-(NSString *)parseLastWordfromString:(NSString *)string;
-(void)clearText;
-(void)typingDidStart;
-(void)typingDidEnd;
-(void)removeCharacter; // Backspace method

@property(nonatomic, readwrite) NSString *buf;
@property(nonatomic, readwrite) NSDate *end;

@end
