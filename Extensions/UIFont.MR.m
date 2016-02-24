//
//  UIFont+MR.m
//  Mogu4iPhone
//
//  Created by runsheng on 16/1/19.
//  Copyright © 2016年 杭州卷瓜网络有限公司. All rights reserved.
//
#import <objc/runtime.h>
#import "UIFont+MR.h"

static BOOL hasSwizzled = NO;

@implementation UIFont (MR)

+ (void)load
{
    [self mr_swizzleFontWithSize];
}

+ (void)mr_swizzleFontWithSize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
        Method newMethod = class_getClassMethod(self, @selector(mr_fontWithSize:));
        method_exchangeImplementations(originMethod, newMethod);
        
        originMethod = class_getClassMethod([UIFont class], @selector(boldSystemFontOfSize:));
        newMethod = class_getClassMethod(self, @selector(mr_boldSystemFontOfSize:));
        method_exchangeImplementations(originMethod, newMethod);
        
        originMethod = class_getClassMethod([UIFont class], @selector(boldSystemFontOfSize:));
        newMethod = class_getClassMethod(self, @selector(mr_boldSystemFontOfSize:));
        method_exchangeImplementations(originMethod, newMethod);
        
        hasSwizzled = YES;
    });
}

+ (UIFont *)mr_fontWithSize:(CGFloat)fontSize
{
    NSString *customFontName = [NSBundle mainBundle].infoDictionary[@"MRCustomFontName"];
    UIFont *tFont = [UIFont fontWithName:customFontName size:fontSize];
    return tFont;
}

+ (UIFont *)mr_boldSystemFontOfSize:(CGFloat)fontSize
{
    NSString *customFontName = [NSBundle mainBundle].infoDictionary[@"MRCustomBoldFontName"];
    UIFont *tFont = [UIFont fontWithName:customFontName size:fontSize];
    return tFont;
}

+ (UIFont *)mr_thinFontOfSize:(CGFloat)fontSize
{
    NSString *customFontName = [NSBundle mainBundle].infoDictionary[@"MRCustomThinFontName"];
    UIFont *tFont = [UIFont fontWithName:customFontName size:fontSize];
    return tFont;
}

@end
