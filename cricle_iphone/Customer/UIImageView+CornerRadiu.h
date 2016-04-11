//
//  UIImageView+CornerRadiu.h
//  circle_iphone
//
//  Created by trandy on 15/10/30.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(CornerRadiu)

//@property (nonatomic,assign) CGFloat cornerRadiu;
//@property (nonatomic,strong) UIImage *cornerImage;
//
//
//
//@property (nonatomic, assign) CGFloat sd_cornerRadiu;
//@property (nonatomic, strong) UIImage *sd_cornerImage;
//
//- (void)setSd_cornerRadiu:(CGFloat)cornerRadiu;
//- (void)setSd_cornerImage:(UIImage *)cornerImage;
//- (void)sd_setPlaceholder:(UIImage *)placeholder isClip:(BOOL)isClip;


- (CGFloat)CTGetCornerRadiu;
- (UIImage *)CTGetCornerImage;
- (void)CTSetCornerImage:(UIImage *)cornerImage cornerRadiu:(CGFloat)cornerRadiu;


@end
