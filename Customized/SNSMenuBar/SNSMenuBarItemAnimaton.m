//
//  SNSMenuBarItemAnimator.m
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBarItemAnimaton.h"
#import "SNSMenuBarItem.h"
#import "SNSMenuBarResources.h"

@interface SNSMenuBarItemAnimation ()
@property (nonatomic, strong) NSTimer* animationTimer;
@end

@implementation SNSMenuBarItemAnimation

- (instancetype)initWithReferItem:(SNSMenuBarItem *)referItem
{
    self = [super init];
    if (self)
    {
        self->_referItem = referItem;
        self.animationInterval = 0;
        self.relativeSize = CGPointMake(1.0f, 1.0f);
        self.relativeCenter = CGPointMake(0.5f, 0.5f);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.referItem.animationView.bounds);
    CGFloat h = CGRectGetHeight(self.referItem.animationView.bounds);
    self.frame = CGRectMake(0, 0, w*self.relativeSize.x, h*self.relativeSize.y);
    self.center = CGPointMake(w*self.relativeCenter.x, w*self.relativeCenter.y);
}

- (void)start
{
    [self startAnimating];
    [self setNeedsLayout];

    // 使用timer设置播放间隔
    if (self.animationInterval > 0)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval target:self selector:@selector(startAnimating) userInfo:nil repeats:YES];
    }
}

- (void)stop
{
    [self stopAnimating];
    if (self.animationTimer)
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

@end

@implementation SNSMenuBarItemAnimationGroup

- (void)addAnimation:(SNSMenuBarItemAnimation *)animation
{
    if (!self->_animations)
    {
        self->_animations = @[];
    }
    self->_animations = [self->_animations arrayByAddingObject:animation];
    [self addSubview:animation];
}
- (void)start
{
    [self.animations makeObjectsPerformSelector:@selector(start)];
}

- (void)stop
{
    [self.animations makeObjectsPerformSelector:@selector(stop)];
}

@end


@implementation SNSMenuBarItemAnimationGroup (Factory)

+ (instancetype)shiningAnimationGroupWithReferItem:(SNSMenuBarItem *)item
{
    // 玻璃表面白光效果
    SNSMenuBarItemAnimation* light = [[SNSMenuBarItemAnimation alloc] initWithReferItem:item];
    light.animationImages = [SNSMenuBarResources keyFrameImagesWithType:SNSMenuBarKeyFrameResourceTypeLight];
    light.animationDuration = 1.0f;
    light.animationRepeatCount = 1;
    light.relativeSize = CGPointMake(0.65f, 0.65f);
    light.relativeCenter = CGPointMake(0.58f, 0.58f);
    light.animationInterval = 1.0f;
    
    // 星星闪光效果
    SNSMenuBarItemAnimation* shine = [[SNSMenuBarItemAnimation alloc] initWithReferItem:item];
    shine.animationImages = [SNSMenuBarResources keyFrameImagesWithType:SNSMenuBarKeyFrameResourceTypeShine];
    shine.animationDuration = 1.0f;
    shine.animationRepeatCount = 0;
    shine.relativeSize = CGPointMake(0.5f, 0.5f);
    shine.relativeCenter = CGPointMake(0.628f, 0.052f);
    
    // 组合
    SNSMenuBarItemAnimationGroup* group = [[self alloc] initWithReferItem:item];
    [group addAnimation:light];
    [group addAnimation:shine];
    
    return group;
}

@end
