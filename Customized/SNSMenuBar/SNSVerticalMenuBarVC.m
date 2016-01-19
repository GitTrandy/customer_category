//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSVerticalMenuBarVC.h"
#import "SNSMenuBarResources.h"

CGFloat SNSMenuBarVCBlackCoverViewAlpha = 0.6f;

@interface SNSVerticalMenuBarVC ()
@property (nonatomic, readonly) CGRect menuBarFrame;
@property (nonatomic, readonly) CGRect menuBarBlackCoverFrame;
@end

@implementation SNSVerticalMenuBarVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 初始化backgroundImageView
    if (!self.backgroundImageView)
    {
        self.backgroundImageView = [UIImageView new];
        self.backgroundImageView.image = [SNSMenuBarResources backgroundImageWithType:SNSMenuBarBackgroundImageTypeBlue];
        self.backgroundImageView.frame = self.view.bounds;
        self.backgroundImageView.hidden = YES; // 默认隐藏
        [self.view addSubview:self.backgroundImageView];
        [self.view sendSubviewToBack:self.backgroundImageView]; // 保持在最下层
    }

    // 初始化backgroundCoverView
    if (!self.backgroundCoverView)
    {
        self.backgroundCoverView = [UIView new];
        self.backgroundCoverView.backgroundColor = [UIColor blackColor];
        self.backgroundCoverView.alpha = SNSMenuBarVCBlackCoverViewAlpha;
        self.backgroundCoverView.frame = self.menuBarBlackCoverFrame;
        self.backgroundCoverView.hidden = YES; // 默认隐藏
        [self.view insertSubview:self.backgroundCoverView aboveSubview:self.backgroundImageView]; // 保持在bg上层
    }
    
    // 初始化contentView
    if (!self.contentView)
    {
        self.contentView = [UIView new];
        self.contentView.frame = self.view.bounds;
        [self.view insertSubview:self.contentView aboveSubview:self.backgroundCoverView];
    }
    else if (![self.contentView isDescendantOfView:self.view])
    {
        [self.view insertSubview:self.contentView aboveSubview:self.backgroundCoverView];
    }

    // 初始化menuBar
    if (!self.menuBar)
    {
        self.menuBar = [[SNSVerticalMenuBar alloc] initWithFrame:self.menuBarFrame];
        self.menuBar.delegate = self;
        [self.view addSubview:self.menuBar];
        [self.view bringSubviewToFront:self.menuBar]; // 保证最上层
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    [self.backgroundCoverView removeFromSuperview];
    self.backgroundCoverView = nil;
    [self.menuBar removeFromSuperview];
    self.menuBar = nil;
}

#pragma mark - SNSMenuBar delegate

- (NSInteger)numberOfItemsInMenuBar:(SNSMenuBar *)menuBar
{
    NSAssert(YES, @"Override me");
    return 0;
}

- (SNSMenuBarItem *)menuBar:(SNSMenuBar *)menuBar itemAtIndex:(NSUInteger)index
{
    NSAssert(YES, @"Override me");
    return nil;
}

- (BOOL)menuBar:(SNSMenuBar *)menuBar shouldSelectItem:(SNSMenuBarItem *)item atIndex:(NSUInteger)index
{
    return YES;
}

#pragma mark - SNSVeriticalMenuBar delegate

- (SNSMenuBarItem *)menuBarReturnItem:(SNSMenuBar *)menuBar
{
    return [SNSMenuBarItem itemWithReturnItemType:SNSMenuBarReturnItemTypeGray];
}

#pragma mark - Frames

- (CGRect)menuBarFrame
{
    if (IS_IPHONE4) return (CGRect){430.0f,0,50.0f,320.0f};
    else if (IS_IPHONE5) return (CGRect){518.0f,0,50.0f,320.0f};
    else if (IS_IPADUI) return (CGRect){918.0f,0,106.f,768.0f};
    return CGRectZero;
}

- (CGRect)menuBarBlackCoverFrame
{
    if (IS_IPHONE4) return (CGRect){10.0f, 0, 440.0f, 320.0f};
    else if (IS_IPHONE5) return (CGRect){11.8f, 0, 519.2f,320.0f};
    else if (IS_IPAD) return (CGRect){21.3f,0,938.67f,768.0f};
    return CGRectZero;
}

@end

