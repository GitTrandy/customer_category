//
//  CSCircleProgressView.h
//  beatmasterSNS
//
//  Created by chengsong on 12-12-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// // 平滑更新进度条的时候，进度条每更新一次进度值的时间间隔
#define CSCIRCLEPROGRESS_UPDATE_TIME  0.1f
@class CircleView;
@interface CSCircleProgressView : UIView
{
    // // 圆环的外围半径
    CGFloat _radius;
    // // 环形宽度
    CGFloat _circleWidth;
    // // 进度条进度
    CGFloat _progressValue;
    // // 环形颜色
    UIColor *_lineColor;
    // // 进度数字字体
    UIFont  *_labelFont;
    // // 进度数字颜色
    UIColor *_labelTextColor;
    
    // // 进度条背景
    UIImageView *_progressBgView;
    // // 进度条
    //CircleView *_progressView;
    // // 进度条前景
    UIImageView *_progressFrontView;
    // // 数字进度
    UILabel     *_progressLabel;
    
    // // 动态进度条参数
    CGFloat _progressTo;
    CGFloat _progressOffset;
    NSTimer *_progressTimer;
    
}

- (id)initWithFrame:(CGRect)frame radius:(CGFloat)radius circleWidth:(CGFloat)circleWidth lineColor:(UIColor *)lineColor;

//-(void)doSetProgressBgView:(UIImage *)progressBgImg;
//-(void)doSetProgressFrontView:(UIImage *)progressFrontImg;
-(void)doSetProgressLabel:(UIFont *)font textColor:(UIColor *)textColor;
-(void)doSetProgressValue:(CGFloat)progress;
-(void)doProgressTo:(float)progress time:(float)time;
@end

@interface CircleView : UIView
{
    // // 圆环的外围半径
    CGFloat _circleRadius;
    // // 环形宽度
    CGFloat _circleWidth;
    // // 进度条进度
    CGFloat _circlePercent;
    // // 环形颜色
    UIColor *_circleColor;
}
@property(nonatomic,assign) CGFloat circleRadius;
@property(nonatomic,assign) CGFloat circleWidth;
@property(nonatomic,assign) CGFloat circlePercent;
@property(nonatomic,retain) UIColor *circleColor;

- (id)initWithRadius:(CGFloat)radius circleWidth:(CGFloat)width circleColor:(UIColor *)color circlePercent:(CGFloat)percent;
@end
