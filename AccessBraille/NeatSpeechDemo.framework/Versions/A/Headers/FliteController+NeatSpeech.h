//
//  FliteController+NeatSpeech.h
//  NeatSpeech
//
//  Created by Halle on 8/17/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import <OpenEars/FliteController.h>
#import "NeatSpeechVoice.h"

/**
 @category  FliteController(NeatSpeech)
 @brief  A plugin which adds the ability to do higher-quality multithreaded speech to FliteController.
 
 ## Usage examples
 > Preparing to use the class:
 @htmlinclude FliteController+NeatSpeech_Preconditions.txt
 > What to add to your implementation:
 @htmlinclude FliteController+NeatSpeech_Implementation.txt
 @warning There can only be one FliteController+NeatSpeech instance in your app.
 */

/**\cond HIDDEN_SYMBOLS*/   

/**\endcond */   

@interface FliteController (NeatSpeech) {
    
}
/**Say a word, phrase or paragraph, using a voice which you have already instantiated. Speech will be processed in the background and streamed back into the output, so feel free to send as much speech at once as you want. You can put in phrase separators (this can improve performance for very long sentences) by inserting the text token #### and you can insert one pause at an arbitrary interval by inserting the text token ##PAUSE## */
- (void) sayWithNeatSpeech:(NSString *)statement withVoice:(NeatSpeechVoice *)voiceToUse;
/**This will stop speech instantly.*/
- (void) stopSpeaking;
/**Stop all speech once the current item in the queue is complete. Effectively, says "don't continue with the queue after current speech is complete."*/
- (void) stopSpeakingAfterCurrentItemInQueue;

@end
