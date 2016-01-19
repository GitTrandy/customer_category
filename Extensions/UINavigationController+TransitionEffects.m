//
//  UINavigationController+TransitionEffects.m
//  beatmasterSNS
//
//  Created by 周华 on 13-1-8.
//
//

#import "UINavigationController+TransitionEffects.h"

@implementation UINavigationController (TransitionEffects)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption
{
    if (animated)
    {
        [UIView transitionWithView:[self view]
                          duration:0.5
                           options:transitionOption
                        animations:^{
                            
                            [self pushViewController:viewController animated:NO];
                        }
                        completion:^(BOOL finished){}];
    } else {
        [self pushViewController:viewController animated:NO];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption
{
    if (animated)
    {
        [UIView transitionWithView:[self view]
                          duration:0.5
                           options:transitionOption
                        animations:^{
                            
                            [self popViewControllerAnimated:NO];
                        }
                        completion:^(BOOL finished){}];
    } else {
        [self popViewControllerAnimated:NO];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated withTransitionOption:(UIViewAnimationOptions)transitionOption
{
    if (animated)
    {
        [UIView transitionWithView:[self view]
                          duration:0.5
                           options:transitionOption
                        animations:^{
                            
                            [self popToRootViewControllerAnimated:YES];
                        }
                        completion:^(BOOL finished){}];
    } else {
        [self popToRootViewControllerAnimated:NO];
    }
}


- (void)pushViewControllerAnimatedWithFIFO:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES withTransitionOption:UIViewAnimationOptionTransitionCrossDissolve];
}

- (void)popViewControllerAnimatedWithFIFO:(BOOL)animated
{
    [self popViewControllerAnimated:animated withTransitionOption:UIViewAnimationOptionTransitionCrossDissolve];
}

- (void)popToRootViewControllerAnimatedWithFIFO:(BOOL)animated
{
    [self popToRootViewControllerAnimated:animated withTransitionOption:UIViewAnimationOptionTransitionCrossDissolve];
}

@end
