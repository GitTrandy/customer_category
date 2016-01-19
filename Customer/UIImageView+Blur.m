//
//  UIImageView+Blur.m
//  circle_iphone
//
//  Created by sujie on 15/11/17.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "UIImageView+Blur.h"

@implementation UIImageView (Blur)



- (void)blurImageViewWithStyle:(BlurStyle)style
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version < 8.0) {
        UIImage *blurImage = [self applyBlurRadius:30 toImage:self.image];
        [self setImage:blurImage];
    }else {
        UIVisualEffectView *blurView = [self viewWithTag:50000];
        blurView = [self applyBlurRect:self.bounds style:style];
        if (![self viewWithTag:50000]) {
            blurView.tag = 50000;
            [self addSubview:blurView];
        }
    }
}



- (UIImage *)applyBlurRadius:(CGFloat)radius toImage:(UIImage *)image
{
    if (radius < 0) radius = 0;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

- (UIVisualEffectView *)applyBlurRect:(CGRect)blurRect style:(BlurStyle)style
{
    UIBlurEffect *blurEffect;
    switch (style) {
        case BlurStyleDark:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            break;
        case BlurStyleExtraLight:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            break;
        case BlurStyleLight:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            break;
    }
    
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    view.frame = blurRect;
    view.alpha = 1.0;
    
    return view;
}

@end
