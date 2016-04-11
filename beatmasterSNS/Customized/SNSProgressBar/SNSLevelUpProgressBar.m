//
//  SNSSegmentProgressBar.m
//  SNSSegmentProgressBar
//
//  Created by Sunny on 13-11-14.
//  Copyright (c) 2013年 redatoms. All rights reserved.
//

#import "SNSLevelUpProgressBar.h"

CGFloat SNSProgressBarDefaultSpeed = 1.0f / 60.0f;

@interface SNSProgressBar () {
    dispatch_source_t _timerSource;
}
@property (nonatomic) CGFloat currentProgress;
@end

@implementation SNSProgressBar

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.frame = self.bounds;
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundImageView];
    }
    return self->_backgroundImageView;
}

- (UIView *)progressClipView
{
    if (!self->_progressClipView)
    {
        _progressClipView = [UIView new];
        _progressClipView.frame = self.backgroundImageView.bounds;
        _progressClipView.clipsToBounds = YES;
        _progressClipView.contentMode = UIViewContentModeScaleToFill;
        [self.backgroundImageView addSubview:_progressClipView];
    }
    return _progressClipView;
}

- (UIImageView *)progressImageView
{
    if (!_progressImageView)
    {
        _progressImageView = [UIImageView new];
        _progressImageView.frame = self.progressClipView.bounds;
        [self.progressClipView addSubview:_progressImageView];
    }
    return _progressImageView;
}

- (void)setStartProgress:(CGFloat)startProgress
{
    self->_startProgress = MIN(1.0f, MAX(0.0f, startProgress)); // start > 0 && start <１
    self.currentProgress = startProgress;
}

- (void)setCurrentProgress:(CGFloat)currentProgress
{
    self->_currentProgress = currentProgress;
    self.progressClipView.frame = CGRectMake(0, 0, currentProgress/1.0f*CGRectGetWidth(self.backgroundImageView.bounds), CGRectGetHeight(self.backgroundImageView.bounds));
}

- (void)setTargetProgress:(CGFloat)targetProgress
{
    self->_targetProgress = MAX(0.0f, targetProgress); // target > 0
}

- (CGFloat)speed
{
    if (self->_speed <= 0.0f)
    {
        self->_speed = SNSProgressBarDefaultSpeed;
    }
    return self->_speed;
}

- (void)beginAnimationWithFinishBlock:(dispatch_block_t)block
{
    if (self.startProgress >= self.targetProgress)
    {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
        // timer触发间隔，1/60触发一次(纳秒)
        uint64_t nsec = (uint64_t)(1.0/60.0 * NSEC_PER_SEC);
        
        _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        if (_timerSource)
        {
            dispatch_source_set_timer(_timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), nsec, 0);
            
            __weak typeof(self) weakSelf = self;
            dispatch_source_set_event_handler(_timerSource, ^{
                
                if (weakSelf.currentProgress + self.speed > self.targetProgress || weakSelf.currentProgress == 1.0f)
                {
                    dispatch_source_cancel(_timerSource);
                    if (block)
                    {
                        block();
                    }
                }
                else
                {
                    // 更新进度条
                    weakSelf.currentProgress = MIN(weakSelf.currentProgress + self.speed, 1.0f);
                }
                

            });
            dispatch_resume(_timerSource);
        }
    });
}

    
- (void)suspendAnimation
{
    if (_timerSource)
    {
        dispatch_suspend(_timerSource);
    }
}
    
- (void)resumeAnimation
{
    if (_timerSource)
    {
        dispatch_resume(_timerSource);
    }
    
}


- (void)dealloc
{
    _timerSource = nil;
}

@end

@interface SNSLevelUpProgressBar () {
    dispatch_semaphore_t _psema;
    dispatch_queue_t _controlQueue;
}
@end

@implementation SNSLevelUpProgressBar

- (void)beginAnimationWithLevelUpBlock:(void (^)(NSInteger, BOOL))block
{
    self->_controlQueue = dispatch_queue_create("SNSLevelUpProgressBar control queue", DISPATCH_QUEUE_SERIAL);
    NSInteger totalLoopCount = (NSInteger)ceilf(self.targetProgress); // 循环的圈数（上取整）
    
    // 流程控制
    __block CGFloat remainingProgress = self.targetProgress;
    for (int currentLoop = 0; currentLoop < totalLoopCount; currentLoop++)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(self->_controlQueue, ^{
            _psema = dispatch_semaphore_create(0);
            
            // 进行从 startProgress -> remainingProgress的动画
            if (remainingProgress < 1.0f)
            {
                weakSelf.targetProgress = remainingProgress;
                [weakSelf beginAnimationWithFinishBlock:^{
                    block(currentLoop + 1, YES);
                }];
            }
            // 进行从 startProgress -> 1的动画
            else
            {
                weakSelf.targetProgress = 1.0f;
                [weakSelf beginAnimationWithFinishBlock:^{
                    remainingProgress -= 1.0f;
                    block(currentLoop + 1, remainingProgress == 0.0f);
                }];
            }
            
            // 阻塞该线程，等待外部调用continueAnimation
            dispatch_semaphore_wait(_psema, DISPATCH_TIME_FOREVER);
        });
    }
}

- (void)continueAnimation
{
    self.startProgress = 0.0f;
    dispatch_semaphore_signal(_psema);
}

- (void)dealloc
{
    if (self->_controlQueue)
    {
        self->_controlQueue = nil;
    }
    if (self->_psema)
    {
        self->_psema = nil;
    }
}

@end

@implementation SNSLevelUpProgressBar (Pet)

+ (instancetype)petLevelUpProgressBar
{
    SNSLevelUpProgressBar* progressBar = [[SNSLevelUpProgressBar alloc] initWithFrame:CGRectMake(0, 0, 90*SNS_SCALE, 14*SNS_SCALE)];
    progressBar.backgroundImageView.image = [UIImage imageNamed_New:@"pet_levelUpProgressBarBg@2x.png"];
    progressBar.progressImageView.image = [UIImage imageNamed_New:@"pet_levelUpProgressBarFront@2x.png"];
    progressBar.speed = SNSProgressBarDefaultSpeed;
    return progressBar;
}

@end
