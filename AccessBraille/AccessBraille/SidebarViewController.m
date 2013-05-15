//
//  SidebarViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/23/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "SidebarViewController.h"
#import "MainMenuItemImage.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    SystemSoundID openNavSound;
    NSDictionary *menuItemsDict;
}

@synthesize menuOpen = _menuOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setBackgroundColor:[UIColor blueColor]];
        // Set image as background
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"slideOutMenu.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        [self setMenuOpen:NO];
        openNavSound = [self createSoundID:@"navClick.aiff"];
    }
    return self;
}

- (void)loadMenuItemsAnimated:(BOOL)animated {
    
    NSLog(@"Test Load Menu Items");
    
    // Size
    #define LEFTMARGIN 5
    #define SIZE 85
    
    // Load menu info
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"menu.plist"];
    menuItemsDict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:menuItemsDict.count];
    int startTag = 0;
    
    for (NSString *link in menuItemsDict) {
        
        MainMenuItemImage *menuItem = [[MainMenuItemImage alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", startTag]]];
        [menuItem setUserInteractionEnabled:YES];
        [menuItem setFrame:CGRectMake(animated ? -100 : LEFTMARGIN, 50 + (startTag * SIZE) + 5, SIZE, SIZE)];
        [menuItem setTag:startTag];
        
        // Add to subview and array
        [self.view addSubview:menuItem];
        menuItems[startTag] = menuItem;
        
        startTag++;
    }
    
    if (animated) {
        for (UIView *item in menuItems) {
            [UIView animateWithDuration:.2 animations:^{
                CGRect newFrame = item.frame;
                newFrame.origin.x = LEFTMARGIN;
                [item setFrame:newFrame];
            }];
        }
    }
    
}


- (void)updateMenuPosition:(float)position {
    if (position <= 100) {
        [self.view setFrame:CGRectMake(position-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setNeedsDisplay];
    } else {
        if (!_menuOpen) {
            [self setMenuOpen:YES];
            AudioServicesPlaySystemSound(openNavSound);
        }
    }
}

- (void)setMenuOpen:(BOOL)menuOpen {
    if (menuOpen) {
        [self.view setFrame:CGRectMake(0, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setNeedsDisplay];
        [self loadMenuItemsAnimated:YES];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            [self.view setFrame:CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
            [self.view setNeedsDisplay];
        }];
    }
    _menuOpen = menuOpen;
}

- (void)tapToClose:(UITapGestureRecognizer *)reg {
    if ([reg locationInView:self.view].x > 100) {
        [self setMenuOpen:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
