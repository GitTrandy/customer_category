
#ifndef __ActionDefine_h__
#define __ActionDefine_h__

#import "ActionThreadPool.h"
#import "RNTimer.h"

typedef enum _tagCoordinateType
{
    //坐标类型
    
    ECT_X=0,
    ECT_Y,
    ECT_Z,
    ECT_XY,       //只是scale中使用，xy用同一个值
    
}CoordinateType;

#define RepeatForEver    (0)    //循环播放

#ifdef DEBUG
#define AniLog           WLLog
//#define AniLog(...)
#else
#define AniLog(...)

#endif

@protocol actionEventDelegate <NSObject>

-(void)didStart:(id)sender;
-(void)didEnd:(id)sender;

@end

@protocol actionProgressBarDelegate <NSObject>

-(void)didLevelUpWithSender:(id)sender count:(int)count;

@end

#endif //__ActionDefine_h__
