//
//  CSProgressView.h
//  beatmasterSNS
//
//  Created by chengsong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNTimer.h"

// // 平滑更新进度条的时候，进度条每更新一次进度值的时间间隔
#define PROGRESS_UPDATE_TIME  0.1f

@class ProgressImageView;

//********************//
//       进度条View    //
@interface CSProgressView : UIView
{
    UIImageView         *_progressBgView;
    ProgressImageView   *_progressImageView;
    UIImageView         *_progressFrontView;
}
//@property(nonatomic,retain)UIImage  *progressBgImg;
//@property(nonatomic,retain)UIImage  *progressFrontImg;
@property (nonatomic,readonly)ProgressImageView *progressImageView;

-(void)doSetProgressBgView:(CGRect)frame progressBgImg:(UIImage *)progressBgImg;
-(void)doSetProgressFrontView:(CGRect)frame progressFrontImg:(UIImage *)progressFrontImg;
-(void)doSetProgressImageView:(CGRect)frame progressImage:(UIImage *)progressImage;
-(void)doSetProgress:(float)progress;
-(float)doGetProgress;
-(void)setProgress:(float)p;

/*
    doSetFrame 设置frame,在初始化时不知道frame的时候使用
 
        如：初始化时 ProgressImageView* pProg = [ProgressImageView alloc] init];
           ......
           在其它地方 [pProg doSetFrame:CGRectMark(x, y, w, h)];
  
 */
-(void)doSetFrame:(CGRect)frame;
@end


//***********************//
//    进度条中跑动的view    //
@interface ProgressImageView : UIImageView
{
    UIImage     *_progressImg;
    float       _progress;
    float       _progressOffset; // // 每次时间间隔更新的进度值
    float       _progressTo;
    RNTimer     *_progressTimer;
    
    float       _scaleX;
    float       _scaleY;
}

@property (nonatomic,readonly) float progress;
-(void)doSetProgressImg:(UIImage *)progressImg scaleX:(float)x scaleY:(float)y;
-(void)doSetProgress:(float)progressValue;
-(void)doProgressTo:(float)progressValue time:(float)time;
@end
