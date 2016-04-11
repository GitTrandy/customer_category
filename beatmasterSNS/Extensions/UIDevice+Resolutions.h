//
//  UIDevice+Resolutions.m
//  Simple UIDevice Category for handling different iOSs hardware resolutions
//
//  Created by Daniele Margutti on 9/13/12.
//  web: http://www.danielemargutti.com
//  mail: daniele.margutti@gmail.com
//  Copyright (c) 2012 Daniele Margutti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceResolutionDef.h"

@interface UIDevice (Resolutions) { }

+ (UIDeviceResolution) currentResolution;
+ (CGFloat)currentScreenWidth;
+ (CGFloat)currentScreenHeight;

@end
