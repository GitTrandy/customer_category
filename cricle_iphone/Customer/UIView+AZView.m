//
//  UIView+AZView.m
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/2/28.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "UIView+AZView.h"

@implementation UIView (AZView)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

/** 获取视图的根控制器 */
-(UIViewController *)azViewController
{
    for (UIView *nextView=self.superview;nextView;nextView=nextView.superview)
    {
        UIResponder *nextResponse=[nextView nextResponder];
        if ([nextResponse isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponse;
        }
    }
    return nil;
}

@end
