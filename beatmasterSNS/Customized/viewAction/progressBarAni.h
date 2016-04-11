//
//  progressBar.h
//  dlgAni
//
//  Created by wanglei on 12-12-7.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionDefine.h"

typedef enum _tagLevelUpState
{
    LevelUpState_None=0,
    LevelUpState_Pause,       //暂停
    LevelUpState_End,         //结束
    
}LevelUpState;

@interface progressBarAni : UIImageView{
    
    UIImage*     _barImage;
    UIImageView* _bar;
    
    int    _updateCount;
    float  _currentValue;
    float  _tickValue;
    float  _beginValue;             //开始值，用于开始不是从0开始的情况
    int    _levelUpCount;           //升级的次数
    
    float  _offset;
    float  _fromValue;              //原始开始值
    float  _toValue;                //原始结束值
    
    bool   _bEnd;                   //是否结束
    LevelUpState   _bLevelUpState;  //是否升级暂停，这个会卡住，要等外部continue

    id<actionEventDelegate>         _delegate;
}

+(id) createProgressBarWithPos:(CGPoint)pos bgPath:(NSString*)bgPath barPath:(NSString*)barPath fromValue:(float)fromValue toValue:(float)toValue duration:(float)duration;

-(id) initWithPos:(CGPoint)pos bgPath:(NSString*)bgPath barPath:(NSString*)barPath fromValue:(float)fromValue toValue:(float)toValue duration:(float)duration;

-(void) start;
-(void) stop;
-(void) removeDeleaget;
-(void) remove;
-(void) continueAni;

//重置数据，用于从当前位置到toValue，toValue是相对值
// 如：开始从0.1->1.8  则当前位置是0.8 toValue＝0.9 就是从0.8->0.9
-(void) resetDataWithToValue:(float)toValue;

@property (nonatomic, assign) id<actionEventDelegate> delegate;
@property (nonatomic, assign) id<actionProgressBarDelegate> progressBarDelegate;
@end
