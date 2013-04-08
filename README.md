# DRAFT
Not all feature are implemented

# Access Braille
* * *
Access Braille is a braille accessibiliy framework for iPad that provides an interface to type in braille ontop of your application. The main focus on the project is to provide a new way of typing on your device that is much faster then typing with the default iOS keyboard with accessiblity features on. Making devices easier to use for the visualy impared and blind.

Access Braille is also a learning tool for young childing who have not yet learned how to read braille. It's designed around simple word based games and text adventures that require user to type with the Access Braille keyboard framework. The typing games help teach braille grad 1, with grad 2 and 8 dot math in the future.

## How to Get Started
Simply add the keyboard to your ```UIViewController``` and add the necessary protocal methods to start reciving typing events from the ABKeyboard. And example of reciving the last character typed just add the ```characterTyped:withInfo:```
```objective-c
// In your viewDidLoad method
ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
[keyboard setAutoType:NO]; // You'll add the text where you want.
ter
// Somewhere in your implementation
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    // Your code goes here
    [keyboard addCharactorToActiveInput:character];
}
```
If you choose to handle word processing yourself set the autoType property to ```NO```, if set to ```YES```, the keyboard will automaticly add the charactors to the active input. If nothing is active, the keyboard will not activate.
