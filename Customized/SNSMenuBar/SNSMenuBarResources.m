//
//  SNSMenuBarResources.m
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-14.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBarResources.h"

@interface SNSMenuBarResources ()
+ (UIImage *)myImageWithName:(NSString *)name;
+ (NSArray *)imagesWithImageNames:(NSArray *)imageNames;
@end

@implementation SNSMenuBarResources

+ (NSArray *)itemImagesWithVerticalType:(SNSMenuBarVerticalItemType)type
{
    static NSArray* itemNames = nil;
    if (!itemNames)
    {
        itemNames = @[@"Charm",@"Level",@"Lover",@"Rich",
                      @"Message",@"Friend",
                      @"Account",
                      @"Setting",@"About",
                      @"Near",@"GodGiven",@"Search",
                      @"All",@"Collection",@"Mine",
                      @"BattleFriends",@"Universe",
                      @"Clothes",@"StarClothes",@"Wings",@"Charge",
                      @"PetsFeed",@"PetsStore",
                      @"Profile",@"Wardrobe",@"Merriage",@"Achievement",
                      @"Cart",@"BlackList",@"Light",@"Compose", @"Patch"];
    }
    NSString* normalName = [@"SNSMenuBarItem" stringByAppendingString:itemNames[type]];
    NSString* highlightName = [normalName stringByAppendingString:@"Highlight"];
    NSString* selectedName = [normalName stringByAppendingString:@"Selected"];
    
    return [self imagesWithImageNames:@[normalName, highlightName, selectedName]];
}

+ (NSArray *)itemImagesWithHorizonType:(SNSMenuBarHorizonItemType)type
{
    static NSArray* itemNames = nil;
    if (!itemNames)
    {
        itemNames = @[@"ProfileHair",@"ProfileFace",@"ProfileCoat",@"ProfileTrouser",
                      @"ProfileSuit",@"ProfileShoe",@"ProfileSnoopy",@"ProfileDolls",
                      @"ShoppingMallHair",@"ShoppingMallFace",@"ShoppingMallCoat",@"ShoppingMallTrouser",
                      @"ShoppingMallSuit",@"ShoppingMallShoe",@"ShoppingMallSnoopy",@"ShoppingMallDolls"];
    }
    NSString* normalName = [@"SNSMenuBarItem" stringByAppendingString:itemNames[type]];
    NSString* highlightName = [normalName stringByAppendingString:@"Highlight"];
    NSString* selectedName = [normalName stringByAppendingString:@"Selected"];
    
    return [self imagesWithImageNames:@[normalName, highlightName, selectedName]];
}

+ (NSArray *)returnItemImagesWithType:(SNSMenuBarReturnItemType)type
{
    static NSArray* colorNames = nil;
    if (!colorNames)
    {
        colorNames =  @[@"Blue",@"Gray",@"Green",@"Pink",@"Purple",@"Yellow"];
    }
    
    NSString* normalName = [@"SNSMenuBarReturnItem" stringByAppendingString:colorNames[type]];
    NSString* highlightName = [normalName stringByAppendingString:@"Highlight"];
    NSString* selectedName = [normalName stringByAppendingString:@"Selected"];


    return [self imagesWithImageNames:@[normalName, highlightName, selectedName]];
}

+ (NSArray *)keyFrameImagesWithType:(SNSMenuBarKeyFrameResourceType)type
{
    switch (type)
    {
        case SNSMenuBarKeyFrameResourceTypeLight:{
            static NSArray* lightImageArray = nil;
            if (!lightImageArray)
            {
                NSMutableArray* images = [NSMutableArray arrayWithCapacity:8];
                for (int i = 0; i <= 7 ; i++)
                {
                    NSString* name = [NSString stringWithFormat:@"SNSMenuBarItemLightAnimation%02d", i];
                    UIImage* image = [UIImage imageNamed:name];
                    assert(image);  // image不存在
                    [images addObject:image];
                }
                lightImageArray = [images copy];
            }
            return lightImageArray;
        }break;
            
        case SNSMenuBarKeyFrameResourceTypeShine:{
            static NSArray* shineImageArray = nil;
            if (!shineImageArray)
            {
                NSMutableArray* images = [NSMutableArray arrayWithCapacity:12];
                for (int i = 0; i <= 11 ; i++)
                {
                    NSString* name = [NSString stringWithFormat:@"SNSMenuBarItemShineAnimation%02d", i];
                    UIImage* image = [UIImage imageNamed:name];
                    assert(image);  // image不存在
                    [images addObject:image];
                }
                shineImageArray = [images copy];
            }
            return shineImageArray;
        }break;
            
        default:
            return nil;
            break;
    }
}

+ (UIImage *)indicatorImageWithType:(SNSMenuBarIndicatorType)type
{
    static NSArray* indicatorNames = nil;
    if (!indicatorNames)
    {
        indicatorNames =  @[@"Profile0",@"Profile1",@"ProfileBg",
                            @"ShoppingMall0",@"ShoppingMall1",@"ShoppingMallBg",
                            @"VerticalBg"];
    }
    NSString* name = [@"SNSMenuBarIndicator" stringByAppendingString:indicatorNames[type]];
    return [self myImageWithName:name];
}

#pragma mark - Private

+ (UIImage *)myImageWithName:(NSString *)name
{
    UIImage* image = [UIImage imageNamed:name];
    if (!image && ![name hasSuffix:@"Selected"])
    {
        NSLog(@"SNSMenuBar image not found:%@", name);
    }
    return image;
}

+ (NSArray *)imagesWithImageNames:(NSArray *)imageNames
{
    UIImage* normalImage = [self myImageWithName:imageNames[SNSMenuBarItemImageIndexNormal]];
    NSAssert(normalImage, @"SNSMenuBar image not found:%@", imageNames[SNSMenuBarItemImageIndexNormal]);
    UIImage* highlightImage = [self myImageWithName:imageNames[SNSMenuBarItemImageIndexHighlight]];
    NSAssert(highlightImage, @"SNSMenuBar image not found:%@", imageNames[SNSMenuBarItemImageIndexHighlight]);
    UIImage* selectedImage = [self myImageWithName:imageNames[SNSMenuBarItemImageIndexSelected]];
    selectedImage = selectedImage ?: normalImage;
    return @[normalImage, highlightImage, selectedImage];
}

+ (UIImage *)backgroundImageWithType:(SNSMenuBarBackgroundImageType)type
{
    return [self myImageWithName:@"SNSMenuBarBgBlue"];
}

@end

