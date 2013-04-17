# Access Braille
* * *
Access Braille is a braille accessibiliy framework for iPad that provides an interface to type in braille ontop of your application. The main focus on the project is to provide a new way of typing on your device that is much faster then typing with the default iOS keyboard with accessiblity features on. Making devices easier to use for the visualy impared and blind.

Access Braille is also a learning tool for young childing who have not yet learned how to read braille. It's designed around simple word based games and text adventures that require user to type with the Access Braille keyboard framework. The typing games help teach braille grad 1, with grad 2 and 8 dot math in the future.

## How to Get Started
Using the keyboard in your own apps simply create an ABKeyboard in your ```UIViewController``` and add the necessary protocol methods to start reciving typing events from the ABKeyboard. Here's an example of reciving the last character typed:
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

### The API
<table>

  <tr><th colspan="2" style="text-align:center;">ABKeyboard</th></tr>
  
  <tr>
    <td><tt>-initWithDelegate:</tt></td>
    <td>Creates a keyboard interface to receive input.</td>
  </tr>
  <tr>
    <td><tt>@property BOOL enabled</tt></td>
    <td>Sets the state for the keyboard. <tt>YES</tt> for enabled.</td>
  </tr>

  <tr><th colspan="2" style="text-align:center;">@protocol ABKeyboard</th></tr>
  <tr>
    <td><tt>characterTyped:withInfo:</tt></td>
    <td>Receives the last character inputted from the keyboard along with infomation about the state of the keyboard and that character.</td>
  </tr>
  <tr>
    <td><tt>wordTyped:withInfo:</tt></td>
    <td>Receives the last word from the keyboard along with infomation about the state of the keyboard and that word.</td>
  </tr>
  <tr><th colspan="2" style="text-align:center;">ABParser</th></tr>

  <tr>
    <td><tt>+arrayOfWordsFromSentence:</tt></td>
    <td>Returns an <tt>NSArray</tt> of the words in order parsed from the sentence. Some punctuation excluded <tt>[.,:;]</tt></td>
  </tr>
  <tr>
    <td><tt>+arrayOfCharactersFromWord:</tt></td>
    <td>Returns an <tt>NSArray</tt> of the characters in order parsed from a word. Punctuation excluded, all uppercase.</td>
  </tr>
</table>

[Visit The Webpage](http://7imbrook.github.io/accessbraille/)
