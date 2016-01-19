//
//  UINavigationController+ChangeRootViewController.h
//  beatmasterSNS
//
//  Created by 周华 on 13-2-5.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ChangeRootViewController)

- (void)changeRootViewController:(UIViewController *)newRootVC;

- (UIViewController *)retrieveRootViewController;
@end
