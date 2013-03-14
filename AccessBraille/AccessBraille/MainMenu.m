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
    NSDictionary *menuItems = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSLog(@"%@", menuItems);
    
    int startTag = 31;
    int startPos = 384;
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *menuItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", i]]];
        [menuItem setFrame:CGRectMake(0, 0, 180, 180)];
        [menuItem setCenter:CGPointMake(125, startPos)];
        [menuItem setTag:startTag];
        [self setMenuRootItemPosition:menuItem.frame.origin.y]; // Only for root menuItem
        [self.view addSubview:menuItem];
        startTag++;
        startPos = startPos + 180;
    }
}

- (void)moveMenuItemsByDelta:(float)delta {
    NSArray *menuItems = [NSArray arrayFromArray:self.view.subviews passingTest:^BOOL(id obj1) {
        UIImageView *img = (UIImageView *)obj1;
        return (img.tag >= 31);
    }];
    for (UIImageView *item in menuItems){
        // May only work for top menu item
        [item setFrame:CGRectMake(item.frame.origin.x, _menuRootItemPosition + delta > 0 ? _menuRootItemPosition + delta : 0 , item.frame.size.width, item.frame.size.height)];
    }
}



-(void)didMoveToParentViewController:(UIViewController *)parent{
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
}


- (void)viewDidUnload {
    [self setBrailleTyperButton:nil];
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
                [self brailleTyper:nil];
                [scrollMenu setEnabled:NO];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _menuRootItemPosition = _menuRootItemPosition + [reg translationInView:self.view].y < 0 ? 0 : _menuRootItemPosition + [reg translationInView:self.view].y;
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



- (IBAction)brailleTyper:(id)sender {
    
    NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:@"brailleTyper"] animated:NO withMenu:YES];
    
}

- (IBAction)settings:(id)sender {
    
    NavigationContainer *nc = (NavigationContainer *) self.parentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [nc switchToController:[storyboard instantiateViewControllerWithIdentifier:@"settings"] animated:NO withMenu:YES];

}
@end
