//
//  ActionBase.m
//  dlgAni
//
//  Created by wanglei on 12-11-22.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ActionBase.h"
#import "ActionCommon.h"

const float ACTION_FIG_INVALIDFLOAT= -2147483647.f;

#define AnimationKeyPath_Opacity     @"opacity"                  //透明度
#define AnimationKeyPath_Rotation_x  @"transform.rotation.x"     //旋转
#define AnimationKeyPath_Rotation_y  @"transform.rotation.y"     //旋转
#define AnimationKeyPath_Rotation_z  @"transform.rotation.z"     //旋转
#define AnimationKeyPath_Scale_XY    @"transform.scale"          //缩放
#define AnimationKeyPath_Scale_X     @"transform.scale.x"        //缩放
#define AnimationKeyPath_Scale_Y     @"transform.scale.y"        //缩放
#define AnimationKeyPath_Position_XY @"position"                 //移动
#define AnimationKeyPath_Position_X  @"transform.translation.x"  //移动
#define AnimationKeyPath_Position_Y  @"transform.translation.y"  //移动

#pragma mark - ActionBase

@implementation ActionBase

@synthesize viewTarget = _viewTarget;
@synthesize actionType = _actionType;
@synthesize actionState = _actionState;
@synthesize aniTarget = _aniTarget;
@synthesize delegate = _delegate;

#pragma mark - action init

-(id) init{
    if( (self=[super init]) ) {
        
		_actionType = EAT_BASE;
        _viewTarget = nil;
        _aniTarget = nil;
        
        _actionState = EAS_NONE;
        
        _delegate = nil;
	}
	return self;
}

-(id) initWithAction:(ActionBase *)action toViewTarget:(UIView *)viewTarget{
    
    assert(action);
    assert(viewTarget);
    
    if( (self=[super init]) ) {
        
		_actionType = action.actionType;
        _viewTarget = viewTarget;
        
        self.aniTarget = action.aniTarget;
        
        _actionState = EAS_NONE;
	}
	return self;
    
}

-(void)dealloc{
    
    AniLog(@"ActionBase dealloc");
    
    [self clearAction];
    [super dealloc];
}

#pragma mark - animation

-(void) createBasicAnimation:(NSString *)keyPath
              fromValue:(id)fromValue
                toValue:(id)toValue
               duration:(CFTimeInterval)duration
            repeatCount:(float)repeatCount
           autoreverses:(BOOL)autoreverses
{
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.fromValue = fromValue;
    anim.toValue = toValue;
    anim.duration = duration;
    
    if (repeatCount==RepeatForEver)
        anim.repeatCount = FLT_MAX;
    else
        anim.repeatCount = repeatCount;
    
    anim.autoreverses = autoreverses;
    //anim.delegate = self;
    
    //保持在最后一帧的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    //设置动画
    self.aniTarget = anim;
}

#pragma mark - remove

-(void) clearAction{
    
    _actionState = EAS_Clear;
    
    [self removeAction];
    [self removeActionDelegate];
}

-(void) removeActionDelegate{
    
    //删除代理
    _delegate = nil;
}

-(void) removeAction{
    
    //要停止动画
    [self stopAnimation];
    
    _actionState = EAS_Remove;
    
    //删除view和ani
    _viewTarget = nil;
    if (nil!=_aniTarget)
    {
        _aniTarget.delegate = nil;
        [_aniTarget release];
        _aniTarget = nil;
    }
}

-(void) startAnimation{
    
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    _actionState = EAS_Start;
    
    if (nil!=_viewTarget && nil!=_aniTarget)
    {
        [_viewTarget setHidden:NO];
        
        _aniTarget.delegate = self;
        
        //将地址当key
        [_viewTarget.layer addAnimation:_aniTarget forKey:[NSString stringWithFormat:@"%p", _aniTarget]];
    }
}


-(void) stopAnimation{
    
    if (nil!=_viewTarget && nil!=_aniTarget)
    {
        [_viewTarget.layer removeAnimationForKey:[NSString stringWithFormat:@"%p", _aniTarget]];
        _aniTarget.delegate = nil;
    }
    
    _actionState = EAS_Stop;
}

-(void) endAnimation{
    
    //先保存，等手动设置完view的相应状态后，才删除，这样不会感觉异常
    //由于 anim.removedOnCompletion = NO; 所以动画没有删除，所以要手动删除
    [self stopAnimation];
    
    _actionState = EAS_End;
    
    //通知动画结束
    if (nil!=_delegate)
    {
        //由外面删除
        [_delegate didEnd:self];
    }
    
}


-(void) update{
    
    //什么也不做
}

#pragma mark - ani callback
-(void) animationDidStart:(CAAnimation *)anim{
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self endAnimation];
}

@end


#pragma mark - OpacityAction

@implementation OpacityAction

+(id) actionWithAction:(OpacityAction *)action toViewTarget:(UIView *)viewTarget{
    
    return [[[OpacityAction alloc] initWithAction:action toViewTarget:viewTarget] autorelease];
}

+(id) action:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue{
    
    return [OpacityAction action:target duration:duration fromValue:fromValue toValue:toValue repeatCount:1 autoreverses:NO];
}

+(id) action:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses
{
    return [[[OpacityAction alloc] init:target duration:duration fromValue:fromValue toValue:toValue repeatCount:repeatCount autoreverses:autoreverses] autorelease];
}

-(id) init:(UIView*)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    if( (self=[super init]) ) {
        
        self.actionType = EAT_Action_Opacity;
        self.viewTarget = target;
        
        [self createBasicAnimation:AnimationKeyPath_Opacity fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
        
        _toValue = toValue;
	}
	return self;
}

-(void) endAnimation{
    
    if (nil!=_viewTarget)
    {
        //将view设置为动画结束时的状态
        _viewTarget.layer.opacity = _toValue;
    }
    
    [super endAnimation];
}

@end


#pragma mark - RotationAction

@implementation RotationAction

+(id) actionWithAction:(RotationAction *)action toViewTarget:(UIView *)viewTarget{
    
    return [[[RotationAction alloc] initWithAction:action toViewTarget:viewTarget] autorelease];
}

+(id) action:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue{
    
    return [RotationAction action:coordinateType target:target duration:duration fromValue:fromValue toValue:toValue repeatCount:1 autoreverses:NO];
}

+(id) action:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    return [[[RotationAction alloc] init:coordinateType target:target duration:duration fromValue:fromValue toValue:toValue repeatCount:repeatCount autoreverses:autoreverses] autorelease];
}

-(id) init:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    if( (self=[super init]) ) {
        
        _toRotationX = 0.f;
        _toRotationY = 0.f;
        _toRotationZ = 0.f;
        
        switch (coordinateType) {
            case ECT_X:
            {
                self.actionType = EAT_Action_Rotation_X;
                
                [self createBasicAnimation:AnimationKeyPath_Rotation_x fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toRotationX = toValue;
                
            }
                break;
            
            case ECT_Y:
            {
                self.actionType = EAT_Action_Rotation_Y;
                
                [self createBasicAnimation:AnimationKeyPath_Rotation_y fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toRotationY = toValue;
            }
                break;
                
            case ECT_Z:
            {
                self.actionType = EAT_Action_Rotation_Z;
                
                [self createBasicAnimation:AnimationKeyPath_Rotation_z fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toRotationZ = toValue;
            }
                break;
                
            default:
                assert(false);
                break;
        }
        
        self.viewTarget = target;
        
	}
	return self;
}

-(void) endAnimation{
    
    if (nil!=_viewTarget)
    {
        //将view设置为动画结束时的状态
        //_viewTarget.transform = CGAffineTransformScale(_viewTarget.transform, _toScaleX, _toScaleY);
    }
    
    [super endAnimation];
}

@end


#pragma mark - ScaleAction

@implementation ScaleAction

+(id) actionWithAction:(ScaleAction *)action toViewTarget:(UIView *)viewTarget{
    
    return [[[ScaleAction alloc] initWithAction:action toViewTarget:viewTarget] autorelease];
}

+(id) action:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue{
    
    return [ScaleAction action:coordinateType target:target duration:duration fromValue:fromValue toValue:toValue repeatCount:1 autoreverses:NO];
}

+(id) action:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    return [[[ScaleAction alloc] init:coordinateType target:target duration:duration fromValue:fromValue toValue:toValue repeatCount:repeatCount autoreverses:autoreverses] autorelease];
}

-(id) init:(CoordinateType)coordinateType target:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    if( (self=[super init]) ) {
        
        self.viewTarget = target;
        
        //初始不缩放
        _toScaleX = _viewTarget.transform.a;
        _toScaleY = _viewTarget.transform.d;
        
        switch (coordinateType) {
            case ECT_X:
            {
                self.actionType = EAT_Action_Scale_X;
                
                [self createBasicAnimation:AnimationKeyPath_Scale_X fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toScaleX = toValue;
                
            }
                break;
                
            case ECT_Y:
            {
                self.actionType = EAT_Action_Scale_Y;
                
                [self createBasicAnimation:AnimationKeyPath_Scale_Y fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toScaleY = toValue;
            }
                break;
                
            case ECT_XY:
            {
                self.actionType = EAT_Action_Scale_XY;
                
                [self createBasicAnimation:AnimationKeyPath_Scale_XY fromValue:@(fromValue) toValue:@(toValue)duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                _toScaleX = toValue;
                _toScaleY = toValue;
            }
                break;
                
            default:
                assert(false);
                break;
        }
        
	}
	return self;
}

-(void) endAnimation{
    
    if (nil!=_viewTarget)
    {
        //将view设置为动画结束时的状态
        CGAffineTransform tForm = _viewTarget.transform;
        
        if (_actionType==EAT_Action_Scale_XY)
        {
            tForm.a = _toScaleX;
            tForm.d = _toScaleY;
        }
        else if(_actionType==EAT_Action_Scale_X)
        {
            tForm.a = _toScaleX;
        }
        else if(_actionType==EAT_Action_Scale_Y)
        {
            tForm.d = _toScaleY;
        }
        _viewTarget.transform = tForm;
        //_viewTarget.transform = CGAffineTransformMakeScale( _toScaleX, _toScaleY);
        
    }
    
    [super endAnimation];
}

@end

#pragma mark - positionAction

@implementation PositionAction

+(id) actionWithAction:(PositionAction *)action toViewTarget:(UIView *)viewTarget{
    
    return [[[PositionAction alloc] initWithAction:action toViewTarget:viewTarget] autorelease];
}

+(id) action:(UIView *)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue{
    
    return [self action:target duration:duration fromValue:fromValue toValue:toValue repeatCount:1  autoreverses:NO];
}

+(id) action:(UIView *)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    return [[[PositionAction alloc] init:target duration:duration fromValue:fromValue toValue:toValue repeatCount:repeatCount autoreverses:autoreverses] autorelease];
}

-(id) init:(UIView *)target duration:(CFTimeInterval)duration fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    if( (self=[super init]) ) {
        
        self.actionType = EAT_Action_Position_XY;
        self.viewTarget = target;
        
        //fromValue，toValue都是相对于本身view.center的偏移值，
        [self createBasicAnimation:AnimationKeyPath_Position_XY fromValue:[NSValue valueWithCGPoint:fromValue] toValue:[NSValue valueWithCGPoint:toValue] duration:duration repeatCount:repeatCount autoreverses:autoreverses];
        
        _toPoint = CGPointMake( toValue.x, toValue.y);
        
	}
	return self;
}

+(id) action:(CoordinateType)coordinateType viewTarget:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue{
    return [PositionAction action:coordinateType viewTarget:target duration:duration fromValue:fromValue toValue:toValue repeatCount:1 autoreverses:NO];
}

+(id) action:(CoordinateType)coordinateType viewTarget:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    return [[[PositionAction alloc] init:coordinateType viewTarget:target duration:duration fromValue:fromValue toValue:toValue repeatCount:repeatCount autoreverses:autoreverses] autorelease];
}

-(id) init:(CoordinateType)coordinateType viewTarget:(UIView *)target duration:(CFTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(float)repeatCount autoreverses:(BOOL)autoreverses{
    
    if( (self=[super init]) ) {
        
        self.viewTarget = target;
        
        switch (coordinateType)
        {
            case ECT_X:
            {
                self.actionType = EAT_Action_Position_X;
                
                [self createBasicAnimation:AnimationKeyPath_Position_X fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                //_toPoint = CGPointMake(_viewTarget.center.x + toValue - fromValue, _viewTarget.center.y);
                
                _toPoint = CGPointMake(toValue, 0);
            }
                break;
                
            case ECT_Y:
            {
                self.actionType = EAT_Action_Position_Y;
                
                [self createBasicAnimation:AnimationKeyPath_Position_Y fromValue:@(fromValue) toValue:@(toValue) duration:duration repeatCount:repeatCount autoreverses:autoreverses];
                
                //_toPoint = CGPointMake(_viewTarget.center.x, _viewTarget.center.y + toValue - fromValue);
                _toPoint = CGPointMake(0, toValue);
            }
                break;
                
            default:
                assert(false);
                break;
        }
        
        
	}
	return self;
}

-(void) startAnimation{
    
    if (_actionType==EAT_Action_Position_XY)
    {
        _changePoint = _toPoint;
    }
    else
    {
        _changePoint = CGPointMake( _viewTarget.center.x + _toPoint.x, _viewTarget.center.y + _toPoint.y);
    }
    
    
    
    [super startAnimation];
}

-(void) endAnimation{
    
    if (nil!=_viewTarget)
    {
        //将view设置为动画结束时的状态
//        _viewTarget.transform = CGAffineTransformTranslate(_viewTarget.transform, _toPoint.x, _toPoint.y);
        _viewTarget.center = _changePoint;
        //CGSize size = _viewTarget.frame.size;
        //_viewTarget.frame = CGRectMake(_toPoint.x, _toPoint.y, size.width, size.height);
    }
    
    [super endAnimation];
}

@end

#pragma mark - ProgressBarAction

@implementation ProgressBarAction

-(id) init:(progressBarAni *)target{
    
    if( (self=[super init]) ) {
        
        target.delegate = self;
        
        self.actionType = EAT_Action_Progressbar;
        self.viewTarget = target;
    }
    
    return self;
}

+(id) action:(progressBarAni *)target{
    
    return [[[ProgressBarAction alloc] init:target] autorelease];
}

-(void) startAnimation{
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    _actionState = EAS_Start;
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(start)])
    {
        [_viewTarget setHidden:NO];
        
        [_viewTarget performSelector:@selector(start)];
    }
}

-(void) stopAnimation{
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(stop)])
    {
        [_viewTarget performSelector:@selector(stop)];
    }
    
    _actionState = EAS_Stop;
}

-(void) removeAction{
    [super removeAction];
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(remove)])
    {
        [_viewTarget performSelector:@selector(remove)];
    }
    
}

-(void) didStart:(id)sender{
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) didEnd:(id)sender{
    
    [self endAnimation];
}

@end


#pragma mark - ScoreAction

@implementation ScoreAction

+(id) action:(ScoreAnimation *)target{
    
    return [[[ScoreAction alloc] init:target]autorelease];
}

-(id) init:(ScoreAnimation *)target{
    
    if( (self=[super init]) ) {
        
        target.delegate = self;
        
        self.actionType = EAT_Action_Score;
        self.viewTarget = target;
    }
    
    return self;
}

-(void) startAnimation{
    
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    _actionState = EAS_Start;
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(start)])
    {
        [_viewTarget setHidden:NO];
        [_viewTarget performSelector:@selector(start)];
    }
}

-(void) stopAnimation{
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(stop)])
    {
        [_viewTarget performSelector:@selector(stop)];
    }
    
    _actionState = EAS_Stop;
}

-(void) removeAction{
    [super removeAction];
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(remove)])
    {
        [_viewTarget performSelector:@selector(remove)];
    }
    
}

-(void) didStart:(id)sender{
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) didEnd:(id)sender{
    
    [self endAnimation];
}

@end

#pragma mark - ImagesAction
@implementation ImagesAction

+(id) action:(ImageFrame *)target duration:(CFTimeInterval)duration formatKey:(NSString *)formatKey beginIdx:(int)beginIdx imagesCount:(int)imagesCount repeatCount:(int)repeatCount imageCache:(bool)bImageCache{
    
    return [[[ImagesAction alloc] init:target duration:duration formatKey:formatKey beginIdx:beginIdx imagesCount:imagesCount repeatCount:repeatCount imageCache:bImageCache] autorelease];
}

-(id) init:(ImageFrame *)target duration:(CFTimeInterval)duration formatKey:(NSString *)formatKey beginIdx:(int)beginIdx imagesCount:(int)imagesCount repeatCount:(int)repeatCount imageCache:(bool)bImageCache{
    
    if( (self=[super init]) ) {
        
        [target setParamWithFormatKey:formatKey beginIdx:beginIdx imageCount:imagesCount duration:duration repeatCount:repeatCount ImageCache:bImageCache  delegate:self];
        
        self.viewTarget = target;
        self.actionType = EAT_Action_Images;
        
	}
	return self;
}


-(void) startAnimation{
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    _actionState = EAS_Start;

    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(start)])
    {
        [_viewTarget setHidden:NO];
        
        [_viewTarget performSelector:@selector(start)];
    }
}

-(void) stopAnimation{
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(stop)])
    {
        [_viewTarget performSelector:@selector(stop)];
    }
    
    _actionState = EAS_Stop;
}

-(void) removeAction{
    [super removeAction];
    
    if (nil!=_viewTarget && [_viewTarget respondsToSelector:@selector(remove)])
    {
        [_viewTarget performSelector:@selector(remove)];
    }
    
}

-(void) didStart:(id)sender{
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) didEnd:(id)sender{
    
    [self endAnimation];
}

@end

#pragma mark - DelayAction
@implementation DelayAction

-(id) init:(CFTimeInterval)duration{
    
    if( (self=[super init]) ) {
        
        _duration = duration;
        _startTime.tv_sec = 0;
        _startTime.tv_usec = 0;
        
        self.actionType = EAT_Action_Delay;
    }
    return self;
}

+(id) action:(CFTimeInterval)duration{
    
    return [[[DelayAction alloc] init:duration] autorelease];
}

-(void) startAnimation{
    
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    _actionState = EAS_Start;
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
    
    //模拟通知动画结果（在下一帧执行，要不就进死循环了)
    //[self performSelector:@selector(endAnimation) withObject:nil afterDelay:_duration];
    gettimeofday(&_startTime, NULL);
}

-(void) stopAnimation{
    
    _actionState = EAS_Stop;
}

-(void) update{
    
    if (_actionState==EAS_Start)
    {
        float time = [ActionCommon getTickCount:&_startTime];
        if (_duration <= time)
        {
            [self endAnimation];
        }
    }
}

@end


#pragma mark - CallbackAction
@implementation CallbackAction

-(id) init:(id)target callback:(SEL)callback param:(id)param{
    
    if( (self=[super init]) ) {
        _target = target;
        _callback = callback;
        _param = param;
        
        self.actionType = EAT_Action_Callback;
    }
    return self;
}

+(id) action:(id)target callback:(SEL)callback param:(id)param{
    
    return [[[CallbackAction alloc] init:target callback:callback param:param] autorelease];
}

-(void) startAnimation{
    
    if (_actionState == EAS_Start)
    {
        AniLog(@"startAction state==EAS_Start type=%d",_actionType);
        return;
    }
    
    //通知动画开始
    if (nil!=_delegate)
    {
        [_delegate didStart:self];
    }
    
    _actionState = EAS_Start;
    
    if (nil!=_target && nil!=_callback)
    {
        [_target performSelector:_callback withObject:_param];
    }
    
    //模拟通知动画结果（在下一帧执行，要不就进死循环了)
//    if (nil!=_target && nil!=_callback)
//    {
//        [self performSelector:@selector(endAnimation) withObject:nil afterDelay:0.02f];
//    }
}

-(void) stopAnimation{
    
    _actionState = EAS_Stop;
}

-(void) removeAction{
    
    [super removeAction];
    
    _target = nil;
    _callback = nil;
    _param = nil;
}

-(void) update{
    
    if (_actionState==EAS_Start)
    {
        [self endAnimation];
    }
}

@end
