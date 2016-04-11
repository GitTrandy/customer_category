//
//  CTAnnotation.m
//  circle_iphone
//
//  Created by trandy on 15/4/20.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTAnnotation.h"

@implementation CTAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        self.coordinate = coords;
    }
    return self;
}

@end
