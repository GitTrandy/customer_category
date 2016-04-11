//
//  UINavigationController+TransitionEffects.h
//  beatmasterSNS
//
//  Created by 周华 on 13-1-8.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TransitionEffects)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption;
- (void)popViewControllerAnimated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption;
- (void)popToRootViewControllerAnimated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption;

- (void)pushViewControllerAnimatedWithFIFO:(UIViewController *)viewController;
- (void)popViewControllerAnimatedWithFIFO:(BOOL)animated;
- (void)popToRootViewControllerAnimatedWithFIFO:(BOOL)animated;

@end
