//
//  ActionItem.m
//  dlgAni
//
//  Created by wanglei on 12-11-23.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ActionItem.h"

@interface ActionItem ()
@property (nonatomic, retain) RNTimer* rnTimer;
@end

@implementation ActionItem

@synthesize beginTime = _beginTime;
@synthesize actionState = _actionState;
@synthesize delegate = _delegate;

#pragma mark - actionItem init

-(id) init:(int)repeatCount beginTime:(float)beginTime{
    
    if( (self=[super init]) ) {
    
        _beginTime = beginTime;
        _repeatCount = repeatCount;
        
        _actionState = EAS_NONE;
        _delegate = nil;
        
        [self.rnTimer invalidate];
        self.rnTimer = nil;

        _waitActions = [[NSMutableArray alloc] init];
        _runningActions = [[NSMutableArray alloc] init];
        _finishActions = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc{
    
    AniLog(@"ActionItem dealloc");
    
    [self clearActions];
    
    [super dealloc];
}


+(id) actionItemRepeatCount:(int)repeatCount beginTime:(float)beginTime{
    
    return [[[ActionItem alloc] init:repeatCount beginTime:beginTime] autorelease];
}

+(id) actionItemsRepeatCount:(int)repeatCount beginTime:(float)beginTime actionItems:(ActionBase *)action1, ...
{
    
    ActionItem* pRet = [ActionItem actionItemRepeatCount:repeatCount beginTime:beginTime];
    
    va_list params;
	va_start(params,action1);
	
	ActionBase* now = action1;
	
	while( now ) {
        
        [pRet addAction:now];
        
		now = va_arg(params, ActionBase*);
	}
	va_end(params);
    
	return pRet;
    
}

-(void) addAction:(ActionBase *)action{
    assert(action);
    
    if (EAS_Remove==_actionState || EAS_NONE==_actionState)
    {
        [_waitActions addObject:action];
    }
    else
    {
        //已经开始不能添加
        AniLog(@"ActionItem << addAction error %d", _actionState);
    }
}

#pragma mark - start stop

-(void) startAction{
    
    if (EAS_Start == _actionState)
    {
        AniLog(@"startAction error");
        return;
    }
    
    _actionState = EAS_Start;
    
    //开始计时
    //10毫秒一次

    __block ActionItem* weakSelf = self;
    self.rnTimer = [RNTimer repeatingTimerWithTimeInterval:0.02 block:^{
        [weakSelf update];
    }];
    

    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) stopAction{
    
    [self removeTimer];
    
    for (ActionBase* action in _runningActions)
    {
        [action stopAnimation];
    }
    
    _actionState = EAS_Stop;
}

-(void) endAction{
    
    [self removeTimer];
    
    _actionState = EAS_End;
    
    if (nil!=_delegate)
    {
        //通知外面，动画完成
        [_delegate didEnd:self];
    }
}

-(bool) checkActionEnd{
    
    //循环播，不会停止
    if (0==_repeatCount)
    {
        if ([_waitActions count]<=0 && [_runningActions count]<=0)
        {
            for (int i=0; i<[_finishActions count]; i++)
            {
                ActionBase* action = _finishActions[i];
                
                //将完成的重新放入等待中，重新开始
                [_waitActions addObject:action];
            }
            
            //删除完成的
            [_finishActions removeAllObjects];
        }
    }

    //结束
    if ([_waitActions count]<=0 && [_runningActions count]<=0)
        return true;
    
    //没有结束
    return false;
}

-(void) update{
    
    if (EAS_Start == _actionState)
    {
        if ([self checkActionEnd])
        {
            [self endAction];
            return;
        }
        
        //运行
        if ([_runningActions count]>0)
        {
            //一次只能运行一个， _runningActions用arr是为了扩展，
            ActionBase* action = _runningActions[0];
            
            //执行特殊操作
            [action update];
        }
        
        //结束
        for (int i=0; i<[_runningActions count]; i++)
        {
            ActionBase* action = _runningActions[i];
            if (action.actionState==EAS_End)
            {
                AniLog(@"actionitem << finish type=%d", action.actionType);
                
                //移动到完成中
                [_finishActions addObject:action];
                
                //从运行中删除
                [_runningActions removeObject:action];
                i--;
            }
        }
        
        //开始
        if ([_runningActions count]<=0 && [_waitActions count]>0)
        {
            //一次只能运行一个， _runningActions用arr是为了扩展，
            ActionBase* action = _waitActions[0];

            [action startAnimation];
            
            //移动到运行中
            [_runningActions addObject:action];
            
            //从等待中删除
            [_waitActions removeObject:action];
        }
        
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

-(void) removeWaitActions{
    
    if (nil!=_waitActions)
    {
        for (ActionBase* action in _waitActions)
        {
            [action removeAction];
        }
        
        //删除队列
        [_waitActions removeAllObjects];
    }
}

-(void) removeRunningActions{
    
    if (nil!=_runningActions)
    {
        for (ActionBase* action in _runningActions)
        {
            [action removeAction];
        }
        
        //删除队列
        [_runningActions removeAllObjects];
    }
}

-(void) removeFinishActions{
    
    if (nil!=_finishActions)
    {
        for (ActionBase* action in _finishActions)
        {
            [action removeAction];
        }
        
        //删除队列
        [_finishActions removeAllObjects];
    }
}

-(void) removeActions{
    
    _actionState = EAS_Remove;
    
    //停掉time
    [self removeTimer];
    
    //删除数据
    [self removeWaitActions];
    [self removeRunningActions];
    [self removeFinishActions];
}

-(void) removeDelegate{
    
    //删除代理
    _delegate = nil;
}

-(void) clearWaitActions{
    
    if (nil!=_waitActions)
    {
        for (ActionBase* action in _waitActions)
        {
            [action clearAction];
        }
        
        //删除队列
        [_waitActions removeAllObjects];
        [_waitActions release];
        _waitActions = nil;
    }
}

-(void) clearRunningActions{
    
    if (nil!=_runningActions)
    {
        for (ActionBase* action in _runningActions)
        {
            [action clearAction];
        }
        
        //删除队列
        [_runningActions removeAllObjects];
        [_runningActions release];
        _runningActions = nil;
    }
}

-(void) clearFinishActions{
    
    if (nil!=_finishActions)
    {
        for (ActionBase* action in _finishActions)
        {
            [action clearAction];
        }
        
        //删除队列
        [_finishActions removeAllObjects];
        [_finishActions release];
        _finishActions = nil;
    }
}

-(void) clearActions{
    
    _actionState = EAS_Clear;
    
    [self removeDelegate];
    
    //停掉time
    [self removeTimer];
    
    //删除数据
    [self clearWaitActions];
    [self clearRunningActions];
    [self clearFinishActions];
}


@end
