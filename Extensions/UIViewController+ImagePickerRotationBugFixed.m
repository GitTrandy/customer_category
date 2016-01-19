//
//  UIViewController+ImagePickerRotationBugFixed.m
//  beatmasterSNS
//
//  Created by Sunny on 13-8-27.
//
//

#import "UIViewController+ImagePickerRotationBugFixed.h"

@implementation UIViewController (ImagePickerRotationBugFixed)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
