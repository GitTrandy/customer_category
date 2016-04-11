//
//  SNSMenuBarItemFactory.m
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBarItemFactory.h"
#import "SNSMenuBarResources.h"

@implementation SNSMenuBarItem (SNSMenuBarItemFactory)

+ (instancetype)itemWithImages:(NSArray *)images
{
    return [self itemWithImage:images[SNSMenuBarItemImageIndexNormal]
                    hightlight:images[SNSMenuBarItemImageIndexHighlight]
                      selected:images[SNSMenuBarItemImageIndexSelected]];
}

+ (instancetype)itemWithReturnItemType:(SNSMenuBarReturnItemType)type
{
    return [self itemWithImages:[SNSMenuBarResources returnItemImagesWithType:type]];
}

+ (instancetype)itemWithVerticalItemType:(SNSMenuBarVerticalItemType)type
{
    SNSMenuBarItem* item = [self itemWithImages:[SNSMenuBarResources itemImagesWithVerticalType:type]];
    
    // 添加动画
    item.animation = [SNSMenuBarItemAnimationGroup shiningAnimationGroupWithReferItem:item];
    return item;
}

+ (instancetype)itemWithHorizonItemType:(SNSMenuBarHorizonItemType)type
{
    SNSMenuBarItem* item = [self itemWithImages:[SNSMenuBarResources itemImagesWithHorizonType:type]];
    return item;
}

@end

