//
//  CountDownTimer.h
//  beatmasterSNS
//
//  Created by chengsong on 13-11-7.
//
//

#import <UIKit/UIKit.h>
#import "CSTextView.h"
typedef void (^ProgressBlock)(CGFloat remainder, BOOL timeOver);
typedef enum
{
    TimerFormatStyleS = 0,     // // 秒表   ss
    TimerFormatStyleMS,        // // 分秒   mm : ss
    TimerFormatStyleHMS,       // // 时分秒 hh : mm : ss
    TimerFormatStyleDefault = TimerFormatStyleS
}TimerFormatStyle;

//**************************//
//        倒计时小控件        //
//       提供三种显示格式      //
//**************************//
@interface CountDownTimer : CSTextView

// // 倒计时格式
@property(nonatomic,assign)TimerFormatStyle formatStyle;

// // 倒计时最大时间(秒数)
@property(nonatomic,assign)NSInteger    maxSecs;

// // 和服务器的误差时间，正数代表比服务器慢(秒数)
@property(nonatomic,assign)NSInteger    offsetSecs;

// // 计算倒计时的基准时间(时间秒)
@property(nonatomic,assign)double       baseTime;

// // 是否倒计时完成
@property(nonatomic,assign)BOOL         isTimeOver;

/*
 *  @brief: 初始化，参数含义参看属性
 */
- (id)initWithFrame:(CGRect)frame baseTime:(double)baseTime maxSecs:(NSInteger)maxSecs style:(TimerFormatStyle)style progress:(ProgressBlock)block;

/*
 *  @brief: 开始倒计时，只有调用这个函数之后才倒计时
 */
-(void)startTimer;

@end
