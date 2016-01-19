//
//  CTCircleMask.m
//  circle_iphone
//
//  Created by sujie on 15/4/14.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTCircleMask.h"

@implementation CTCircleMask

+ (CAShapeLayer *)createCircleMask:(float)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CTPoint(radius, radius)
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    
    return shape;
}

@end
