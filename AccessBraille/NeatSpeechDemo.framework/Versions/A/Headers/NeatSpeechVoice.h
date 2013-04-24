//
//  NeatSpeechVoice.h
//  NeatSpeech
//
//  Created by Halle on 10/12/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NeatSpeechEngine;

/**\cond HIDDEN_SYMBOLS*/   

/**\endcond */   

@interface NeatSpeechVoice : NSObject {
    /**\cond HIDDEN_SYMBOLS*/ 
    NSString *voiceNamePrefix;
    
    NSString *dur_pdf;
    NSString *gv_lf0_pdf;
    NSString *gv_mgc_pdf;
    NSString *gv_switch_inf;
    NSString *lf0_pdf;
    NSString *lf0_win1;
    NSString *lf0_win2;
    NSString *lf0_win3;
    NSString *lpf_pdf;
    NSString *lpf_win1;
    NSString *mgc_pdf;
    NSString *mgc_win1;
    NSString *mgc_win2;
    NSString *mgc_win3;
    NSString *tree_dur_inf;
    NSString *tree_gv_lf0_inf;
    NSString *tree_gv_mgc_inf;
    NSString *tree_lf0_inf;
    NSString *tree_lpf_inf;
    NSString *tree_mgc_inf;
    
    NSString *sampleRate;
    NSString *pArgument;
    NSString *transformation;
    NSString *zArgument;
    
    float pitchval;
    float speedval;
    float transval;
  
    NSArray *additionalOptions;
    
    NeatSpeechEngine *engine;
    /**\endcond */  
}
/**\cond HIDDEN_SYMBOLS*/   
@property (nonatomic, copy) NSString *voiceNamePrefix;

@property (nonatomic, copy) NSString *dur_pdf;
@property (nonatomic, copy) NSString *gv_lf0_pdf;
@property (nonatomic, copy) NSString *gv_mgc_pdf;
@property (nonatomic, copy) NSString *gv_switch_inf;
@property (nonatomic, copy) NSString *lf0_pdf;
@property (nonatomic, copy) NSString *lf0_win1;
@property (nonatomic, copy) NSString *lf0_win2;
@property (nonatomic, copy) NSString *lf0_win3;
@property (nonatomic, copy) NSString *lpf_pdf;
@property (nonatomic, copy) NSString *lpf_win1;
@property (nonatomic, copy) NSString *mgc_pdf;
@property (nonatomic, copy) NSString *mgc_win1;
@property (nonatomic, copy) NSString *mgc_win2;
@property (nonatomic, copy) NSString *mgc_win3;
@property (nonatomic, copy) NSString *tree_dur_inf;
@property (nonatomic, copy) NSString *tree_gv_lf0_inf;
@property (nonatomic, copy) NSString *tree_gv_mgc_inf;
@property (nonatomic, copy) NSString *tree_lf0_inf;
@property (nonatomic, copy) NSString *tree_lpf_inf;
@property (nonatomic, copy) NSString *tree_mgc_inf;
@property (nonatomic, copy) NSString *sampleRate;
@property (nonatomic, copy) NSString *pArgument;
@property (nonatomic, copy) NSString *transformation;
@property (nonatomic, copy) NSString *zArgument;

@property (nonatomic, retain) NSArray *additionalOptions;

@property (nonatomic, assign) NeatSpeechEngine *engine;

@property (nonatomic, assign) float pitchval;
@property (nonatomic, assign) float speedval;
@property (nonatomic, assign) float transval;
/**\endcond */   
/**The designated initializer for any NeatSpeech voice (such as Emma, William, Beatrice or Elliott). To use the default settings for the voice, set pitch, speed and transform to 0.0. To change the pitch (highness or lowness of the voice register) speed (duration of speech) or transformation, use a scale of -1.0 <--> 1.0. For instance, setting pitch to 0.3 will make a higher voice, setting it to -0.3 will make a lower voice. Small values have a big impact. In order to use FliteController+NeatSpeech's "sayWithNeatSpeech:withVoice:" method it is necessary to have an initialized voice that you can pass to withVoice:. An example of initializing a voice to pass to this method for the Emma voice would be as follows: Emma *emma = [[Emma alloc]initWithPitch:0.0 speed:0.0 transform:0.0]; after which you could sent the message [self.fliteController sayWithNeatSpeech:@"My statement" withVoice:emma];*/
- (id)initWithPitch:(float)pitch speed:(float)speed transform:(float)transform;
@end
