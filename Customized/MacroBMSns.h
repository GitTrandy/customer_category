//
//  MacroBMSns.h
//  beatmasterSNS
//
//  Created by TangShiChao on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef beatmasterSNS_MacroBMSns_h
#define beatmasterSNS_MacroBMSns_h

#import <Foundation/Foundation.h>
#import <assert.h>

//  输出宏
#ifdef DEBUG

#define BMNSLog TSCLog

#else

#define BMNSLog(...)

#endif

// 断言宏
#ifdef DEBUG

#define BMCCAssert(cond, msg)      assert(cond)

#else

#define BMCCAssert(...)

#endif



// DBWork class log
#define DBWrok_Log


/// end
#endif
