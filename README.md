# Access Braille
 [![Build Status](https://travis-ci.org/RITAccess/accessbraille.png?branch=master)](https://travis-ci.org/RITAccess/accessbraille)
###### Note: CI servers without iOS 7 SDK may cause build tests to fail.

* * *
Access Braille is a braille accessibility framework for iPad that creates an interface to type in braille on top of an application. The project focuses on providing a more efficient and accessible method of typing on an iOS device than the current defaults provided by Apple. We hope to inevitably facilitate device use for the visualy impaired and blind.

Access Braille is also a learning tool for young children who have not learned the braille system. It's designed around simple word-based games that require users to type in grade 1 braille with the Access Braille keyboard framework. We plan on implementing grade 2 and 8 dot math in the future.

## Current Contributors
Led by [Stephanie Ludi](https://github.com/retrogamer80s), this project's current team consists of: 
* [Michael Timbrook](https://github.com/7imbrook) SE Undergraduate 
* [Piper Chester](https://github.com/piperchester) SE Undergraduate 

## How to Get Started
The simplest way to get started is by just handing a keyboard instance a UITextView and it will automaticly start outputing to it, and act as it's first responder!

```objective-c
// In your header
#import <ABKeyboard/ABKeyboard.h>
@interface YourClass : NSObject <ABKeyboard> // Follow the ABKeyboard protocol
// In your viewDidLoad method
ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];

UITextView *myOutput = [UITextView new];
[keyboard setOutput:myOutput];

```

To recieve calls from the keyboard during events, see the `KeyboardResponder` protocol.

[View the full API](https://github.com/RITAccess/accessbraille/wiki/AccessBraille-API-Documentation)
