//
//  UIButton+ExtraProperty.m
//  circle_iphone
//
//  Created by trandy on 15/3/12.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "UIButton+ExtraProperty.h"
#import <objc/runtime.h>

static void* kUIButtonExtraInfo = (void *)@"kUIButtonExtraInfo";

@implementation UIButton (ExtraProperty)

-(void)setExtraInfo:(NSDictionary*)extraInfo
{
    objc_setAssociatedObject(self, kUIButtonExtraInfo,extraInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary*)extraInfo
{
    return objc_getAssociatedObject(self, kUIButtonExtraInfo);
}



@end
