//
//  CTAnnotation.h
//  circle_iphone
//
//  Created by trandy on 15/4/20.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CTAnnotation : NSObject<MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords;

@end
