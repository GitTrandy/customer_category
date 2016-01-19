//
//  SNSMenuBarItemFactory.h
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBarItem.h"

//--------------------------------------//
//* item工厂,包含程序中用到的所有类型的item *//
//--------------------------------------//
typedef NS_ENUM(NSInteger, SNSMenuBarReturnItemType)
{
    SNSMenuBarReturnItemTypeBlue = 0,
    SNSMenuBarReturnItemTypeGray,  // 未设置时的缺省值
    SNSMenuBarReturnItemTypeGreen,
    SNSMenuBarReturnItemTypePink,
    SNSMenuBarReturnItemTypePurple,
    SNSMenuBarReturnItemTypeYellow
};

typedef NS_ENUM(NSInteger, SNSMenuBarVerticalItemType)
{
    // 二级按钮 //
    
    // 排行榜（蓝色）
    SNSMenuBarVerticalItemTypeCharm = 0,
    SNSMenuBarVerticalItemTypeLevel,
    SNSMenuBarVerticalItemTypeLover,
    SNSMenuBarVerticalItemTypeRich,
    // 消息
    SNSMenuBarVerticalItemTypeMessage,
    SNSMenuBarVerticalItemTypeFriends,
    // 账号
    SNSMenuBarVerticalItemTypeAccount,
    // 设置（蓝色）
    SNSMenuBarVerticalItemTypeSetting,
    SNSMenuBarVerticalItemTypeAbout,
    
    // 俱乐部（蓝色）
    SNSMenuBarVerticalItemTypeNear,
    SNSMenuBarVerticalItemTypeGodGiven,
    SNSMenuBarVerticalItemTypeSearch,
    // 练习（绿色）
    SNSMenuBarVerticalItemTypeAll,
    SNSMenuBarVerticalItemTypeCollection,
//    SNSMenuBarVerticalItemTypeStar,
    SNSMenuBarVerticalItemTypeMine,
    // 对战（紫色）
    SNSMenuBarVerticalItemTypeBattleFriends,
    SNSMenuBarVerticalItemTypeUniverse,
    // 商城（红色）
    SNSMenuBarVerticalItemTypeClothes,
    SNSMenuBarVerticalItemTypeShopStar,
    SNSMenuBarVerticalItemTypeWings,
    SNSMenuBarVerticalItemTypeCharge,
    // 宠物（黄色）
    SNSMenuBarVerticalItemTypeFeed,
    SNSMenuBarVerticalItemTypeStore,
    // 档案（未知）
    SNSMenuBarVerticalItemTypeProfile,
    SNSMenuBarVerticalItemTypeWardrobe,
    SNSMenuBarVerticalItemTypeMerriage,
    SNSMenuBarVerticalItemTypeAchievement,
    
    // 三级按钮 //
    SNSMenuBarVerticalItemTypeCart,
    SNSMenuBarVerticalItemTypeBlackList,
    SNSMenuBarVerticalItemTypeLight,
    SNSMenuBarVerticalItemTypeCompose,
    SNSMenuBarVerticalItemTypePatch
};

typedef NS_ENUM(NSInteger, SNSMenuBarHorizonItemType)
{
    SNSMenuBarHorizonItemTypeProfileHair = 0,
    SNSMenuBarHorizonItemTypeProfileFace,
    SNSMenuBarHorizonItemTypeProfileCoat,
    SNSMenuBarHorizonItemTypeProfileTrouser,
    SNSMenuBarHorizonItemTypeProfileSuit,
    SNSMenuBarHorizonItemTypeProfileShoe,
    SNSMenuBarHorizonItemTypeProfileSnoopy,
    SNSMenuBarHorizonItemTypeProfileDolls,
    
    SNSMenuBarHorizonItemTypeShoppingMallHair,
    SNSMenuBarHorizonItemTypeShoppingMallFace,
    SNSMenuBarHorizonItemTypeShoppingMallCoat,
    SNSMenuBarHorizonItemTypeShoppingMallTrouser,
    SNSMenuBarHorizonItemTypeShoppingMallSuit,
    SNSMenuBarHorizonItemTypeShoppingMallShoe,
    SNSMenuBarHorizonItemTypeShoppingMallSnoopy,
    SNSMenuBarHorizonItemTypeShoppingMallDolls
};
//--------------------------------------//
//* item工厂,包含程序中用到的所有类型的item *//
//--------------------------------------//

@interface SNSMenuBarItem (SNSMenuBarItemFactory)
+ (instancetype)itemWithReturnItemType:(SNSMenuBarReturnItemType)type;
+ (instancetype)itemWithVerticalItemType:(SNSMenuBarVerticalItemType)type;
+ (instancetype)itemWithHorizonItemType:(SNSMenuBarHorizonItemType)type;
@end

