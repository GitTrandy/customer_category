//
//  UIImage+fixOrientation.h
//  circle_iphone
//
//  Created by sujie on 15/6/8.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

//修改拍照后发送图片旋转90度bug

@interface UIImage (FixOrientation)
- (UIImage *)fixOrientation;
@end
