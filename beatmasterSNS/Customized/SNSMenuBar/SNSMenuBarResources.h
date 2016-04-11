//
//  SNSMenuBarResources.h
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-14.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBarItemFactory.h"

typedef NS_ENUM(NSInteger, SNSMenuBarKeyFrameResourceType)
{
    SNSMenuBarKeyFrameResourceTypeShine = 0,
    SNSMenuBarKeyFrameResourceTypeLight
};

typedef NS_ENUM(NSInteger, SNSMenuBarIndicatorType)
{
    SNSMenuBarIndicatorTypeProfile0 = 0,
    SNSMenuBarIndicatorTypeProfile1,
    SNSMenuBarIndicatorTypeProfileBg,
    SNSMenuBarIndicatorTypeShoppingMall0,
    SNSMenuBarIndicatorTypeShoppingMall1,
    SNSMenuBarIndicatorTypeShoppingMallBg,
    SNSMenuBarIndicatorTypeVerticalBg
};

typedef NS_ENUM(NSInteger, SNSMenuBarBackgroundImageType)
{
    SNSMenuBarBackgroundImageTypeBlue
};

// Private
@interface SNSMenuBarResources : NSObject
+ (NSArray *)itemImagesWithVerticalType:(SNSMenuBarVerticalItemType)type;
+ (NSArray *)itemImagesWithHorizonType:(SNSMenuBarHorizonItemType)type;

+ (NSArray *)returnItemImagesWithType:(SNSMenuBarReturnItemType)type;
+ (NSArray *)keyFrameImagesWithType:(SNSMenuBarKeyFrameResourceType)type;
+ (UIImage *)indicatorImageWithType:(SNSMenuBarIndicatorType)type;

+ (UIImage *)backgroundImageWithType:(SNSMenuBarBackgroundImageType)type;
@end
