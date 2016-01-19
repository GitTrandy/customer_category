//
//  NSDateHelper.h
//  figurePlayer
//
//  Created by zhiying_redatoms on 12-11-5.
//
//

#import <Foundation/Foundation.h>

// Note: 存储数据时要用全格式，显示时可根据需要修改显示格式
#define GlobleDateFormat @"yyyy-MM-dd HH:mm:ss z"

typedef enum _localPushDayFromNowIndex
{
    L_PUSH_STAMINA     = 0,
    L_PUSH_NEXT_1_DAY  = 1,
    L_PUSH_NEXT_3_DAY  = 3,
    L_PUSH_NEXT_7_DAY  = 7,
    L_PUSH_NEXT_14_DAY = 14,
    L_PUSH_NEXT_30_DAY = 30,
}DAYINDEXOFLOCALPUSHTYPE;

@class CommodityInfo;

@interface NSDate (Helper)

+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)dateFromString:(NSString*)string;
+(NSString*)stringForDisplayFromDate:(NSDate*)date;
+(NSString*)stringForDisplayFromTimeInterval:(NSTimeInterval)interval;
+(BOOL)isDateInSameGroup:(NSDate*)date1 andDate:(NSDate*)date2;
+(BOOL)isDateIntervalInSameGroup:(NSTimeInterval)interval1 andDate:(NSTimeInterval)interval2;
+(NSString*)stringForRemainderTimeForDay:(NSDate*)date;

//liuwang
+(NSString*)stringForRemainderTime:(NSDate*)date commodityInfo:(CommodityInfo*)commodityInfo;

// // return isShow array
+(NSArray *)isShowArrayFromTimeArray:(NSArray *)timeArray;

+(void)caculateOffTime:(NSInteger *)yearOff daytime:(NSInteger *)dayoff destTimeInterval:(NSTimeInterval)interval;

// For Local Push Notifications
+(NSDate *)nextNdayAt18PM:(DAYINDEXOFLOCALPUSHTYPE)nDay;

//比较两个时间是否是同一天
+(BOOL) isSameDay:(NSDate *)date1 nextTime:(NSDate *)date2;
@end
