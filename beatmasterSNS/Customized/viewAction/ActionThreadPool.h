//
//  ActionThreadPool.h
//  beatmasterSNS
//
//  Created by wanglei on 12-12-20.
//
//

#import <UIKit/UIKit.h>
#import "ActionDefine.h"

@interface threadOperatorItem : NSObject{
    
    id      _target;
    SEL     _callback;
    id      _param;
}

-(id) initWithTarget:(id)target callback:(SEL)callback param:(id)param;
+(threadOperatorItem*) threadOperatorItemWithTarget:(id)target callback:(SEL)callback param:(id)param;

-(void) executeOperator;

@property (nonatomic, assign) id  target;
@property (nonatomic, assign) SEL callBack;
@property (nonatomic, assign) id  param;

@end

@interface ActionThreadPool : NSObject{
    
    NSMutableDictionary*  _operatorDic;
    
    NSThread*             _updateThread;
}

-(id) init;

+(ActionThreadPool*) shareActionThreadPool;
+(void) purgeActionThreadPool;

-(void) startThread;
-(void) stopThread;

-(void) addThreadObserverWithName:(NSString*)name target:(id)target callback:(SEL)callback param:(id)param;
-(void) removeThreadObserverWithName:(NSString*)name;

@end
