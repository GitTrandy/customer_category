//
//  UIFont+MR.h
//  Mogu4iPhone
//
//  Created by runsheng on 16/1/19.
//  Copyright © 2016年 杭州卷瓜网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MR)

/**
 *  替换掉系统方法
 */
+ (void)mr_swizzleFontWithSize;

/**
 *  系统systemFontWithSize方法的替换
 *
 *  @param fontSize font大小
 *
 *  @return UIFont*
 */
+ (UIFont *)mr_fontWithSize:(CGFloat)fontSize;
/**
 *  系统boldSystemFontOfSize方法的替换
 *
 *  @param fontSize font大小
 *
 *  @return UIFont*
 */
+ (UIFont *)mr_boldSystemFontOfSize:(CGFloat)fontSize;
/**
 *  支持light字体
 *
 *  @param fontSize font大小
 *
 *  @return UIFont*
 */
+ (UIFont *)mr_thinFontOfSize:(CGFloat)fontSize;

@end
