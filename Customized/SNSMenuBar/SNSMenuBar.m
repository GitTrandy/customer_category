//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSMenuBar.h"

@interface SNSMenuBar () <UIGestureRecognizerDelegate>

// callback
- (void)itemTouchedHandler:(SNSMenuBarItem *)item;

@end

@implementation SNSMenuBar

#pragma mark - 创建

// Override
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化bgImageView
        self.backgroundImageView = [UIImageView new];
        [self addSubview:self.backgroundImageView];
        
        // 初始化content view
        self.contentScrollView = [UIScrollView new];
        self.contentScrollView.showsVerticalScrollIndicator = NO;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentScrollView];
        
        // 初始化selectIndicatorImageView
        self.selectIndicatorImageView = [UIImageView new];
        [self.contentScrollView addSubview:self.selectIndicatorImageView];

    }
    return self;
}

#pragma mark - 内容和布局

- (void)reload
{
    // 清除原有item
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.items = nil;
    
    // 向delegate取得item数量
    NSInteger itemCount = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInMenuBar:)])
    {
        itemCount = [self.delegate numberOfItemsInMenuBar:self];
        NSAssert(itemCount >= 0, @"SNSMenurBar item count < 0 !");
    }
    
    // 向delegate依次取得item并加入到content view
    if (itemCount == 0)
    {
        NSLog(@"SNSMenuBar item count = 0");
    }
    else
    {
        NSMutableArray* menuItems = [NSMutableArray arrayWithCapacity:itemCount];
        for (NSInteger index = 0; index < itemCount; index++)
        {
            if ([self.delegate respondsToSelector:@selector(menuBar:itemAtIndex:)])
            {
                SNSMenuBarItem* item = [self.delegate menuBar:self itemAtIndex:index];
                NSAssert(item, @"SNSMenuBar item(%d) is nil", index);
                [menuItems addObject:item];
                [self.contentScrollView addSubview:item];
                
                // 调整手势识别delegate使之不影响scroll滑动事件
                item.longPressRecognizer.delegate = self;
                
                // 添加事件监听
                [item setItemTouchEndHandler:self selector:@selector(itemTouchedHandler:)];
            }
        }
        self.items = menuItems;
    }

    // 重新布局
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        [self reload];
    }
}

#pragma mark - 选择事件
- (void)selectAtIndex:(NSUInteger)index
{
    if (!self.items)
    {
        [self reload];
    }
    NSAssert(index<self.items.count, @"item index:%lu out of range [0, %lu]", (unsigned long)index, (unsigned long)self.items.count);
    
    SNSMenuBarItem* item = self.items[index];

    // 询问delegate是否应该select
    if ([self.delegate respondsToSelector:@selector(menuBar:shouldSelectItem:atIndex:)])
    {
        if (![self.delegate menuBar:self shouldSelectItem:item atIndex:index])
        {
            return;
        }
    }
    
    // 若选中当前选中状态item则不处理
    if (item == self.selectedItem)
    {
        return;
    }

    // 更新老的select item状态
    self.selectedItem.selected = NO;
    [self.selectedItem.animation stop];
    
    // 更新新的select item状态
    item.selected = YES;
    [item.animation start];
    
    // 更新指向
    self.selectedItem = item;
    
    // 通知给delegate
    if ([self.delegate respondsToSelector:@selector(menuBar:didSelectItem:atIndex:)])
    {
        [self.delegate menuBar:self didSelectItem:item atIndex:index];
    }
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Private

- (void)itemTouchedHandler:(SNSMenuBarItem *)item
{
    // 播放音效
    PlayEffect(SFX_BUTTON);
    
    NSUInteger index = [self.items indexOfObject:item];
    if ([self.delegate respondsToSelector:@selector(menuBar:shouldSelectItem:atIndex:)])
    {
        BOOL should = [self.delegate menuBar:self shouldSelectItem:item atIndex:index];
        if (!should)
        {
            return;
        }
    }
    [self selectAtIndex:index];
}


@end
