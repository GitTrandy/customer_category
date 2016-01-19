//
//  CTSegScrollView.h
//  CTSegScrollView
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 设备高度
#define DEVICE_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
// 设备宽度
#define DEVICE_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
// 设备Rect
#define DEVICE_RECT     CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)


@protocol CTSegScrollViewDelegate <NSObject>

@optional
- (UIView *)segScrollViewWithIndex:(NSInteger)index;
- (void)segScrollViewAppearWithIndex:(NSInteger)index;

@end

@interface CTSegScrollView : UIView

@property (nonatomic,strong)    UIFont*     textFont;
@property (nonatomic,strong)    NSArray*    viewArray;
@property (nonatomic,weak)      id<CTSegScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray delegate:(id <CTSegScrollViewDelegate>) delegate;

@end
