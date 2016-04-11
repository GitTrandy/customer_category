//
//  UINavigationController+ChangeRootViewController.m
//  beatmasterSNS
//
//  Created by 周华 on 13-2-5.
//
//

#import "UINavigationController+ChangeRootViewController.h"

@implementation UINavigationController (ChangeRootViewController)

- (void)changeRootViewController:(UIViewController *)newRootVC
{
    NSMutableArray *controllers;
    
    if (self.viewControllers.count != 0)
    {
        controllers = [[self.viewControllers mutableCopy] autorelease];
 
        controllers[0] = newRootVC;
    } else {
        controllers = [NSMutableArray arrayWithObject:newRootVC];
    }
    
    self.viewControllers = controllers;
}

- (UIViewController *)retrieveRootViewController
{
    return (self.viewControllers)[0];
}

@end
