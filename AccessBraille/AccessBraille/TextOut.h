//
//  TextOut.h
//  AccessBraille
//
//  Created by Michael on 1/28/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextOut : UIView

-(void)appendToText:(NSString *)string;
-(NSString *)getCurrentText;
-(NSString *)parseLastWordfromString:(NSString *)string;
-(void)clearText;
-(void)typingDidStart;
-(void)typingDidEnd;

@property(nonatomic, readwrite) NSString *buf;
@property(nonatomic, readwrite) NSDate *end;

@end
