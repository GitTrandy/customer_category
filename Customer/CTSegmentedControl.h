//
//  CTSegmentedControl.h
//  circle_iphone
//
//  Created by sujie on 15/6/17.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTSegmentedControlDelegate <NSObject>

@optional
//点击回调
- (void)segmentedClickForIndex:(NSInteger)clickIndex;

@end

@interface CTSegmentedControl : UIView

@property (nonatomic, assign) NSInteger segButtonCount;                             //按钮个数
@property (nonatomic, assign) float segButtonWidth;                                 //按钮宽度
@property (nonatomic, assign) NSInteger defaultSelectedIndex;                       //默认选中按钮

@property (nonatomic, strong) NSArray *segButtonTitleArray;                         //按钮title数组
@property (nonatomic, strong) NSArray *segButtonNormalBackgroundImageArray;         //按钮默认图片数组
@property (nonatomic, strong) NSArray *segButtonSelectedBackgroundImageArray;       //按钮选中图片数组

@property (nonatomic, weak) id<CTSegmentedControlDelegate> delegate;


- (instancetype)init;                                                               //初始化方法
- (void)loadMainView;                                                               //执行配置并加载
- (void)restoreDefaultState;                                                        //所有按钮恢复未选中状态

@end
