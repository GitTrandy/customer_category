//
//  NSDateHelper.m
//  figurePlayer
//
//  Created by zhiying_redatoms on 12-11-5.
//
//

#import "NSDateHelper.h"
#import "CommodityInfo.h"

@implementation NSDate (Helper)

+(NSDate*)dateFromString:(NSString*)string
{
    NSDateFormatter* inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:GlobleDateFormat];
	NSDate* date = [inputFormatter dateFromString:string];
	[inputFormatter release];
    
	return date;
}

+(NSString*)stringFromDate:(NSDate*)date
{
	NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:GlobleDateFormat];
	NSString* timestamp_str = [outputFormatter stringFromDate:date];
	[outputFormatter release];
	return timestamp_str;
}


/*
 根据输入的时间date生成相应格式的字符串，供显示使用
 显示格式由date与当前时间的间隔决定：
 24小时内：时间点（24小时制）
 24－48小时：昨天＋时间点
 48－72小时：前天＋时间点
 >72小时，在同一年内：月＋日＋时间点
 不在同一年内：年＋月＋日＋时间点
 */
+(NSString*)stringForDisplayFromDate:(NSDate*)date
{
    NSString* displayString = @"";
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter* displayFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
#if 0
    // 此方法计算的dayOff不准确，改用新的方法
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponents = [calendar components:(NSYearCalendarUnit | NSDayCalendarUnit) fromDate:date toDate:currentDate options:0];
    NSDateFormatter* displayFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSInteger dayOff = [offsetComponents day];
    NSInteger yearOff = [offsetComponents year];
#endif
    
    [displayFormatter setDateFormat:@"y"];
    NSInteger yearOff = [[displayFormatter stringFromDate:currentDate] intValue] - [[displayFormatter stringFromDate:date] intValue];
    [displayFormatter setDateFormat:@"D"];
    NSInteger dayOff = [[displayFormatter stringFromDate:currentDate] intValue] - [[displayFormatter stringFromDate:date] intValue];
    
    if (yearOff < 1)
    {
        [displayFormatter setDateFormat:@"HH:mm"];
        NSString* timeString = [displayFormatter stringFromDate:date];
        if (dayOff < 1)
        {
            displayString = timeString;
        }
        else if (1 == dayOff)
        {
            displayString = [NSString stringWithFormat:@"%@ %@", MultiLanguage(dhNYesterday),timeString];
        }
        else if (2 == dayOff)
        {
            displayString = [NSString stringWithFormat:@"%@ %@", MultiLanguage(dhNBeforeYesterday),timeString];
        }
        else
        {
            [displayFormatter setDateFormat:@"MM-dd HH:mm"];
            displayString = [displayFormatter stringFromDate:date];
        }
    }
    else
    {
        [displayFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        displayString = [displayFormatter stringFromDate:date];
    }    
    
    return displayString;
}

/*
 直接根据时间间隔生成显示字符串
 */
+(NSString*)stringForDisplayFromTimeInterval:(NSTimeInterval)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self stringForDisplayFromDate:date];
}

+ (void)caculateOffTime:(NSInteger *)yearOff daytime:(NSInteger *)dayoff destTimeInterval:(NSTimeInterval)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDate* currentDate = /*[NSDate date]*/[[DataManager shareDataManager].localNetworkManager generateLocalDateTime];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponents = [calendar components:(NSYearCalendarUnit | NSDayCalendarUnit) fromDate:date toDate:currentDate options:0];
    
    *dayoff = [offsetComponents day];
    *yearOff = [offsetComponents year];
}


/*
 若2个时间值在10分钟以内，则认为在同一组
 */
+(BOOL)isDateInSameGroup:(NSDate*)date1 andDate:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponent = [calendar components:(NSMinuteCalendarUnit) fromDate:date1 toDate:date2 options:0];
    
    return (fabs([offsetComponent minute]) < 10.f);
}

+(BOOL)isDateIntervalInSameGroup:(NSTimeInterval)interval1 andDate:(NSTimeInterval)interval2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:interval1];
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:interval2];
    NSDateComponents* offsetComponent = [calendar components:(NSMinuteCalendarUnit) fromDate:date1 toDate:date2 options:0];
    
    return (fabs([offsetComponent minute]) < 10.f);
}

//liuwang
//根据输入的时间 返回物品的剩余时间
+(NSString*)stringForRemainderTime:(NSDate*)date commodityInfo:(CommodityInfo*)commodityInfo
{
    NSString* displayString = @"";
    NSDate* currentDate = /*[NSDate date]*/[[DataManager shareDataManager].localNetworkManager generateLocalDateTime];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponents = [calendar components:(NSYearCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit) fromDate:currentDate toDate:date options:0];
    
    NSInteger minuteOff = [offsetComponents minute];
    NSInteger hourOff = [offsetComponents hour];
    NSInteger dayOff = [offsetComponents day];
    NSInteger yearOff = [offsetComponents year];
    
    if (yearOff>0)
    {
        if (commodityInfo)
        {
            if (ECT_SNOOPY==commodityInfo.firstType && 2==commodityInfo.secondType)
            {
                //羽翼年超过1年就是永久
                displayString = MultiLanguage(dhNForever);
            }
            else
            {
                if (yearOff>10)
                {
                    displayString = MultiLanguage(dhNForever);
                }
            }
        }
        else
        {
            displayString = MultiLanguage(dhNOverYear);
        }
    }
    else if(dayOff>0)
    {
        displayString = [NSString stringWithFormat:@"%@%d%@%d%@",MultiLanguage(dhNRemainder),dayOff,MultiLanguage(dhNDay),hourOff,MultiLanguage(dhNHour)];
    }
    else if (hourOff>0)
    {
        displayString = [NSString stringWithFormat:@"%@%d%@%d%@",MultiLanguage(dhNRemainder),hourOff,MultiLanguage(dhNHour),minuteOff,MultiLanguage(dhNMinute)];
    }
    else
    {
        if (minuteOff<=0)
        {
            //如果小于1分钟时，显示1分钟
            minuteOff = 1;
        }
        
        displayString = [NSString stringWithFormat:@"%@%d%@",MultiLanguage(dhNRemainder),minuteOff,MultiLanguage(dhNMinute)];
    }
    
    return displayString;
}

//根据输入的时间 返回物品的剩余时间,只返回天数
+(NSString*)stringForRemainderTimeForDay:(NSDate*)date
{
    NSString* displayString = @"";
    NSDate* currentDate = /*[NSDate date]*/[[DataManager shareDataManager].localNetworkManager generateLocalDateTime];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponents = [calendar components:(NSYearCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit) fromDate:currentDate toDate:date options:0];
    
    NSInteger dayOff = [offsetComponents day];
    NSInteger yearOff = [offsetComponents year];
    
    if (dayOff==0 && yearOff < 1)
    {
        dayOff = 1;
    }

    displayString = [NSString stringWithFormat:@"%@%d%@",MultiLanguage(dhNRemainder),dayOff + 365 * yearOff,MultiLanguage(dhNDay)];
    return displayString;
    
}

/*
 *  @brief: 通过时间数组，返回是否显示数组
 */
+(NSArray *)isShowArrayFromTimeArray:(NSArray *)timeArray
{
    if (timeArray == nil || [timeArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *showArr = [NSMutableArray array];
    int timeCount = [timeArray count];
    double lastShowTime = [timeArray[0] doubleValue];
    double currentShowTime = 0;
    for (int i=0; i<timeCount; i++)
    {
        if (i == 0)
        {
            [showArr addObject:@YES];
        }
        else
        {
            currentShowTime = [timeArray[i] doubleValue];
            //if (![self isDateIntervalInSameGroup:lastShowTime andDate:currentShowTime] )
            if((int)lastShowTime - (int)currentShowTime >= 600)
            {
                [showArr addObject:@YES];
                lastShowTime = currentShowTime;
            }
            else
            {
                [showArr addObject:@NO];
            }
        }
    }

    return showArr;

}

/*
 *  @brief: 返回N天后指定时间（20：00）的NSDate对象
 */
+ (NSDate *)nextNdayAt18PM:(DAYINDEXOFLOCALPUSHTYPE)nDay
{
    if (nDay != L_PUSH_NEXT_1_DAY &&
        nDay != L_PUSH_NEXT_3_DAY &&
        nDay != L_PUSH_NEXT_7_DAY &&
        nDay != L_PUSH_NEXT_14_DAY &&
        nDay != L_PUSH_NEXT_30_DAY)
    {
        return nil;
    }
    
    // Get current date
    NSDate *now = [NSDate date];
    
    NSDateComponents *nextNdayComponents = [[NSDateComponents new] autorelease];
    nextNdayComponents.day = nDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nDayDate = [calendar dateByAddingComponents:nextNdayComponents toDate:now options:0];
    
    NSDateComponents *nextNdayComponentsAt18PM = [calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                             fromDate:nDayDate];
    nextNdayComponentsAt18PM.hour = 20;
    NSDate *nextNdayAt18PM = [calendar dateFromComponents:nextNdayComponentsAt18PM];
    
    return nextNdayAt18PM;
}

+(BOOL) isSameDay:(NSDate *)date1 nextTime:(NSDate *)date2
{
    BOOL isSameDay = NO;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *commoe = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth |kCFCalendarUnitDay) fromDate:date1];
    NSDateComponents *commoe2 = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth |kCFCalendarUnitDay) fromDate:date2];
    
    if ([commoe year] == [commoe2 year] && [commoe month] == [commoe2 month] && [commoe day] == [commoe2 day]) {
        isSameDay = YES;
    }
    
    return isSameDay;
}

@end
