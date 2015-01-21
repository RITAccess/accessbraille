//
//  MainMenu.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenu.h"
#import "NavigationContainer.h"
#import "MainMenuNavigation.h"
#import "NSArray+ObjectSubsets.h"
#import "MainMenuItemImage.h"
#import <ABKeyboard/ABSpeak.h>

#define MENU_SPACING 480

@interface MainMenu ()
    
/* Menu behavior properties */
@property (nonatomic) float menuRootItemPosition;
@property (readonly) float swipeSensitivity;

@end

@implementation MainMenu {
    UISwipeGestureRecognizer *scrollMenuUp;
    UISwipeGestureRecognizer *scrollMenuDown;
    NSArray *menuItemStoryboardReferanceName;
    ABSpeak *speak;
    NSNumber *active;
    NSArray *names;
}

#pragma mark - Load Methods

-(void)viewDidLoad
{
    // Set menu properties
    _swipeSensitivity = 2000;
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    // Pan gesture for scrolling and navigating
//    scrollMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollMenu:)];
//    scrollMenu.minimumNumberOfTouches = 1;
    
    // Swipe Gesture for navigating
    scrollMenuUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shiftMenu:)];
    [scrollMenuUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:scrollMenuUp];
    
    scrollMenuDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shiftMenu:)];
    [scrollMenuDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:scrollMenuDown];
    
    [self.view sendSubviewToBack:_menuView];
    [_menuView makeClear];
    
    // Load side menu
    [self loadMenuItemsAnimated:YES];
    
    UIGraphicsBeginImageContext(CGSizeMake(1024, 768));
    [[UIImage imageNamed:@"menuBackground"] drawInRect:CGRectMake(0, 0, 1024, 768)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    NSString *titlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"MenuTitles.plist"];
    names = [[NSArray alloc] initWithContentsOfFile:titlePath];
    
    // Speaking
    speak = [ABSpeak sharedInstance];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setMenuView:nil];
    [self setOverlayTitle:nil];
    [self setOverlayDiscription:nil];
    [super viewDidUnload];
}

#pragma mark - Menu Methods

/**
 * Checks what menu item is in the selection box and returns it's ID
 **/
- (NSNumber *)checkInBounds
{
    // 284 - 484 highlight bounds
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    
    NSMutableSet *inBounds = [[NSMutableSet alloc] init];
    
    for (UIImageView *img in menuItems){
        if (img.center.y > 284 && img.center.y < 484) {
            [inBounds addObject:@(img.tag - 31)];
        }
    }
    
    if (inBounds.count > 1) {
        return @(-1);
    } else if (inBounds.count == 1) {
        return [[inBounds allObjects] objectAtIndex:0];
    } else {
        return @(-1);
    }
}

/**
 *  Moves the menu items a set distance from the root menu item position
 */
- (void)moveMenuItemsByDelta:(float)delta
{
    [self moveMenuItemsByDelta:delta fromRoot:YES];
}

/**
 * Moves the menu items a set distance from the root menu item position, with a 
 * option to move from root menu item.
 **/
- (void)moveMenuItemsByDelta:(float)delta fromRoot:(BOOL)root
{
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    NSNumber *itemid = [self checkInBounds];
    if ((itemid.intValue == 0 && delta > 0) ||
        (itemid.intValue == menuItems.count - 1 && delta < 0)) {
        [speak speakString:@"end"];
        return;
    }
    for (UIImageView *item in menuItems) {
        float diffFromRoot = root ? MENU_SPACING * (item.tag - 31) : 0;
        [UIView animateWithDuration:(root ? 0 : 0.2) animations:^{
            [item setFrame:({
                CGRectMake(item.frame.origin.x,
                           (root ? _menuRootItemPosition : item.frame.origin.y) + delta + diffFromRoot,
                           item.frame.size.width,
                           item.frame.size.height
                           );
            })];
        }];
    }
    if (![active isEqual:[self checkInBounds]]) {
        [speak stopSpeaking];
        active = [self checkInBounds];
        if (![active  isEqual: @(-1)]) {
            [speak speakString:[NSString stringWithFormat:@"%@", [names objectAtIndex:[active intValue]]]];
        }
    }
}

/**
 * Loads menu items into view
 **/
- (void)loadMenuItemsAnimated:(BOOL)animated
{
    // Get menu information
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"menu.plist"];
    menuItemStoryboardReferanceName = [[NSArray alloc] initWithContentsOfFile:finalPath];
    
    int startTag = 31;
    int startPos = 293;
    _menuRootItemPosition = startPos;
    
    // set menu item posisions and add gesture to image view
    for (int i = 0; i < menuItemStoryboardReferanceName.count; i++) {
        // load image and set tag
        NSString *size = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00 ? @"@2x" : @"";
        MainMenuItemImage *menuItem = [[MainMenuItemImage alloc] initWithImage:[UIImage
                                                                                imageNamed:[NSString stringWithFormat:@"menuItem%d%@.png", i, size]]];
        [menuItem setUserInteractionEnabled:YES];
        [menuItem setFrame:CGRectMake(animated ? -200 : 30, startPos, 180, 180)];
        [menuItem setTag:startTag];
        if (i == 0){
            [self setMenuRootItemPosition:menuItem.frame.origin.y]; // Only for root menuItem
        }
        [self.view addSubview:menuItem];
        // add gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menuItem action:@selector(tapMenuItem:)];
        [tap setNumberOfTapsRequired:1];
        [menuItem addGestureRecognizer:tap];
        [menuItem setDelegate:self];
        // increment
        startTag++;
        startPos = startPos + MENU_SPACING;
    }

    [self.view bringSubviewToFront:_menuView];
    
    if (animated) {
        NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
            UIImageView *img = (UIImageView *)obj1;
            return (img.tag >= 31);
        }];
        [UIView animateWithDuration:.3 animations:^{
            for (UIImageView *item in menuItems){
                [item setFrame:CGRectMake(30, item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
            }
        }];
    }
}


/**
 * Handle navigation
 */
- (void)shiftMenu:(UISwipeGestureRecognizer *)reg
{
    switch (reg.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [self moveMenuItemsByDelta:-MENU_SPACING fromRoot:NO];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self moveMenuItemsByDelta:MENU_SPACING fromRoot:NO];
            break;
            
        default:
            break;
    }
}

/**
 * Handles Menu Scrolling.
 **/
- (void)scrollMenu:(UIPanGestureRecognizer *)reg
{
    MainMenuNavigation *view = _menuView;
    
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            
            [view setVisible:YES];
            
            break;
            
        case UIGestureRecognizerStateChanged:
            if ([reg numberOfTouches] > 1 && [self setActiveItem]){
                // Speak menu item infomation
                [speak speakString:[self getSpeakingStringAtLocation:active]];
            }
            [self moveMenuItemsByDelta:[reg translationInView:self.view].y];
            [self setMenuContentInformationAtLocation:[self checkInBounds]];
            if ([reg velocityInView:self.view].x > _swipeSensitivity) {
                [self switchToControllerWithID:[self checkInBounds]];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _menuRootItemPosition = _menuRootItemPosition + [reg translationInView:self.view].y;
            [view setVisible:NO];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [view setVisible:NO];
            break;
        default:
            break;
    }
    [self.menuView setNeedsDisplay];
}

- (BOOL)setActiveItem
{
    if ([self checkInBounds] != active) {
        active = [self checkInBounds];
        return true;
    } else {
        return false;
    }
}

/**
 * Updates the the menu discription based on its ID and the contents of the menuDiscription.plist.
 **/
- (void)setMenuContentInformationAtLocation:(NSNumber *)cvID
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *contentPath = [path stringByAppendingPathComponent:@"menuDiscriptions.plist"];
    NSArray *context = [[NSArray alloc] initWithContentsOfFile:contentPath];
    
    if (cvID.intValue == -1){
        [UIView animateWithDuration:1.0 animations:^{
            [_OverlayTitle setText:@""];
            [_OverlayDiscription setText:@""];
        }];
    } else {
        [UIView animateWithDuration:2.0 animations:^{
            [_menuView setHightlightWidth:750];
            [_OverlayTitle setText:names[cvID.intValue]];
            [_OverlayDiscription setText:context[cvID.intValue]];
        }];
    }
}

/**
 * Get menu speaking string at locaton.
 */
- (NSString *)getSpeakingStringAtLocation:(NSNumber *)cvID
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *titlePath = [path stringByAppendingPathComponent:@"MenuTitles.plist"];
    NSString *contentPath = [path stringByAppendingPathComponent:@"menuDiscriptions.plist"];
    names = [[NSArray alloc] initWithContentsOfFile:titlePath];
    NSArray *context = [[NSArray alloc] initWithContentsOfFile:contentPath];
    
    NSString *b = @"";
    if (cvID.intValue != -1) {
        b = [b stringByAppendingString:names[cvID.intValue]];
        b = [b stringByAppendingString:@". "];
        b = [b stringByAppendingString:context[cvID.intValue]];
    }
    return b;
}

/**
 * Switches to a new controller by it's ID
 **/
- (void)switchToControllerWithID:(NSNumber *)vcID
{
    if ([vcID isEqual: @(-1)]) { return; }
    
    // Animate off screen
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        for (UIImageView *item in menuItems){
            [item setFrame:CGRectMake(-200, item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
        }
    } completion:^(BOOL finished) {

        NSString *controller = menuItemStoryboardReferanceName[[vcID intValue]];
        
        // Switches to that controller
        NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:controller] animated:NO withMenu:YES];
        
    }];
}

@end
