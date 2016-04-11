//
//  ActionCommon.m
//  dlgAni
//
//  Created by wanglei on 12-12-10.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ActionCommon.h"
#import "ActionDefine.h"

@implementation ActionCommon

+(float) getTickCount:(struct timeval*)lastTime{
    struct timeval now;
    
    float dt = 0.f;
    
	if( gettimeofday( &now, NULL) != 0 ) {
        
        AniLog(@"getTickCount << gettimeofday error");
		return 0;
	}
    
    dt = (now.tv_sec - lastTime->tv_sec) + (now.tv_usec - lastTime->tv_usec) / 1000000.0f;
    
    if (dt<=0.f)
    {
        dt = 0.f;
    }
    
    //返回毫秒值
    return dt;
}

@end
