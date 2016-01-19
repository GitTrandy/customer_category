//
//  UIFont+UIFont+Extension.h
//  circle_iphone
//
//  Created by trandy on 15/11/23.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)ctBoldFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}


+ (UIFont *)ctRegularFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

+ (UIFont *)ctMediumFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

+ (UIFont *)ctLightFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

+ (UIFont *)ctThinFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Thin" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

+ (UIFont *)ctULTRALIGHTFontOfSize:(CGFloat)fontSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Ultralight" size:fontSize];
    }else
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

@end
