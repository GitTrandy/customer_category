//
//  CTSubject.m
//  circle_iphone
//
//  Created by trandy on 15/6/18.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTSubject.h"

@implementation CTSubject

+(UIImageView *)createHLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size
{
    //画线
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CTRect(0, 0, size.width,size.height)];

    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size.width);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r/255.0, g/255.0, b/255.0, a);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 1);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), size.width, 1);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageView;
}

+(UIImageView *)createDottedHLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size
{
    //画线
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CTRect(0, 0, size.width,size.height)];
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(line, r/255.0, g/255.0, b/255.0, a);
    CGFloat lengths[] = {1,3};
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 1);    //开始画线
    CGContextAddLineToPoint(line, size.width, 1);
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    return imageView;
}

+(UIImageView *)createVLine:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size
{
    //画线
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CTRect(0, 0, size.width,size.height)];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size.height);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r/255.0, g/255.0, b/255.0, a);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 1);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 1, size.height);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageView;
}


+(UIView *)createRect:(UIColor *)bgColor lineColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a size:(CGSize)size type:(CTRectType)type
{
    UIView* view = [[UIView alloc] initWithFrame:CTRect(0, 0, size.width, size.height)];
    view.backgroundColor = bgColor;
    switch (type) {
        case CTRect_None:
            
            break;
        case CTRect_Up:
        {
            UIImageView* upImg = [CTSubject createHLine:r g:g b:b a:a size:CTSize(size.width, 0.5)];
            upImg.frame = CTRect(0, 0, upImg.frame.size.width, upImg.frame.size.height);
            [view addSubview:upImg];
        }
            break;
        case CTRect_Down:
        {
            UIImageView* downImg = [CTSubject createHLine:r g:g b:b a:a size:CTSize(size.width, 0.5)];
            downImg.frame = CTRect(0, size.height - 0.5, downImg.frame.size.width, downImg.frame.size.height);
            [view addSubview:downImg];
        }
            break;
        case CTRect_Both:
        {
            UIImageView* upImg = [CTSubject createHLine:r g:g b:b a:a size:CTSize(size.width, 0.5)];
            upImg.frame = CTRect(0, 0, upImg.frame.size.width, upImg.frame.size.height);
            [view addSubview:upImg];
            
            UIImageView* downImg = [CTSubject createHLine:r g:g b:b a:a size:CTSize(size.width, 0.5)];
            downImg.frame = CTRect(0, size.height - 0.5, downImg.frame.size.width, downImg.frame.size.height);
            [view addSubview:downImg];
        }
            break;
        default:
            break;
    }
    
    return view;
}

@end
