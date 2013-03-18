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

@interface MainMenu ()

@property (nonatomic) float menuRootItemPosition;

@end

@implementation MainMenu {
    UIPanGestureRecognizer *scrollMenu;
    NSDictionary *menuItemsDict;
}

@synthesize menuView;

-(void)viewDidLoad{
    
    scrollMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollMenu:)];
    scrollMenu.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:scrollMenu];
    [self.menuView makeClear];
    [self.view sendSubviewToBack:menuView];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"menu.plist"];
    menuItemsDict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSLog(@"%@", menuItemsDict);
    
    int startTag = 31;
    int startPos = 293;
    _menuRootItemPosition = startPos;
    
    // set menu item posisions
    for (int i = 0; i < menuItemsDict.count; i++) {
        UIImageView *menuItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", i]]];
        [menuItem setFrame:CGRectMake(30, startPos, 180, 180)];
        [menuItem setTag:startTag];
        if (i == 0){
            [self setMenuRootItemPosition:menuItem.frame.origin.y]; // Only for root menuItem
        }
        [self.view addSubview:menuItem];
        startTag++;
        startPos = startPos + 180;
    }
    
}

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


- (void)moveMenuItemsByDelta:(float)delta {
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    for (UIImageView *item in menuItems){
        // May only work for top menu item
        float diffFromRoot = 180 * (item.tag - 31);
        [item setFrame:CGRectMake(item.frame.origin.x, _menuRootItemPosition + delta + diffFromRoot, item.frame.size.width, item.frame.size.height)];
    }
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
    [super viewDidUnload];
}

- (void)scrollMenu:(UIPanGestureRecognizer *)reg {
    MainMenuNavigation *view = menuView;
    
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            
            [view setVisible:YES];
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            [self moveMenuItemsByDelta:[reg translationInView:self.view].y];
            if ([reg velocityInView:self.view].x > 4000) {
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

- (void)switchToControllerWithID:(NSNumber *)vcID {
    if ([vcID isEqual: @(-1)]) { return; }
    
    
    // Gets storyboard name from menuItemsDict
    NSString *key = [NSString stringWithFormat:@"%@", vcID];
    NSString *controller = menuItemsDict[key];
    
    // Switches to that controller
    NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:controller] animated:NO withMenu:YES];
    
    
}




@end