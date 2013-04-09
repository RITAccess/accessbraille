# Access Braille
* * *
Access Braille is a braille accessibiliy framework for iPad that provides an interface to type in braille ontop of your application. The main focus on the project is to provide a new way of typing on your device that is much faster then typing with the default iOS keyboard with accessiblity features on. Making devices easier to use for the visualy impared and blind.

Access Braille is also a learning tool for young childing who have not yet learned how to read braille. It's designed around simple word based games and text adventures that require user to type with the Access Braille keyboard framework. The typing games help teach braille grad 1, with grad 2 and 8 dot math in the future.

## How to Get Started
Using the keyboard in your own apps simply create an ABKeyboard in your ```UIViewController``` and add the necessary protocol methods to start reciving typing events from the ABKeyboard. Here's an example of reciving the last character typed:
```objective-c
// In your viewDidLoad method
ABKeyboard *keyboard = [[ABKeyboard alloc] initWithDelegate:self];
// Somewhere in your implementation
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info {
    // Your code goes here
    NSLog(@"You just typed %@", character);
}
```

