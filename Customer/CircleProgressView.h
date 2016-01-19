//
//  CircleProgressView.h
//  circle_iphone
//
//  Created by trandy on 15/3/5.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

// // 平滑更新进度条的时候，进度条每更新一次进度值的时间间隔
#define CSCIRCLEPROGRESS_UPDATE_TIME  0.1f
@class CircleView;
@interface CircleProgressView : UIView
{
   
}

// // 圆环的外围半径
@property (nonatomic,assign) CGFloat radius;
// // 环形宽度
@property (nonatomic,assign) CGFloat circleWidth;
// // 进度条进度
@property (nonatomic,assign) CGFloat progressValue;
// // 环形颜色
@property (nonatomic,strong) UIColor *lineColor;
// // 进度数字字体
@property (nonatomic,strong) UIFont  *labelFont;
// // 进度数字颜色
@property (nonatomic,strong) UIColor *labelTextColor;

// // 进度条背景
@property (nonatomic,strong) UIImageView *progressBgView;

// // 进度条前景
@property (nonatomic,strong) UIImageView *progressFrontView;
// // 数字进度
@property (nonatomic,strong) UILabel     *progressLabel;

// // 动态进度条参数
@property (nonatomic,assign) CGFloat progressTo;
@property (nonatomic,assign) CGFloat progressOffset;
@property (nonatomic,strong) NSTimer *progressTimer;

- (id)initWithFrame:(CGRect)frame radius:(CGFloat)radius circleWidth:(CGFloat)circleWidth lineColor:(UIColor *)lineColor;
-(void)doSetProgressLabel:(UIFont *)font textColor:(UIColor *)textColor;
-(void)doSetProgressValue:(CGFloat)progress;
-(void)doProgressTo:(float)progress time:(float)time;

@end
