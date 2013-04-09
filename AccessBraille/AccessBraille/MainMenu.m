//
//  MainMenu.m
//  AccessBraille
//
//  Created by Michael Timbrook on 2/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "MainMenu.h"
#import "NavigationContainer.h"
#import "BrailleInterpreter.h"
#import "MainMenuNavigation.h"
#import "NSArray+ObjectSubsets.h"
#import "MainMenuItemImage.h"

@interface MainMenu ()
    
/* Menu behavior properties */
@property (nonatomic) float menuRootItemPosition;
@property (readonly) float swipeSensitivity;

@end

@implementation MainMenu {
    UIPanGestureRecognizer *scrollMenu;
    NSDictionary *menuItemsDict;
}

@synthesize menuView;

#pragma mark - Load Methods

-(void)viewDidLoad{
    
    // Set menu properties
    _swipeSensitivity = 2000;
    
    
    // Pan gesture for scrolling and navigating
    scrollMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollMenu:)];
    scrollMenu.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:scrollMenu];
    [self.menuView makeClear];
    [self.view sendSubviewToBack:menuView];
    
    // Load side menu
    [self loadMenuItemsAnimated:YES];
    
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}

- (void)viewDidUnload {
    [self setMenuView:nil];
    [self setOverlayTitle:nil];
    [self setOverlayDiscription:nil];
    [super viewDidUnload];
}

#pragma mark - Menu Methods


/**
 * Checks what menu item is in the selection box and returns it's ID
 **/
- (NSNumber *)checkInBounds {
    
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
    } else { return @(-1); }
}

/**
 * Moves the menu items a set distance from the root menu item position
 **/
- (void)moveMenuItemsByDelta:(float)delta {
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    for (UIImageView *item in menuItems){
        float diffFromRoot = 180 * (item.tag - 31);
        [item setFrame:CGRectMake(item.frame.origin.x, _menuRootItemPosition + delta + diffFromRoot, item.frame.size.width, item.frame.size.height)];
    }
}

/**
 * Loads menu items into view
 **/
- (void)loadMenuItemsAnimated:(BOOL)animated {
    
    // Get menu information
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"menu.plist"];
    menuItemsDict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    int startTag = 31;
    int startPos = 293;
    _menuRootItemPosition = startPos;
    
    // set menu item posisions and add gesture to image view
    for (int i = 0; i < menuItemsDict.count; i++) {
        // load image and set tag
        MainMenuItemImage *menuItem = [[MainMenuItemImage alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", i]]];
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
        startPos = startPos + 180;
    }

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
 * Menu Scrolling
 **/
- (void)scrollMenu:(UIPanGestureRecognizer *)reg {
    MainMenuNavigation *view = menuView;
    
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            
            [view setVisible:YES];
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
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

/**
 * Updates the the menu discription based on its ID and the contents of the menuDiscription.plist
 **/
- (void)setMenuContentInformationAtLocation:(NSNumber *)cvID {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *titlePath = [path stringByAppendingPathComponent:@"MenuTitles.plist"];
    NSString *contentPath = [path stringByAppendingPathComponent:@"menuDiscriptions.plist"];
    NSArray *titles = [[NSArray alloc] initWithContentsOfFile:titlePath];
    NSArray *context = [[NSArray alloc] initWithContentsOfFile:contentPath];
    
    if (cvID.intValue == -1){
        [UIView animateWithDuration:1.0 animations:^{
//            [menuView setHightlightWidth:250]; Pass on resizing for now
            [_OverlayTitle setText:@""];
            [_OverlayDiscription setText:@""];
        }];
    } else {
        [UIView animateWithDuration:2.0 animations:^{
            [menuView setHightlightWidth:750];
            [_OverlayTitle setText:titles[cvID.intValue]];
            [_OverlayDiscription setText:context[cvID.intValue]];
        }];
    }
}

/**
 * Switches to a new controller by it's ID
 **/
- (void)switchToControllerWithID:(NSNumber *)vcID {
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

        // Gets storyboard name from menuItemsDict
        NSString *key = [NSString stringWithFormat:@"%@", vcID];
        NSString *controller = menuItemsDict[key];
        
        // Switches to that controller
        NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:controller] animated:NO withMenu:YES];
        
    }];
}

@end
