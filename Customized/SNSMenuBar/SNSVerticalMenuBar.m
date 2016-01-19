//
//  SNSVeriticalMenuBar.m
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-11.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSVerticalMenuBar.h"
#import "SNSMenuBarResources.h"

@interface SNSVerticalMenuBar ()
@property (nonatomic, strong) SNSMenuBarItem* returnItem;
- (void)returnItemTouchedHandler:(SNSMenuBarItem *)returnItem;
@end

@implementation SNSVerticalMenuBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showSelectIndicatorAnimation = YES;
        self.selectIndicatorImageView.image = [SNSMenuBarResources indicatorImageWithType:SNSMenuBarIndicatorTypeVerticalBg];
        self.contentScrollView.clipsToBounds = NO;
    }
    return self;
}

- (void)reload
{
    [super reload];
    
    // 向delegate取得return item并加入到content view
    if ([self.delegate respondsToSelector:@selector(menuBarReturnItem:)])
    {
        self.returnItem = [self.delegate menuBarReturnItem:self];
        [self addSubview:self.returnItem];
        
        // 添加事件监听
        [self.returnItem setItemTouchEndHandler:self selector:@selector(returnItemTouchedHandler:)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // return item
    if (self.returnItem)
    {
        CGSize returnItemSize = CGSizeMake(CGRectGetWidth(self.bounds),50.0f*SNS_SCALE); // 默认值
        
        self.returnItem.frame = CGRectMake(0, 0, returnItemSize.width, returnItemSize.height);
        
        // 计算并设置return item center
        self.returnItem.center = CGPointMake(CGRectGetWidth(self.bounds)*0.5f, returnItemSize.height*0.5f);
    }
    
    // content scroll view
    self.contentScrollView.frame = CGRectMake(0,CGRectGetHeight(self.returnItem.frame),CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-CGRectGetHeight(self.returnItem.frame));
    
    // menu items
    if (self.items)
    {
        // 高度按4个位置的大小平分
        CGFloat itemWidth = CGRectGetWidth(self.contentScrollView.frame);
        CGFloat itemHeight = CGRectGetHeight(self.contentScrollView.frame)/4;
        
        for (SNSMenuBarItem* item in self.items)
        {
            NSUInteger index = [self.items indexOfObject:item];
            item.frame = CGRectMake(0, 0, itemWidth, itemHeight);
            
            // 计算并设置menu item center
            CGPoint center = CGPointZero;
            center.x = CGRectGetWidth(self.contentScrollView.frame)*0.5f;
            center.y = (index+0.5f)*itemHeight;
            item.center = center;
        }
        
        // 计算content size
        CGSize contentSize = CGSizeZero;
        contentSize.width = CGRectGetWidth(self.contentScrollView.frame);
        contentSize.height = itemHeight * MAX(self.items.count, 4);
        self.contentScrollView.contentSize = contentSize;
        
    }
    
    // select indicator
    CGFloat selectIndicatorOffset = 10.0f*SNS_SCALE;
    self.selectIndicatorImageView.frame = CGRectMake(-selectIndicatorOffset, CGRectGetMinY(self.selectedItem.frame),CGRectGetWidth(self.selectedItem.frame) + selectIndicatorOffset,CGRectGetHeight(self.selectedItem.frame));
}

- (void)selectAtIndex:(NSUInteger)index
{
    [super selectAtIndex:index];
    
    SNSMenuBarItem* item = self.items[index];
    
    // 更新select indicator动画
    CGRect frame = self.selectIndicatorImageView.frame;
    frame.origin.y = CGRectGetMinY(item.frame);
    if (self.showSelectIndicatorAnimation)
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.selectIndicatorImageView.frame = frame;
        }];
    }
    else
    {
        self.selectIndicatorImageView.frame = frame;
    }
}

- (void)selectReturnItem
{
    [self returnItemTouchedHandler:self.returnItem];
}

#pragma mark - Return Item Touch Handler

- (void)returnItemTouchedHandler:(SNSMenuBarItem *)returnItem
{
    // 播放音效
    PlayEffect(SFX_RETURN);
    
    // 询问delegate是否点击return item
    if ([self.delegate respondsToSelector:@selector(menuBar:shouldSelectReturnItem:)])
    {
        // 若不应return则返回
        if (![self.delegate menuBar:self shouldSelectReturnItem:returnItem])
        {
            return;
        }
    }
    
    // 通知给delegate did return
    if ([self.delegate respondsToSelector:@selector(menuBar:didSelectReturnItem:)])
    {
        
        [self.delegate menuBar:self didSelectReturnItem:returnItem];
    }
}

@end
