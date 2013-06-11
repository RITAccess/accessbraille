# Access Braille
* * *
Access Braille is a braille accessibility framework for iPad that creates an interface to type in braille on top of an application. The project focuses on providing a more efficient and accessible method of typing on an iOS device than the current defaults provided by Apple. We hope to inevitably facilitate device use for the visualy impaired and blind.

Access Braille is also a learning tool for young children who have not learned the braille system. It's designed around simple word-based games that require users to type in grade 1 braille with the Access Braille keyboard framework. We plan on implementing grade 2 and 8 dot math in the future.

## Current Contributors
Led by [Stephanie Ludi](https://github.com/retrogamer80s), this project's current team consists of: 
* [Michael Timbrook](https://github.com/7imbrook) SE Undergraduate 
* [Piper Chester](https://github.com/piperchester) SE Undergraduate 

## How to Get Started
Using the keyboard in your own apps simply create an ABKeyboard in your ```UIViewController``` and add the necessary protocol methods to start reciving typing events from the ABKeyboard. Here's an example of receiving the last character typed:
```objective-c
// In your header
@interface YourClass : NSObject <ABKeyboard> // Follow the ABKeyboard protocol
// In your viewDidLoad method
ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
// Somewhere in your implementation
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    // Your code goes here
    NSLog(@"You just typed %@", character);
}
```
[View the full API](https://github.com/RITAccess/accessbraille/wiki/AccessBraille-API-Documentation)
