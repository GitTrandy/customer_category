//
//  ImageFrame.h
//  dlgAni
//
//  Created by wanglei on 12-11-28.
//  Copyright (c) 2012年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionDefine.h"

@interface ImageFrame : UIImageView{
    
    int         _repeatCount;
    int         _finishIdx;            //结束图片下标，用于积分动画
    float       _duration;
    NSString*   _formatKey;
    int         _beginIdx;
    int         _imageCount;
    
    float       _oneImageTime;         //_duration/_imageCount
    int         _currentIdx;
    struct timeval      _lastTime;
    
    bool        _bPlaySound;
    
    bool        _bImageCache;
    NSMutableArray*     _imagesArr;    //先存所有图片，如果内存不够，在用临时创的方式
    id<actionEventDelegate> _delegate;
}

-(id) init;
-(void) setParamWithFormatKey:(NSString*)formatKey beginIdx:(int)beginIdx imageCount:(int)imageCount  duration:(float)duration repeatCount:(int)repeatCount ImageCache:(bool)bImageCache delegate:(id<actionEventDelegate>)delegate;
//-(void) setParamWithFormatKey:(NSString*)formatKey beginIdx:(int)beginIdx imageCount:(int)imageCount  duration:(float)duration repeatCount:(int)repeatCount delegate:(id<actionEventDelegate>)delegate;

-(void) setFinishIdx:(int)idx;
-(int)  getFinishIdx;
-(void) resetFinishIdx;
-(void) setPlaySound:(bool)bPlay;

-(void) start;
-(void) stop;
-(void) remove;
-(void) removeDelegate;

-(bool) isStart;
-(int)  loopCount;
-(int)  currentImageIndex;

@end
