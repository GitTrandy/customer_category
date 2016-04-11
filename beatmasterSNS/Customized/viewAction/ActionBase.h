//
//  ActionBase.h
//  dlgAni
//
//  Created by wanglei on 12-11-22.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ActionDefine.h"
#import "ImageFrame.h"
#import "ScoreAnimation.h"
#import "progressBarAni.h"

typedef enum _tagActionType
{
    //行动类型
    
    EAT_BASE=0,
    
    //透明
    EAT_Action_Opacity,
    
    //旋转
    EAT_Action_Rotation_X,
    EAT_Action_Rotation_Y,
    EAT_Action_Rotation_Z,
    
    //缩放
    EAT_Action_Scale_XY,
    EAT_Action_Scale_X,
    EAT_Action_Scale_Y,
    
    //移动
    EAT_Action_Position_XY,
    EAT_Action_Position_X,
    EAT_Action_Position_Y,
    
    //图片动画
    EAT_Action_Images,
    
    //积分动画
    EAT_Action_Score,
    
    //进度条
    EAT_Action_Progressbar,
    
    //延时
    EAT_Action_Delay,
    
    //callback
    EAT_Action_Callback,
    
    EAT_Count,
    
}ActionType;

typedef enum _tagActionState
{
    EAS_NONE=0,
    
    EAS_Start,
    EAS_Stop,
    EAS_End,
    EAS_Remove,
    EAS_Clear,
    
    EAS_Count,
}ActionState;


@interface ActionBase : NSObject
{
    ActionType      _actionType;    //类型
    ActionState     _actionState;   //状态
    
    UIView*         _viewTarget;    //view指针
    CAAnimation*    _aniTarget;
    
    
    id<actionEventDelegate> _delegate;
}

-(id) init;
-(id) initWithAction:(ActionBase*)action toViewTarget:(UIView*)viewTarget;

//开始结束行动
-(void) startAnimation;
-(void) stopAnimation;
-(void) endAnimation;

-(void) removeAction;
-(void) removeActionDelegate;
-(void) clearAction;
-(void) update;

//创建animation
-(void) createBasicAnimation:(NSString*)keyPath
                   fromValue:(id)fromValue
                     toValue:(id)toValue
                    duration:(CFTimeInterval)duration
                 repeatCount:(float)repeatCount
                autoreverses:(BOOL)autoreverses;

@property (nonatomic, assign) ActionType    actionType;
@property (nonatomic, assign) ActionState   actionState;
@property (nonatomic, assign) UIView*       viewTarget;
@property (nonatomic, retain) CAAnimation*  aniTarget;
@property (nonatomic, assign) id<actionEventDelegate> delegate;

@end


//  透明度动画
@interface  OpacityAction: ActionBase{
    
    float _toValue;
}

+(id) actionWithAction:(OpacityAction*)action toViewTarget:(UIView*)viewTarget;

+(id) action:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue;
+(id) action:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

-(id) init:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

@end

//  旋转
@interface RotationAction : ActionBase{
    
    float _toRotationX;
    float _toRotationY;
    float _toRotationZ;
}

+(id) actionWithAction:(RotationAction*)action toViewTarget:(UIView*)viewTarget;

// fromValue toValue 是pi(弧度值)
+(id) action:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue;

+(id) action:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

-(id) init:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

@end

//  缩放

@interface ScaleAction : ActionBase{
    float _toScaleX;
    float _toScaleY;
}

+(id) actionWithAction:(ScaleAction*)action toViewTarget:(UIView*)viewTarget;

//单方向 x, y
+(id) action:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue;

+(id) action:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

-(id) init:(CoordinateType)coordinateType target:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

@end

//  移动

@interface PositionAction : ActionBase{
    
    CGPoint _toPoint;
    CGPoint _changePoint;
}

+(id) actionWithAction:(PositionAction*)action toViewTarget:(UIView*)viewTarget;

//双方向一起改 (x,y)
+(id) action:(UIView*)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue;
+(id) action:(UIView*)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

-(id) init:(UIView*)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

//可以只改单方向，x,y
+(id) action:(CoordinateType)coordinateType viewTarget:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue;
+(id) action:(CoordinateType)coordinateType viewTarget:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

-(id) init:(CoordinateType)coordinateType viewTarget:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses;

@end


@interface ImagesAction : ActionBase <actionEventDelegate>

+(id) action:(ImageFrame *)target duration:(CFTimeInterval)duration formatKey:(NSString*)formatKey beginIdx:(int)beginIdx imagesCount:(int)imagesCount repeatCount:(int)repeatCount imageCache:(bool)bImageCache;

-(id) init:(ImageFrame *)target duration:(CFTimeInterval)duration formatKey:(NSString*)formatKey beginIdx:(int)beginIdx imagesCount:(int)imagesCount repeatCount:(int)repeatCount imageCache:(bool)bImageCache;

@end

@interface ScoreAction : ActionBase <actionEventDelegate>

+(id) action:(ScoreAnimation*)target;
-(id) init:(ScoreAnimation*)target;

@end

@interface ProgressBarAction : ActionBase <actionEventDelegate>

+(id) action:(progressBarAni*)target;
-(id) init:(progressBarAni*)target;

@end

@interface DelayAction : ActionBase
{
    float            _duration;
    struct timeval   _startTime;
}

+(id) action:(CFTimeInterval)duration;
-(id) init:(CFTimeInterval)duration;

@end

@interface CallbackAction : ActionBase{
    
    id      _target;
    SEL     _callback;
    id      _param;
}

+(id) action:(id)target callback:(SEL)callback param:(id)param;
-(id) init:(id)target callback:(SEL)callback param:(id)param;
@end
