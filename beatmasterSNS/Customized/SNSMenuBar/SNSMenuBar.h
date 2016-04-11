//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSMenuBarItem.h"
#import "SNSMenuBarItemFactory.h"

@class SNSMenuBar;

@protocol SNSMenuBarDelegate <NSObject>
@required
// items
- (NSInteger)numberOfItemsInMenuBar:(SNSMenuBar *)menuBar;
- (SNSMenuBarItem *)menuBar:(SNSMenuBar *)menuBar itemAtIndex:(NSUInteger)index;
@optional
// 点击item事件
- (BOOL)menuBar:(SNSMenuBar *)menuBar shouldSelectItem:(SNSMenuBarItem *)item atIndex:(NSUInteger)index;
- (void)menuBar:(SNSMenuBar *)menuBar didSelectItem:(SNSMenuBarItem *)item atIndex:(NSUInteger)index;
@end


@interface SNSMenuBar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<SNSMenuBarDelegate> delegate;

/* subviews 从底至上
 + view
    - backgroundImageView (MenuBar背景图，默认nil)
    + contentScrollView
        - selectIndicatorImageView (选中的item的指示背景，切换时动画转换)
        - item1
        - item2
        - ...
 */
@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIImageView* selectIndicatorImageView;
@property (nonatomic, strong) UIScrollView* contentScrollView;

// items
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, weak) SNSMenuBarItem* selectedItem;

// 是否打开指示器动画
@property (nonatomic) BOOL showSelectIndicatorAnimation; // Default YES

// 重新加载item并重新布局
- (void)reload;
// 相当于主动触发点击事件
- (void)selectAtIndex:(NSUInteger)index;


@end
