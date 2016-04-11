//
//  ActionItem.h
//  dlgAni
//
//  Created by wanglei on 12-11-23.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionBase.h"

@interface ActionItem : NSObject{
    
    float           _beginTime;        //串行开始时间，相对于一个时间轴
    int             _repeatCount;      //串行动作的重复次数,0循环播
    
    NSMutableArray* _waitActions;      //串行的action队列,每次播放第0个，播放完删除
    NSMutableArray* _runningActions;
    NSMutableArray* _finishActions;
    
    ActionState     _actionState;      //状态

    id<actionEventDelegate> _delegate;
}

+(id) actionItemRepeatCount:(int)repeatCount beginTime:(float)beginTime;
+(id) actionItemsRepeatCount:(int)repeatCount beginTime:(float)beginTime actionItems:(ActionBase*)action1, ... NS_REQUIRES_NIL_TERMINATION;

-(id) init:(int)repeatCount beginTime:(float)beginTime;

-(void) addAction:(ActionBase*)action;

-(void) startAction;
-(void) stopAction;

-(void) clearActions;
-(void) removeActions;
-(void) removeDelegate;

@property (nonatomic,assign) float beginTime;
@property (nonatomic,assign) ActionState actionState;
@property (nonatomic,assign) id<actionEventDelegate> delegate;

@end
