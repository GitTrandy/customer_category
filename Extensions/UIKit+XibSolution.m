//
//  UILabel+DeviceMatch.m
//  beatmasterSNS
//
//  Created by Sunny on 13-8-28.
//
//

#import "UIKit+XibSolution.h"
#import "UIImage+Replace_imageNamed.h"
#import <objc/runtime.h>

@implementation UIView (XibSolution)
@dynamic matchDevice;
- (BOOL)matchDevice
{
    return YES; //whatever
}

- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
        self.frame = SNSRect(CGRectGetMinX(self.frame) * SNS_SCALE_X,
                             CGRectGetMinY(self.frame) * SNS_SCALE_Y,
                             CGRectGetWidth(self.frame) * SCREEN_SCALE_W,
                             CGRectGetHeight(self.frame) * SCREEN_SCALE_H);
    }
}

@end

@implementation UIImageView (XibSolution)
- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
        self.frame = SNSRect(CGRectGetMinX(self.frame) * SNS_SCALE_X,
                             CGRectGetMinY(self.frame) * SNS_SCALE_Y,
                             CGRectGetWidth(self.frame) * SNS_SCALE,
                             CGRectGetHeight(self.frame) * SNS_SCALE);
    }
}

- (NSString *)imageName
{
    return @"UIImageView (XibSolution)"; // whatever
}
- (void)setImageName:(NSString *)imageName
{
    if (imageName && imageName.length > 0)
    {
        // 使用imageNamed_New加载
        self.image = [UIImage imageNamed_New:imageName];
    }
}

@end

@implementation UILabel (XibSolution)
- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
        self.frame = SNS_SCALE_RECT(self.frame);
        self.font = SNS_SCALE_FONT(self.font);
    }
}
@end

@implementation UISwitch (XibSolution)
static char* const UISwitchXibTagKey;

- (BOOL)matchDevice
{
    return [objc_getAssociatedObject(self, UISwitchXibTagKey) boolValue]; //whatever
}

- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
        objc_setAssociatedObject(self, UISwitchXibTagKey, @(YES), OBJC_ASSOCIATION_ASSIGN);
        CGPoint centerShouldPut = CGPointMake(self.center.x * SNS_SCALE_X, self.center.y * SNS_SCALE_Y);
        self.center = centerShouldPut;
    }
}

//// Override UISwitch的方法 (有风险)
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if ([objc_getAssociatedObject(self, UISwitchXibTagKey) boolValue])
//    {
//        self.backgroundColor = [UIColor blueColor];
//
//        CGAffineTransform scale = CGAffineTransformMakeScale(SNS_SCALE, SNS_SCALE);
//        self.transform = scale;
//    }
//}
@end

@implementation UIButton (XibSolution)
- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
        CGPoint centerShouldPut = CGPointMake(self.center.x * SNS_SCALE_X, self.center.y * SNS_SCALE_Y);
        self.center = centerShouldPut;
        
        CGAffineTransform scale = CGAffineTransformMakeScale(SNS_SCALE, SNS_SCALE);
        self.transform = scale;
    }
}

@end

@implementation UIScrollView (XibSolution)
- (void)setMatchDevice:(BOOL)matchDevice
{
    if (matchDevice)
    {
//        self.frame = SNSRect(CGRectGetMinX(self.frame) * SNS_SCALE_X,
//                             CGRectGetMinY(self.frame) * SNS_SCALE_Y,
//                             CGRectGetWidth(self.frame) * SCREEN_SCALE_W,
//                             CGRectGetHeight(self.frame) * SCREEN_SCALE_H);
    }
}

@end
