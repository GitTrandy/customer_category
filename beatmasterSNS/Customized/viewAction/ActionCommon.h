//
//  ActionCommon.h
//  dlgAni
//
//  Created by wanglei on 12-12-10.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/time.h>

@interface ActionCommon : NSObject

+(float) getTickCount:(struct timeval*)lastTime;

@end
