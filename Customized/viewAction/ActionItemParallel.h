//
//  ActionItemParallel.h
//  dlgAni
//
//  Created by wanglei on 12-11-26.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionItem.h"

@interface ActionItemParallel : NSObject{
    
    NSMutableArray*     _waitActions;
    NSMutableArray*     _runningActions;
    NSMutableArray*     _finishActions;
    
    ActionState         _state;             //状态

    struct timeval      _startTime;
    
    id<actionEventDelegate> _delegate;
}

+(id) actionItemParallel;
+(id) actionItemParallels:(ActionItem*)actionItem1, ...NS_REQUIRES_NIL_TERMINATION;

+(id) actionItemParallelWithDelegate:(id<actionEventDelegate>)delegate;
+(id) actionItemParallelsWithDelegate:(id<actionEventDelegate>)delegate actionItems:(ActionItem*)actionItem1, ...NS_REQUIRES_NIL_TERMINATION;

-(id) init:(id<actionEventDelegate>)delegate;

-(void) addActionItem:(ActionItem*)actionItem;
-(void) addActionItems:(ActionItem *)actionItem1, ...NS_REQUIRES_NIL_TERMINATION;

-(void) startActionItems;
-(void) stopActionItems;
-(void) clearActionItems;
-(void) removeActionItems;
-(void) removeActionItemParallelDelegate;

@end
