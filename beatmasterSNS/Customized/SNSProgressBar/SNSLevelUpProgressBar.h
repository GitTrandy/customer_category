//
//  SNSSegmentProgressBar.h
//  SNSSegmentProgressBar
//
//  Created by Sunny on 13-11-14.
//  Copyright (c) 2013年 redatoms. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat SNSProgressBarDefaultSpeed; // 1.0f/60.0f

@interface SNSProgressBar : UIView

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIView* progressClipView;
@property (nonatomic, strong) UIImageView* progressImageView;

@property (nonatomic) CGFloat startProgress; // default 0.0f
@property (nonatomic) CGFloat targetProgress; // default 1.0f
@property (nonatomic) CGFloat speed; // 每帧移动长度[0.0f, 1.0f]

- (void)beginAnimationWithFinishBlock:(dispatch_block_t)block;

// 暂停正在播放的动画
- (void)suspendAnimation;
// 恢复正在播放的动画
- (void)resumeAnimation;
    
@end

@interface SNSLevelUpProgressBar : SNSProgressBar

// 大于1则遇到整数个1的时候执行block
- (void)beginAnimationWithLevelUpBlock:(void(^)(NSInteger count, BOOL willFinish))block;

// 执行剩余的动画，若无剩余动画则什么都不做
- (void)continueAnimation;

@end

@interface SNSLevelUpProgressBar (Pet)
// 创建一个宠物升级弹出框内的进度条，已设置图片
+ (instancetype)petLevelUpProgressBar;
@end