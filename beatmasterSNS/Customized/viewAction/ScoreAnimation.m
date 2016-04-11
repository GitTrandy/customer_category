//
//  ScoreAnimation.m
//  dlgAni
//
//  Created by wanglei on 12-12-3.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ScoreAnimation.h"
#import "ActionCommon.h"

@interface ScoreAnimation ()
@property (nonatomic, retain) RNTimer* rnTimer;
@end

@implementation ScoreAnimation

@synthesize delegate = _delegate;

-(id) initWithScore:(int)ScoreNum point:(CGPoint)pt formatKey:(NSString*)formatKey duration:(float)duration margin:(float)margin{
    
    if (self=[super init])
    {
        _toScoreNum = ScoreNum;
        _imageFrameArr = [[NSMutableArray alloc] init];
        _numArr = [[NSMutableArray alloc]init];
        self.frame = CGRectMake(pt.x, pt.y, 0, 0);
        _currentRunIdx = 0;
        _stopIdx = -1;
        _runningCount = 0;
        
        _startOneImageTime = duration/3;    // 1/3一轮的时间(只有10张图片)
        _stopOneImageTime = duration/3*2;   
        _lastStartTime.tv_sec = 0;
        _lastStartTime.tv_usec = 0;
        _lastStopTime.tv_sec = 0;
        _lastStopTime.tv_usec = 0;
        _playMusicTime.tv_sec = 0;
        _playMusicTime.tv_usec = 0;
        
        _margin = margin;
        
        _delegate = nil;
        
        int nNum = 0;
        int nScoreTmp = ScoreNum;
        
        do {
            
            nNum = nScoreTmp % 10;
            
            NSNumber* num = @(nNum);
            [_numArr addObject:num];
            
            ImageFrame* imageFrame = [[[ImageFrame alloc] init] autorelease];
            //循环播放，能过_finishIdx结束，
            [imageFrame setParamWithFormatKey:formatKey beginIdx:0 imageCount:10 duration:duration repeatCount:0 ImageCache:true delegate:self];
            
            [imageFrame setPlaySound:true];
            
            [_imageFrameArr addObject:imageFrame];
            
            nScoreTmp /= 10;
            
        } while (0!=nScoreTmp);
        
        //改变位置
        [self modifyFrame];
    }
    
    return self;
}

-(void)dealloc{
    AniLog(@"scoreAnimation dealloc");
    
    [self remove];
    
    [super dealloc];
}

+(ScoreAnimation*) createScoreAnimationWithScore:(int)ScoreNum point:(CGPoint)pt formatKey:(NSString *)formatKey duration:(float)duration margin:(float)margin{
    
    return [[[ScoreAnimation alloc] initWithScore:ScoreNum point:pt formatKey:formatKey duration:duration margin:margin] autorelease];
}

#pragma mark - private
-(void) modifyFrame{
    
    if ([_imageFrameArr count]<=0)
    {
        AniLog(@"modifyFrame error");
        return;
    }
    
    float x = self.frame.origin.x;
    float y = self.frame.origin.y;
    float w = 0.f;
    float h = 0.f;
    
    //从高位到低位取得数据
    for (int i=([_imageFrameArr count]-1),j=0; i>=0; i--,j++)
    {
        ImageFrame* image = _imageFrameArr[i];
        [image setHidden:YES];
        //[image setBackgroundColor:[UIColor redColor]];
        image.frame = CGRectMake(w - _margin*SNS_SCALE*j, 0, image.image.size.width*SNS_SCALE, image.image.size.height*SNS_SCALE);
        w += image.image.size.width*SNS_SCALE;
        h = image.image.size.height*SNS_SCALE;
        
        self.frame = CGRectMake(x, y, w, h);
        
        [self addSubview:image];
    }
    
}

-(void) releaseNSTimer{

    if (nil!=self.rnTimer)
    {
        [self.rnTimer invalidate];
        self.rnTimer = nil;
    }

}

-(ImageFrame*) imageFrameOfIdx:(int)idx{
    assert(idx>=0 && idx<[_imageFrameArr count]);
    
    return _imageFrameArr[idx];
}

-(int) scoreNumOfIdx:(int)idx{
    
    assert(idx>=0 && idx<[_numArr count]);
    NSNumber* num =  _numArr[idx];
    
    return [num intValue];
}


-(void) update{
    
    float dt = [ActionCommon getTickCount:&_playMusicTime];
    if (dt>=0.5f)
    {
        //1秒钟播放一次音效
        PlayEffect(SFX_READSCORE);
        
        gettimeofday(&_playMusicTime, NULL);
    }
    
    if ( _currentRunIdx < [_imageFrameArr count] && -1==_stopIdx /*&& dt > _startOneImageTime*/)
    {
        ImageFrame* image = [self imageFrameOfIdx:_currentRunIdx];
        image = [self imageFrameOfIdx:_currentRunIdx];
        [image setHidden:NO];
        [image setFinishIdx:[self scoreNumOfIdx:_currentRunIdx]];
        [image start];
        
        _stopIdx = _currentRunIdx;
        
        _currentRunIdx++;
        
        gettimeofday(&_lastStartTime, NULL);
    }
    
    /*
    dt = [ActionCommon getTickCount:&_lastStopTime];
    if (_stopIdx < [_imageFrameArr count] && dt > _stopOneImageTime)
    {
        ImageFrame* image = [self imageFrameOfIdx:_stopIdx];
        if (-1==[image getFinishIdx])
        {
            [image setFinishIdx:[self scoreNumOfIdx:_stopIdx]];
        }
        
        _stopIdx++;
        
        gettimeofday(&_lastStopTime, NULL);
    }
     */

}

-(void) endAnimation{
    
    [self releaseNSTimer];
    
    //通知结束
    if(nil!=_delegate)
    {
        [_delegate didEnd:self];
    }
    
    AniLog(@"ScoreAnimation endAnimation");
}

#pragma mark - didStart didstop
-(void) didStart:(id)sender{
    
}

-(void) didEnd:(id)sender{
    
    _stopIdx = -1;
    
    _runningCount--;
    if (_runningCount<=0)
    {
        [self endAnimation];
    }
}

#pragma mark - start
-(void) start{
    
    AniLog(@"ScoreAnimation << start");
    
    [self releaseNSTimer];
    

    __block ScoreAnimation* weakSelf = self;
    self.rnTimer = [RNTimer repeatingTimerWithTimeInterval:0.02 block:^{
        [weakSelf update];
    }];

    
    for (int i=([_imageFrameArr count]-1); i>=0; i--)
    {
        ImageFrame* image = _imageFrameArr[i];
        [image setHidden:YES];
        [image resetFinishIdx];
    }
    
    _currentRunIdx = 0;
    _runningCount = [_imageFrameArr count];
    _stopIdx = -1;
    
    _lastStartTime.tv_sec = 0;
    _lastStartTime.tv_usec = 0;
    gettimeofday(&_lastStopTime, NULL);
    
    _playMusicTime.tv_usec = 0;
    _playMusicTime.tv_sec = 0;
    //gettimeofday(&_playMusicTime, NULL);
    
    //通知开始
    if(nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) stop{
    
    [self releaseNSTimer];
    _lastStartTime.tv_sec = 0;
    _lastStartTime.tv_usec = 0;
    _lastStopTime.tv_sec = 0;
    _lastStopTime.tv_usec = 0;
    _playMusicTime.tv_usec = 0;
    _playMusicTime.tv_sec = 0;
    
    for (ImageFrame* image in _imageFrameArr)
    {
        [image stop];
    }
}

-(void) remove{
    
    [self releaseNSTimer];
    
    if (nil!=_imageFrameArr)
    {
        for (ImageFrame* image in _imageFrameArr)
        {
            [image removeDelegate];
        }
        [_imageFrameArr removeAllObjects];
        [_imageFrameArr release];
        _imageFrameArr = nil;
    }
    
    if (nil!=_numArr)
    {
        [_numArr removeAllObjects];
        [_numArr release];
        _numArr = nil;
    }
}

@end
