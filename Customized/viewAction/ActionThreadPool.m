//
//  ActionThreadPool.m
//  beatmasterSNS
//
//  Created by wanglei on 12-12-20.
//
//

#import "ActionThreadPool.h"
#import "ActionCommon.h"

@implementation threadOperatorItem

@synthesize target = _target;
@synthesize callBack = _callback;
@synthesize param = _param;

-(id) initWithTarget:(id)target callback:(SEL)callback param:(id)param{
    
    if (self = [super init])
    {
        _target = target;
        _callback = callback;
        _param = param;
    }
    return self;
}

-(void) dealloc{
    
    [super dealloc];
}

+(threadOperatorItem*) threadOperatorItemWithTarget:(id)target callback:(SEL)callback param:(id)param{
    
    return [[[threadOperatorItem alloc] initWithTarget:target callback:callback param:param] autorelease];
}

-(void) executeOperator{
    
    if (nil!=_target && nil!=_callback)
    {
        [_target performSelector:_callback withObject:_param];
        //AniLog(@"executeOperator");
    }
}

@end

@implementation ActionThreadPool

-(id) init{
    
    if (self=[super init])
    {
        _operatorDic = [[NSMutableDictionary alloc] init];
        _updateThread = nil;
    }
    
    return self;
}

-(void) dealloc{
    
    [_operatorDic removeAllObjects];
    [_operatorDic release];
    
    [super dealloc];
}

static ActionThreadPool* g_ActionThreadPool = nil;
+(ActionThreadPool*) shareActionThreadPool{
    
    if (nil!=g_ActionThreadPool)
        return g_ActionThreadPool;
    
    @synchronized(self){
        
        if (nil==g_ActionThreadPool)
        {
            g_ActionThreadPool = [[ActionThreadPool alloc] init];
        }
        
        return g_ActionThreadPool;
    }
}

+(void) purgeActionThreadPool{
    
    @synchronized(self){
        
        //因为启动线程时g_ActionThreadPool的引用计数加1就是2，release后不会被删除，等线程退出后就可以删除了
        [g_ActionThreadPool stopThread];
        [g_ActionThreadPool release];
        g_ActionThreadPool = nil;
    }
    
}

-(void) threadRunLoop{
    
    @autoreleasepool
    {
        while (1)
        {
            if ([[NSThread currentThread] isCancelled])
            {
                break;
            }
            
            @synchronized(self)
            {
                if ([_operatorDic count]>0)
                {
                    //struct timeval last;
                    //gettimeofday(&last, NULL);
                    for (threadOperatorItem* item in [_operatorDic allValues])
                    {
                        //执行动作
                        [item executeOperator];
                    }
                    
                    //AniLog(@"%f", [ActionCommon getTickCount:&last]);
                }
            }
            
            usleep(10000);   //10毫秒
        }
    }
}

-(void) startThread{
    
    AniLog(@"startThread << %d", [self retainCount]);
    _updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRunLoop) object:nil];
    AniLog(@"startThread << %d", [self retainCount]);
    [_updateThread start];
}

-(void) stopThread{
    
    [_updateThread cancel];
}

-(void) addThreadObserverWithName:(NSString *)name target:(id)target callback:(SEL)callback param:(id)param{
    
    @synchronized(self)
    {
        threadOperatorItem* item = [threadOperatorItem threadOperatorItemWithTarget:target callback:callback param:param];
        
        _operatorDic[name] = item;
    }
}

-(void) removeThreadObserverWithName:(NSString *)name{
    
    @synchronized(self)
    {
        [_operatorDic removeObjectForKey:name];
    }
}

@end
