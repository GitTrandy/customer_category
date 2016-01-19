//
//  SNSMenuBarItemAnimator.h
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

@class SNSMenuBarItem;

//-----------------------
//SNSMenuBarItemAnimation
//-----------------------

@interface SNSMenuBarItemAnimation : UIImageView

- (instancetype)initWithReferItem:(SNSMenuBarItem *)referItem;
@property (nonatomic, readonly, weak) SNSMenuBarItem* referItem;

// 为了保持动画可以适配外层frame大小,使用相对于宽和高的位置
@property (nonatomic) CGPoint relativeSize; // 默认(1.0,1.0)
@property (nonatomic) CGPoint relativeCenter;// 默认(0.5,0.5)

// 动画循环间隔
@property (nonatomic) NSTimeInterval animationInterval; // 默认0,值是0时不使用timer

- (void)start;
- (void)stop;

@end

//----------------------------
//SNSMenuBarItemAnimationGroup
//----------------------------

@interface SNSMenuBarItemAnimationGroup : SNSMenuBarItemAnimation
@property (nonatomic, strong, readonly) NSArray* animations;
- (void)addAnimation:(SNSMenuBarItemAnimation *)animation;
@end

@interface SNSMenuBarItemAnimationGroup (Factory)

// 右边栏menu白色亮光动画和星星闪光动画
+ (instancetype)shiningAnimationGroupWithReferItem:(SNSMenuBarItem *)item;

@end

