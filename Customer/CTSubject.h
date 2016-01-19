//
//  CTSubject.h
//  circle_iphone
//
//  Created by trandy on 15/6/18.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CTRectType)
{
    CTRect_None,
    CTRect_Up,
    CTRect_Down,
    CTRect_Both
};

@interface CTSubject : NSObject

+(UIImageView *)createHLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size;

+(UIImageView *)createVLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size;

+(UIView *)createRect:(UIColor *)bgColor lineColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size type:(CTRectType)type;

+(UIImageView *)createDottedHLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size;

@end
