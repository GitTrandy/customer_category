//
//  ScoreAnimation.h
//  dlgAni
//
//  Created by wanglei on 12-12-3.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFrame.h"

@interface ScoreAnimation : UIImageView <actionEventDelegate>{
    
    int _toScoreNum;
    
    //每一位都是一个帆动画，个位index=0 十位index=1...
    NSMutableArray*  _imageFrameArr;     //存得每位的动画
    NSMutableArray*  _numArr;            //存得每位的数据

    int              _currentRunIdx;
    int              _stopIdx;
    int              _runningCount;
    float            _startOneImageTime;     //开始一个的时间
    float            _stopOneImageTime;      //结束一个的时间
    struct timeval   _lastStartTime;
    struct timeval   _lastStopTime;
    float            _margin;
    struct timeval   _playMusicTime;
    
    id<actionEventDelegate> _delegate;
}

+(ScoreAnimation*) createScoreAnimationWithScore:(int)ScoreNum point:(CGPoint)pt formatKey:(NSString*)formatKey duration:(float)duration margin:(float)margin;

//图片从0开始，有10张图片，0,1,2,3,4....
-(id) initWithScore:(int)ScoreNum point:(CGPoint)pt formatKey:(NSString*)formatKey duration:(float)duration margin:(float)margin;

-(void) start;
-(void) stop;
-(void) remove;

@property (nonatomic, assign) id<actionEventDelegate> delegate;

@end
