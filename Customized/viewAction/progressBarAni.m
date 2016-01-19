//
//  progressBar.m
//  dlgAni
//
//  Created by wanglei on 12-12-7.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import "progressBarAni.h"

#define ONE_UPDATE_TIME    0.02f

@interface progressBarAni ()

@property (nonatomic, retain) RNTimer* rnTimer;
@end

@implementation progressBarAni

@synthesize delegate = _delegate;

-(id) initWithPos:(CGPoint)pos bgPath:(NSString *)bgPath barPath:(NSString *)barPath fromValue:(float)fromValue toValue:(float)toValue duration:(float)duration{
    
    if (self=[super init])
    {
        [self resetDataWithFromValue:fromValue toValue:toValue duration:duration];
        
        [self createImage:pos bgPath:bgPath barPath:barPath];
    }
    
    return self;
}

-(void)resetDataWithToValue:(float)toValue
{
    //得到小数部分
    float fromValue = _toValue - floorf(_toValue);
    
    fromValue = MIN(1.f, MAX(0.f, fromValue));
    
    if (toValue<fromValue)
    {
        toValue = fromValue;
        
        SNSLog(@"progressBarAni error << toValue<fromValue");
    }
    
    _bLevelUpState = LevelUpState_None;
    _updateCount = 0;
    _fromValue = fromValue;
    _toValue = toValue;
    _currentValue = 0.f;
    _beginValue = _fromValue;
    _tickValue = _toValue - _fromValue;
    _levelUpCount = 0;
    _bEnd = false;
}

-(void)resetDataWithFromValue:(float)fromValue toValue:(float)toValue duration:(float)duration{
    
    if (fromValue<0.f)
    {
        fromValue = 0.f;
    }
    if (toValue<0.f)
    {
        toValue = 0.f;
    }
    
    if(toValue<fromValue)
    {
        toValue = fromValue;
        
        SNSLog(@"progressBarAni error << toValue<fromValue");
    }
    
    fromValue = MIN(1.f, MAX(0.f, fromValue));
    
    _bLevelUpState = LevelUpState_None;
    _updateCount = 0;
    _fromValue = fromValue;
    _toValue = toValue;
    _currentValue = 0.f;
    _beginValue = _fromValue;
    _tickValue = _toValue - _fromValue;
    _levelUpCount = 0;
    _bEnd = false;
    
    if (duration <= 0.f)
    {
        _offset = _toValue - _fromValue;
    }
    else
    {
        _offset = (_toValue - _fromValue) / (duration / ONE_UPDATE_TIME);
    }
    
    _delegate = nil;
    
}

+(id) createProgressBarWithPos:(CGPoint)pos bgPath:(NSString *)bgPath barPath:(NSString *)barPath fromValue:(float)fromValue toValue:(float)toValue duration:(float)duration{
    
    return [[[progressBarAni alloc] initWithPos:pos bgPath:bgPath barPath:barPath fromValue:fromValue toValue:toValue duration:duration] autorelease];
}

-(void) dealloc{
    
    AniLog(@"progressbar dealloc");
    
    [_barImage release];
    [_bar release];
    [self remove];
    
    [super dealloc];
}

#pragma mark - private
-(void) createImage:(CGPoint)pos bgPath:(NSString *)bgPath barPath:(NSString *)barPat{
    
    //设置背景
    UIImage* bg = [UIImage imageNamed_New:bgPath];
    self.image = bg;
    self.frame = CGRectMake(pos.x, pos.y, bg.size.width*SNS_SCALE, bg.size.height*SNS_SCALE);
    
    _barImage = [UIImage imageNamed_New:barPat];
    [_barImage retain];
    _bar = [[UIImageView alloc] initWithImage:_barImage];
    _bar.frame = CGRectMake(0.f, 0.f, _barImage.size.width*SNS_SCALE, _barImage.size.height*SNS_SCALE);
    [self addSubview:_bar];
    
    [self updateBar];
}

-(UIImage *)doGetImageWithRect:(CGRect)rect image:(UIImage *)image
{
    //SNSLog(@"%f,%f",rect.size.width,rect.size.height);
    // // 因为图片都用的是@2x的图片，截取图片的时候矩形要乘以2，范围要扩大一倍
    CGRect newRect = CGRectMake(rect.origin.x * 2, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2);
    CGImageRef tmpRef = CGImageCreateWithImageInRect([image CGImage], newRect);
    UIImage *returnImage = [UIImage imageWithCGImage:tmpRef];
    CGImageRelease(tmpRef);
    return returnImage;
}

-(void) updateBar{
    
//    _currentValue = _tickValue;
//    if (_currentValue>=1.f)
//    {
//        int tmp = (int)_currentValue;
//        _currentValue = _currentValue - tmp;
//    }
    
    float fValue = _currentValue + _beginValue;
    
    if (fValue<0.f)
    {
        SNSLog(@"updateBar error currentValue=%f",fValue);
        fValue = 0.f;
    }
    if (fValue>1.f)
    {
        SNSLog(@"updateBar error currentValue=%f",fValue);
        fValue = 1.f;
    }

    if (_barImage != nil)
    {
        CGRect rect = CGRectMake(0, 0, _barImage.size.width * fValue, _barImage.size.height);
        _bar.frame = CGRectMake(_bar.frame.origin.x, _bar.frame.origin.y, rect.size.width*SNS_SCALE, rect.size.height*SNS_SCALE);
        _bar.image = [self doGetImageWithRect:rect image:_barImage];
    }
    
}

-(void) update{
    
    _updateCount++;
    if (_updateCount<=10)
    {
        //先让进度条显示10次(10*0.02=0.2 200毫秒)，在运动，这样显示效果好一些
        return;
    }

    if (_bLevelUpState!=LevelUpState_None)
    {
        //暂停，等待外部调用continueAni
        
        return;
    }
    
    if (_bEnd)
    {
        //在要结束的时候因为升级通知卡住，所以在这里结束
        
        [self end];
        
        return;
    }
    
    _currentValue += _offset;
    if (_currentValue>=_tickValue)
    {
        //防止不该通知升级的时候通知升级
        _currentValue = _tickValue;
        
        //先发送走了一圈的消息，在退出
        if (_currentValue + _beginValue >=1.f)
        {
            _levelUpCount++;
            
            if (self.progressBarDelegate)
            {
                //暂停住，等待外面continueAni
                _bLevelUpState = LevelUpState_End;
                
                //通知进度条走到100%
                [self.progressBarDelegate didLevelUpWithSender:self count:_levelUpCount];
            }
            
            //这个值只在第一次有用
            _beginValue = 0.f;
            
            _currentValue = 0.f;
            
            _bEnd = true;
        }
        else
        {
            [self end];
        }
    }
    else
    {
        // _currentValue _tickValue都是相对值, 所以要计算_beginValue
        if (_currentValue + _beginValue >=1.f)
        {
            //进度条跑了一圈
            
            _tickValue = _tickValue -  (1.f - _beginValue);
            _currentValue = 1.f - _beginValue;
            _levelUpCount++;
            
            //这个值只在第一次有用
            _beginValue = 0.f;
            
            _currentValue = 0.f;
            
            if (self.progressBarDelegate)
            {
                //暂停住，等待外面continueAni
                
                _bLevelUpState = LevelUpState_Pause;
                
                //通知进度条走到100%
                [self.progressBarDelegate didLevelUpWithSender:self count:_levelUpCount];
            }
        }
    }
    
    [self updateBar];
    
//    if ([self updateBar])
//    {
//        _currentValue += _offset;
//        if (_currentValue >= _tickValue)
//        {
//            [self end];
//        }
//        
//        _tickValue += _offset;
//        if (_tickValue>=_toValue)
//        {
//            _tickValue = _toValue;
//            
//            [self end];
//            
//        }
//    }
}

#pragma mark - start stop
-(void) start{
    
    [self releaseTimer];
    
    _updateCount = 0;
    _currentValue = 0.f;
    _levelUpCount = 0;
    _beginValue = _fromValue;
    _tickValue = _toValue - _fromValue;
    
    _bEnd = false;
    
    //通知开始
    if(nil!=_delegate)
    {
        [_delegate didStart:self];
    }

    __block progressBarAni* weakSelf = self;
    self.rnTimer = [RNTimer repeatingTimerWithTimeInterval:ONE_UPDATE_TIME block:^{
        [weakSelf update];
    }];

}

-(void) stop{
    
    [self releaseTimer];
}

-(void) end{
    
    [self releaseTimer];
    
    [self updateBar];
    
    if (nil!=_delegate)
    {
        [_delegate didEnd:self];
    }
}

-(void) remove{
    
    [self releaseTimer];
    [self removeDeleaget];
}

-(void) removeDeleaget{
    _delegate = nil;
}

-(void) releaseTimer{

    if (nil!=self.rnTimer)
    {
        [self.rnTimer invalidate];
        self.rnTimer = nil;
    }

}

-(void) continueAni{
    _bLevelUpState = LevelUpState_None;
}

@end
