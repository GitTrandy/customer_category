//
//  ImageFrame.m
//  dlgAni
//
//  Created by wanglei on 12-11-28.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "ImageFrame.h"
#import "ActionCommon.h"

@interface ImageFrame ()
@property (nonatomic, retain) RNTimer* rnTimer;
@end


@implementation ImageFrame

-(id) init{
    
    if (self=[super init]){
        [self reset];
    }
    
    return self;
}

-(void) reset{
    
    _formatKey = nil;
    _beginIdx = 0;
    _imageCount = 0;
    _duration = 0.f;
    _repeatCount = 1;
    _finishIdx = -1;
    
    _oneImageTime = 0;
    _currentIdx = 0;
    _lastTime.tv_sec = 0;
    _lastTime.tv_usec = 0;
    _imagesArr = nil;
    
    _bPlaySound = false;
    _bImageCache = false;
    
    [self.rnTimer invalidate];
    self.rnTimer = nil;
    
    _delegate = nil;
}

-(void) resetLastTime{
    
    _lastTime.tv_sec = 0;
    _lastTime.tv_usec = 0;
}

-(void) dealloc{
    
    AniLog(@"ImageFrame dealloc %p", self);
    
    [self remove];
    
    [super dealloc];
}

-(int) getFinishIdx{
    
    return _finishIdx;
}

-(void) resetFinishIdx{
    _finishIdx = -1;
}

-(void) setPlaySound:(bool)bPlay{
    _bPlaySound = bPlay;
}

-(void) setFinishIdx:(int)idx{
    
    if (idx<_beginIdx)
    {
        AniLog(@"setFinishIdx idx=%d < beginIdx", idx);
        idx = _beginIdx;
    }
    
    if (idx >= (_beginIdx + _imageCount))
    {
        AniLog(@"setFinishIdx idx=%d < endIdx", idx);
        idx = (_beginIdx + _imageCount) - 1;
    }
    
    _finishIdx = idx;
    
    AniLog(@"_finishidx = %d", _finishIdx);
}

-(void) setParamWithFormatKey:(NSString *)formatKey beginIdx:(int)beginIdx imageCount:(int)imageCount duration:(float)duration repeatCount:(int)repeatCount ImageCache:(bool)bImageCache delegate:(id<actionEventDelegate>)delegate{
    
    //初始化数据
    [self reset];
    
    _formatKey = [formatKey copy];
    _beginIdx = beginIdx;
    _imageCount = imageCount;
    _duration = duration;
    _repeatCount = repeatCount;
    _bImageCache = bImageCache;
    
    _oneImageTime = _duration / _imageCount;
    _currentIdx = 0;
    _lastTime.tv_sec = 0;
    _lastTime.tv_usec = 0;
    
    _delegate = delegate;
    
    [self createImages];
}

#pragma mark - private

-(void) releaseImageArr{
    
    if (nil!=_imagesArr)
    {
        [_imagesArr removeAllObjects];
        [_imagesArr release];
        _imagesArr = nil;
    }
}

-(void) releaseNSTimer{

    if (nil!=self.rnTimer)
    {
        [self.rnTimer invalidate];
        self.rnTimer = nil;
    }
    
}

-(void) createImages{
    
    _imagesArr = [[NSMutableArray alloc] init];
    
    int nEndIdx = _beginIdx + _imageCount;
    NSString* str = nil;
    UIImage*  img = nil;
    for (int i=_beginIdx; i< nEndIdx; i++)
    {
        str = [NSString stringWithFormat:_formatKey, i];
        
        if (_bImageCache)
        {
            //保存图片
            img = [UIImage imageNamed_New:str];
            if (nil!=img)
            {
                [_imagesArr addObject:img];
            }
            else
            {
                AniLog(@"ImageFrame createImages imageCache error << %@", str);
            }
        }
        else
        {
            //保存路径
            if (nil!=str)
            {
                [_imagesArr addObject:str];
            }
            else
            {
                AniLog(@"ImageFrame createImages error << %@", str);
            }
        }
        
    }

    //将第一张图设为初始图
    [self setCurrentImage];
}

-(void) setCurrentImage{
    
    if ([_imagesArr count]<=0)
        return;
    
    int idx = _currentIdx%[_imagesArr count];
    
    if (_bImageCache)
    {
        self.image = _imagesArr[idx];
    }
    else
    {
        NSString* str = _imagesArr[idx];
        UIImage* img = [UIImage imageNamed_New:str];
        if (nil!=img)
        {
            self.image = img;
        }
    }
}

-(bool) checkEnd{
    
    //循环次数到了，结束了
    int playCount = _currentIdx / [_imagesArr count];
    if (0!=_repeatCount && playCount>=_repeatCount)
        return true;
    
    //到了结束图片下标，结束了
    int playIdx = _currentIdx % [_imagesArr count];
    if (-1!=_finishIdx && _finishIdx==playIdx)
        return true;
    
    //没有结束
    return false;
}

-(void) end{
    
    [self releaseNSTimer];
    [self resetLastTime];
    
    //重置为第一张图片
    [self setCurrentImage];
    
    //通知结束
    if(nil!=_delegate)
    {
        [_delegate didEnd:self];
    }
}

-(void) updateImage{
    
    float dt = [ActionCommon getTickCount:&_lastTime];
    if ( dt>=_oneImageTime )
    {
//        if (_bPlaySound)
//        {
//            PlayEffect(SFX_READSCORE);
//        }
        
        gettimeofday(&_lastTime, NULL);
        
        if([self checkEnd])
        {

            [self end];

            return;
        }
        

        [self setCurrentImage];

        
        _currentIdx++;
    }
}

#pragma mark - start stop

-(void) start{
    
    [self releaseNSTimer];

//    __unsafe_unretained ImageFrame* weakSelf = self;
    __block ImageFrame* weakSelf = self;
    self.rnTimer = [RNTimer repeatingTimerWithTimeInterval:0.02 block:^{
        [weakSelf updateImage];
    }];
    
    gettimeofday(&_lastTime, NULL);
    _currentIdx = 0;
    
    //通知开始
    if(nil!=_delegate)
    {
        [_delegate didStart:self];
    }
}

-(void) stop{
    
    [self releaseNSTimer];
}

-(void) remove{
    
    [self releaseNSTimer];
    [self releaseImageArr];
    [self removeDelegate];
}

-(void) removeDelegate{
    
    _delegate = nil;
}

-(bool) isStart{
    return self.rnTimer;
}

-(int) loopCount{
    
    return _currentIdx / [_imagesArr count];
}

-(int) currentImageIndex{
    
    return _currentIdx % [_imagesArr count];
}

@end
