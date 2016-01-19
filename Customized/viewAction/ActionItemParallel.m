//
//  ActionItemParallel.m
//  dlgAni
//
//  Created by wanglei on 12-11-26.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ActionItemParallel.h"
#import "ActionCommon.h"

@interface ActionItemParallel ()
@property (nonatomic, retain) RNTimer* rnTimer;
@end

@implementation ActionItemParallel

-(id) init:(id<actionEventDelegate>)delegate{
    
    if( (self=[super init]) ) {
        
        _state = EAS_NONE;
        _waitActions = [[NSMutableArray alloc] init];
        _finishActions = [[NSMutableArray alloc] init];
        _runningActions = [[NSMutableArray alloc] init];
        
        _startTime.tv_sec = 0;
        _startTime.tv_usec = 0;

        _delegate = delegate;
	}
	return self;
    
}

-(void) dealloc{
    
    AniLog(@"ActionItemParallel dealloc");
    
    [self clearActionItems];
    
    [super dealloc];
}

+(id) actionItemParallel{
    
    return [[[ActionItemParallel alloc] init:nil] autorelease];
}

+(id) actionItemParallelWithDelegate:(id<actionEventDelegate>)delegate{
    
    return [[[ActionItemParallel alloc] init:delegate] autorelease];
}

+(id) actionItemParallelsWithDelegate:(id<actionEventDelegate>)delegate actionItems:(ActionItem *)actionItem1, ...{
    
    ActionItemParallel* pRet = [ActionItemParallel actionItemParallelWithDelegate:delegate];
    
    va_list params;
	va_start(params,actionItem1);
	
	ActionItem* now = actionItem1;
	
	while( now ) {
        
        [pRet addActionItem:now];
        
		now = va_arg(params, ActionItem*);
	}
	va_end(params);
    
    return pRet;
}

+(id) actionItemParallels:(ActionItem *)actionItem1, ...
{
    ActionItemParallel* pRet = [ActionItemParallel actionItemParallel];
    
    va_list params;
	va_start(params,actionItem1);
	
	ActionItem* now = actionItem1;
	
	while( now ) {
        
        [pRet addActionItem:now];
        
		now = va_arg(params, ActionItem*);
	}
	va_end(params);
    
    return pRet;
}

-(void) addActionItems:(ActionItem *)actionItem1, ...
{
    va_list params;
	va_start(params,actionItem1);
	
	ActionItem* now = actionItem1;
	
	while( now ) {
        
        [self addActionItem:now];
        
		now = va_arg(params, ActionItem*);
	}
	va_end(params);
}

-(void) addActionItem:(ActionItem *)actionItem{
    assert(actionItem);
    
    if (EAS_NONE==_state || EAS_Remove==_state)
    {
        [_waitActions addObject:actionItem];
    }
    else
    {
        //已经开始不能添加
        AniLog(@"ActionItemParallel << addActionItem error %d", _state);
    }
}

#pragma mark - start end remove

-(void) startActionItems{
    
    if ([_waitActions count]<=0)
    {
        AniLog(@"startActionItems error waitActions=%d", [_waitActions count]);
        return;
    }
    
    if (EAS_Start == _state)
    {
        AniLog(@"startActionItems error");
        return;
    }
    
    _state = EAS_Start;
    
    //开始计时
    //10毫秒一次

    __block ActionItemParallel* weakSelf = self;
    self.rnTimer = [RNTimer repeatingTimerWithTimeInterval:0.02 block:^{
        [weakSelf update];
    }];

    
    //通知结束
    if(nil!=_delegate)
    {
        [_delegate didStart:self];
    }
    
    gettimeofday(&_startTime, NULL);
}

-(void) stopActionItems{
    
    _state = EAS_Stop;
    
    [self removeTimer];
    
    for (ActionItem* item in _runningActions)
    {
        [item stopAction];
    }
}

-(void) endActionItem{
    
    _state = EAS_End;
    
    [self removeTimer];
    
    //通知结束
    if(nil!=_delegate)
    {
        [_delegate didEnd:self];
    }
}

#pragma mark - remove

-(void) removeTimer{

    if (nil != self.rnTimer)
    {
        [self.rnTimer invalidate];
        self.rnTimer = nil;
    }

}

-(void) removeWaitActionitems{
    
    if (nil!=_waitActions)
    {
        for (ActionItem* item in _waitActions)
        {
            [item removeActions];
        }
        
        //删除队列
        [_waitActions removeAllObjects];
    }
}

-(void) removeRunningActionitems{
    
    if (nil!=_runningActions)
    {
        for (ActionItem* item in _runningActions)
        {
            [item removeActions];
        }
        
        //删除队列
        [_runningActions removeAllObjects];
    }
}

-(void) removeFinishActionitems{
    
    if (nil!=_finishActions)
    {
        for (ActionItem* item in _finishActions)
        {
            [item removeActions];
        }
        
        //删除队列
        [_finishActions removeAllObjects];
    }
}

-(void) removeActionItems{
    
    _state = EAS_Remove;
    
    [self removeTimer];
    
    [self removeWaitActionitems];
    [self removeRunningActionitems];
    [self removeFinishActionitems];
    
}

-(void) removeActionItemParallelDelegate{
    
    _delegate = nil;
}

-(void) clearWaitActionitems{
    
    if (nil!=_waitActions)
    {
        for (ActionItem* item in _waitActions)
        {
            [item clearActions];
        }
        
        //删除队列
        [_waitActions removeAllObjects];
        [_waitActions release];
        _waitActions = nil;
    }
}

-(void) clearRunningActionitems{
    
    if (nil!=_runningActions)
    {
        for (ActionItem* item in _runningActions)
        {
            [item clearActions];
        }
        
        //删除队列
        [_runningActions removeAllObjects];
        [_runningActions release];
        _runningActions = nil;
    }
}

-(void) clearFinishActionitems{
    
    if (nil!=_finishActions)
    {
        for (ActionItem* item in _finishActions)
        {
            [item clearActions];
        }
        
        //删除队列
        [_finishActions removeAllObjects];
        [_finishActions release];
        _finishActions = nil;
    }
}

-(void) clearActionItems{
    
    _state = EAS_Clear;
    
    [self removeTimer];
    [self removeActionItemParallelDelegate];
    
    [self clearWaitActionitems];
    [self clearRunningActionitems];
    [self clearFinishActionitems];
}

#pragma mark - update

-(void) update{
    
    if (EAS_Start == _state)
    {
        if ([_waitActions count]<=0 && [_runningActions count]<=0)
        {
            //结束
            [self endActionItem];
            return;
        }
        
        
        //开始Action
        
        //得到运行时间
        float time = [ActionCommon getTickCount:&_startTime];
        for (int i=0; i<[_waitActions count]; i++)
        {
            ActionItem* actionItem = _waitActions[i];
            if (actionItem.actionState==EAS_NONE && actionItem.beginTime <= time)
            {
                AniLog(@"ActionItemParallel << time=%f beginTime=%f", time, actionItem.beginTime);
                [actionItem startAction];
                
                //移动到运行中
                [_runningActions addObject:actionItem];
                
                //从等待中删除
                [_waitActions removeObject:actionItem];
                i--;
            }
        }
        
        
        //完成
        for (int i=0; i<[_runningActions count]; i++)
        {
            ActionItem* actionItem = _runningActions[i];
            if (actionItem.actionState==EAS_End)
            {
                AniLog(@"ActionItemParallel << finish beginTime=%lf", actionItem.beginTime);
                
                //移动到完成中
                [_finishActions addObject:actionItem];
                
                //从运行中删除
                [_runningActions removeObject:actionItem];
                i--;
            }
        }
    }
}


@end
