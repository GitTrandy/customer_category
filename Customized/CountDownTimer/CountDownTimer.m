//
//  CountDownTimer.m
//  beatmasterSNS
//
//  Created by chengsong on 13-11-7.
//
//

#import "CountDownTimer.h"

@interface CountDownTimer ()

@property(nonatomic,copy)ProgressBlock  block;
@property(nonatomic,strong)RNTimer      *scheduleTimer;
@property(nonatomic,assign)NSInteger    remainderSecs;

@end
@implementation CountDownTimer

- (id)initWithFrame:(CGRect)frame baseTime:(double)baseTime maxSecs:(NSInteger)maxSecs style:(TimerFormatStyle)style progress:(ProgressBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self countDownTimerVariablesInit];
        self.baseTime = baseTime;
        self.maxSecs = maxSecs;
        self.formatStyle = style;
        self.block = block;
    }
    return self;
}

-(void)dealloc
{
    self.block = nil;
    if (self.scheduleTimer != nil)
    {
        [self.scheduleTimer invalidate];
        self.scheduleTimer = nil;
    }
}

-(void)countDownTimerVariablesInit
{
    self.formatStyle = TimerFormatStyleDefault;
    self.maxSecs = 0;
    self.offsetSecs = 0;
    self.baseTime = 0.0;
    self.isTimeOver = NO;
}

#pragma mark - private methods

/*
 *  @brief: 获取Now的服务器时间，计算上给定的误差偏移量
 */
-(double)calcNowTime
{
    // // 获取服务端当前的系统时间
    NSDate *serverDate = (NSDate *)[[NetworkManager shareNetworkManager] generateLocalDateTime];
    // // 得到比服务端慢一点的当前时间
    double curTime = [serverDate timeIntervalSince1970] - self.offsetSecs;
    return curTime;
}

/*
 *  @brief: 刷新函数
 */
-(void)updateTimerNums
{
    NSString *timeStr = nil;
    _remainderSecs--;
    
    if (_remainderSecs <= 0)
    {
        // // 倒计时完成
        [self.scheduleTimer invalidate];
        self.scheduleTimer = nil;
        self.isTimeOver = YES;
    }
    switch (self.formatStyle)
    {
        case TimerFormatStyleS:
            // // SS
        {
            timeStr = [NSString stringWithFormat:@"%02d",self.remainderSecs];
        }
            break;
        case TimerFormatStyleMS:
            // // mm : ss
        {
            int secNum = (int)self.remainderSecs % 60;
            int minNum = (int)(self.remainderSecs / 60);
            timeStr = [NSString stringWithFormat:@"%02d : %02d",minNum,secNum];
        }
            break;
        case TimerFormatStyleHMS:
            // // hh : mm : ss
        {
            int sec = (int)self.remainderSecs % 60;
            int minCount = (int)(self.remainderSecs / 60);
            int min = minCount % 60;
            int hour = (int)(minCount / 60);
            timeStr = [NSString stringWithFormat:@"%02d : %02d : %02d",hour,min,sec];
            
        }
            break;
            
        default:
            break;
    }
    if (timeStr != nil)
    {
        // // 更新显示
        self.originalString = timeStr;
        if (self.block)
        {
            CGFloat remainder = self.remainderSecs * 1.0f / self.maxSecs;
            self.block(remainder,self.isTimeOver);
        }
    }
}

/*
 *  @brief: 外面调用，开始倒计时
 */
-(void)startTimer
{
    double nowSecs = [self calcNowTime];
    self.remainderSecs = self.baseTime + self.maxSecs - nowSecs;
    self.isTimeOver = NO;
    
    // // scheduleTimer过时间间隔前，0秒时刻显示
    self.remainderSecs += 1;
    [self updateTimerNums];
    
    // // 开始倒计时
    __weak typeof(self) weakSelf = self;
    if (self.scheduleTimer != nil)
    {
        [self.scheduleTimer invalidate];
    }
    self.scheduleTimer = [RNTimer repeatingTimerWithTimeInterval:1.0f block:^{
        [weakSelf updateTimerNums];
    }];
    
}


@end
