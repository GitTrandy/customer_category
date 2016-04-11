//
//  SNSHorizonMenuBar.m
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSHorizonMenuBar.h"
#import "SNSMenuBarResources.h"

@interface SNSHorizonMenuBar () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView* leftIndicatorImageView;
@property (nonatomic, strong) UIImageView* rightIndicatorImageView;
@end

@implementation SNSHorizonMenuBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leftIndicatorImageView = [UIImageView new];
        [self addSubview:self.leftIndicatorImageView];
        self.rightIndicatorImageView = [UIImageView new];
        [self addSubview:self.rightIndicatorImageView];
        
        self.contentScrollView.clipsToBounds = YES;
        self.contentScrollView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentScrollView.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds)-10*2, CGRectGetHeight(self.bounds));
    self.leftIndicatorImageView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.bounds));
    self.rightIndicatorImageView.frame = CGRectMake(CGRectGetWidth(self.bounds)-10, 0, 10, CGRectGetHeight(self.bounds));

    
    if (self.items && self.items.count > 0)
    {
        CGFloat itemWidth = 50.0f;
        CGFloat itemHeight = CGRectGetHeight(self.contentScrollView.bounds);
        NSInteger itemCount = self.items.count;
        
        for (SNSMenuBarItem* item in self.items)
        {
            NSUInteger index = [self.items indexOfObject:item];
            item.frame = CGRectMake(itemWidth*index, 0, itemWidth, itemHeight);
        }
        
        self.contentScrollView.contentSize = CGSizeMake(itemWidth*itemCount, itemHeight);
    }
}

- (void)setHorizonMenuBarType:(SNSHorizonMenuBarType)menuBarType
{
    self->_horizonMenuBarType = menuBarType;
    [self scrollViewDidScroll:self.contentScrollView];
}

#pragma mark - UIScrollView delegate

// 更新左右两边的指示器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 左边
    if (scrollView.contentOffset.x <= 0)
    {
        SNSMenuBarIndicatorType leftType = self.horizonMenuBarType == SNSHorizonMenuBarTypeProfile ? SNSMenuBarIndicatorTypeProfile0 : SNSMenuBarIndicatorTypeShoppingMall0;
        self.leftIndicatorImageView.image = [SNSMenuBarResources indicatorImageWithType:leftType];
    }
    else
    {
        // 遮挡
        SNSMenuBarIndicatorType leftType = self.horizonMenuBarType == SNSHorizonMenuBarTypeProfile ? SNSMenuBarIndicatorTypeProfile1 : SNSMenuBarIndicatorTypeShoppingMall1;
        self.leftIndicatorImageView.image = [SNSMenuBarResources indicatorImageWithType:leftType];
    }
    
    // 右边
    if (scrollView.contentOffset.x > scrollView.contentSize.width -CGRectGetWidth(scrollView.frame))
    {
        SNSMenuBarIndicatorType rightType = self.horizonMenuBarType == SNSHorizonMenuBarTypeProfile ? SNSMenuBarIndicatorTypeProfile0 : SNSMenuBarIndicatorTypeShoppingMall0;
        self.rightIndicatorImageView.image = [SNSMenuBarResources indicatorImageWithType:rightType];
    }
    else
    {
        // 遮挡
        SNSMenuBarIndicatorType rightType = self.horizonMenuBarType == SNSHorizonMenuBarTypeProfile ? SNSMenuBarIndicatorTypeProfile1 : SNSMenuBarIndicatorTypeShoppingMall1;
        self.rightIndicatorImageView.image = [SNSMenuBarResources indicatorImageWithType:rightType];
    }
    
}

@end
