//
//  CTLog.m
//  circle_iphone
//
//  Created by Andrew on 15/11/30.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "CTLog.h"

@implementation CTLog

+(instancetype)defaultCTLog
{
    static CTLog *ctlog=nil;
    static dispatch_once_t once_log;
    dispatch_once(&once_log, ^{
        ctlog=[CTLog new];
        [ctlog InitArray];
    });
    return ctlog;
}

-(void)InitArray
{
    _owners=[NSMutableArray array];
    [_owners addObject:[NSNumber numberWithInteger:Log_All]];
}

/** 只显示该开发者的调试日志 */
-(void)setLogOwner:(LogOwner)owner
{
    [_owners removeAllObjects];
    [_owners addObject:[NSNumber numberWithInteger:owner]];
}

@end
