//
//  CTCircleMask.h
//  circle_iphone
//
//  Created by sujie on 15/4/14.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCircleMask : NSObject

/*
 通过贝塞尔曲线绘制圆形遮罩
 
 param      radius  圆形半径
 */
+ (CAShapeLayer *)createCircleMask:(float)radius;
@end
