//
//  UIImageView+CornerRadiu.h
//  circle_iphone
//
//  Created by trandy on 15/10/30.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "UIImageView+CornerRadiu.h"
#import <objc/runtime.h>

static void* kCornerRadiu = (void *)@"kCornerRadiu";

static void* kCornerImage = (void *)@"kCornerImage";


@implementation UIImageView (CornerRadiu)

//- (void)setCornerRadiu:(CGFloat )cornerRadiu
//{
//    NSNumber *radiuNum = [NSNumber numberWithFloat:cornerRadiu];
//    objc_setAssociatedObject(self, kCornerRadiu,radiuNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
////    if (self.cornerImage) {
//////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////            CGSize imageSize = self.frame.size;
////            CGFloat width = imageSize.width;
////            CGFloat height = imageSize.height;
////            UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
////            CGRect rect = CGRectMake(0, 0, width, height);
////            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiu] addClip];
////            [self.cornerImage drawInRect:rect];
////            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
////            UIGraphicsEndImageContext();
//////            dispatch_async(dispatch_get_main_queue(), ^{
////                NSLog(@"set corner radiu     1111");
////                [self setImage:newImage];
//////            });
//////        });
////    }
//}
//
//-(CGFloat )cornerRadiu
//{
//    NSNumber* radiuNum =  objc_getAssociatedObject(self, kCornerRadiu);
//    return [radiuNum floatValue];
//}
//
//- (void)setCornerImage:(UIImage *)cornerImage
//{
//    if (self.cornerRadiu) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            CGSize imageSize = self.frame.size;
//            CGFloat width = imageSize.width;
//            CGFloat height = imageSize.height;
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
//            CGRect rect = CGRectMake(0, 0, width, height);
//            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiu] addClip];
//            [cornerImage drawInRect:rect];
//            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"set image  33333");
//                [self setImage:newImage];
//            });
//        });
//    }
//    
//    objc_setAssociatedObject(self, kCornerImage, cornerImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIImage *)cornerImage
//{
//    return objc_getAssociatedObject(self, kCornerImage);
//}
//
//
//
//- (void)setSd_cornerRadiu:(CGFloat)cornerRadiu
//{
//    NSNumber *radiuNum = [NSNumber numberWithFloat:cornerRadiu];
//    objc_setAssociatedObject(self, kCornerRadiu,radiuNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
////    if (self.cornerImage) {
////        CGSize imageSize = self.frame.size;
////        CGFloat width = imageSize.width;
////        CGFloat height = imageSize.height;
////        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
////        CGRect rect = CGRectMake(0, 0, width, height);
////        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiu] addClip];
////        [self.cornerImage drawInRect:rect];
////        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
////        UIGraphicsEndImageContext();
////        [self setImage:newImage];
////    }
//}
//
//- (CGFloat )sd_cornerRadiu
//{
//    NSNumber* radiuNum =  objc_getAssociatedObject(self, kCornerRadiu);
//    return [radiuNum floatValue];
//}
//
//- (void)setSd_cornerImage:(UIImage *)cornerImage
//{
//    if (self.cornerRadiu) {
//        CGSize imageSize = self.frame.size;
//        CGFloat width = imageSize.width;
//        CGFloat height = imageSize.height;
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
//        CGRect rect = CGRectMake(0, 0, width, height);
//        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiu] addClip];
//        [cornerImage drawInRect:rect];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [self setImage:newImage];
//    }
//    
//    objc_setAssociatedObject(self, kCornerImage, cornerImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIImage *)sd_cornerImage
//{
//    return objc_getAssociatedObject(self, kCornerImage);
//}
//
//- (void)sd_setPlaceholder:(UIImage *)placeholder isClip:(BOOL)isClip;
//{
//    if (isClip) {
//        NSLog(@"clip");
//        [self setSd_cornerImage:placeholder];
//    }else
//    {
//        CGSize imageSize = self.frame.size;
//        CGFloat width = imageSize.width;
//        CGFloat height = imageSize.height;
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
//        CGRect rect = CGRectMake(0, 0, width, height);
//        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiu] addClip];
//        [placeholder drawInRect:rect];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [self setImage:newImage];
//    }
//}




- (void)CTSetCornerImage:(UIImage *)cornerImage cornerRadiu:(CGFloat)cornerRadiu
{
    if (cornerImage == nil) {
        NSLog(@"图片不能为空");
        return;
    }
    
    if (cornerRadiu == 0) {
        //没有剪切角度，不剪切
        [self setImage:cornerImage];
        return;
    }
    
    NSNumber *radiuNum = [NSNumber numberWithFloat:cornerRadiu];
    objc_setAssociatedObject(self, kCornerRadiu,radiuNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, kCornerImage, cornerImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGSize imageSize = self.frame.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGRect rect = CGRectMake(0, 0, width, height);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadiu] addClip];
    [cornerImage drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setImage:newImage];
}

- (CGFloat)CTGetCornerRadiu
{
    NSNumber* radiuNum =  objc_getAssociatedObject(self, kCornerRadiu);
    return [radiuNum floatValue];
}

- (UIImage *)CTGetCornerImage
{
    return objc_getAssociatedObject(self, kCornerImage);
}

@end
