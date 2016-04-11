//
//  CSProgressView.m
//  beatmasterSNS
//
//  Created by chengsong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSProgressView.h"
@interface CSProgressView()
-(void)createProgressView;
@end
@implementation CSProgressView
@synthesize progressImageView = _progressImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        [self createProgressView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private methods
-(void)createProgressView
{
    _progressBgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _progressImageView = [[ProgressImageView alloc]initWithFrame:CGRectZero];
    _progressFrontView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_progressBgView];
    [self addSubview:_progressImageView];
    [self addSubview:_progressFrontView];
    
}

-(void)setProgress:(float)p
{
    [self doSetProgress:p];
}

#pragma mark - open methods
//设置Frame
-(void)doSetFrame:(CGRect)frame{
    
    self.frame = frame;
    self.autoresizesSubviews = YES;
    //[self createProgressView];
}


//*********************************//
// // 设置progress背景图片以及位置  // //
-(void)doSetProgressBgView:(CGRect)frame progressBgImg:(UIImage *)progressBgImg
{
    _progressBgView.frame = frame;
    _progressBgView.image = progressBgImg;
}

//*********************************//
// // 设置progress前端图片以及位置  // //
-(void)doSetProgressFrontView:(CGRect)frame progressFrontImg:(UIImage *)progressFrontImg
{
    _progressFrontView.frame = frame;
    _progressFrontView.image = progressFrontImg;
}
//*********************************//
// //  设置progress图片以及位置    // //
-(void)doSetProgressImageView:(CGRect)frame progressImage:(UIImage *)progressImage
{
    _progressImageView.frame = frame;
    float scaleX = frame.size.width / progressImage.size.width;
    float scaleY = frame.size.height/ progressImage.size.height;
    [_progressImageView doSetProgressImg:progressImage scaleX:scaleX scaleY:scaleY];
    
    
}

//********************************//
// //   设置progress当前进度     // //
-(void)doSetProgress:(float)progress
{
    [_progressImageView doSetProgress:progress];
}

-(float)doGetProgress
{
    return  _progressImageView.progress;
}

#pragma mark - dealloc
-(void)dealloc
{
    [_progressBgView release];
    [_progressFrontView release];
    [_progressImageView release];
    [super dealloc];
    SNSLog(@"%s",__FUNCTION__);
}

@end


//+++++++++++++++++++++++++++++++++++++++++++++++++++//
//                                                   //
//  1、UIImage(PartialImage):显示一张图片的部分图像 实现   //
//                                                   //
//  2、ProgressImageView: 进度条的进度图片View           //
//                                                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++//
@interface UIImage(PartialImage)
/**
 *  @brief  根据百分比创建一张图片的部分图像
 *  @param  Percentage:百分比
 *  @return  部分图片
 */
-(UIImage *)partialImageWithPercentage:(float)percentage;
@end
@implementation UIImage(PartialImage)

-(UIImage *)partialImageWithPercentage:(float)percentage
{
    //******************//
    // 一个像素: 32位表示
    // 第一个8位: RED值
    // 第二个8位: GREEN值
    // 第三个8位: BLUE值
    // 第四个8位: ALPHA值
    const int RED   = 0;
    const int GREEN = 1;
    const int BLUE  = 2;
    const int ALPHA = 3;
    
    // //取得本图片的矩阵大小(宽，高)
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    
    // // 获得图片所有像素 数据值    放在一个像素大小的数组里
    uint32_t *pixels = (uint32_t *)malloc(imageWidth * imageHeight * sizeof(uint32_t));
    memset(pixels, 0, imageWidth * imageHeight * sizeof(uint32_t));
    
    // // 色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // // 创建一个图片绘制空间 RGBA
    CGContextRef context = CGBitmapContextCreate(pixels, imageWidth, imageHeight, 8, imageWidth*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    // // 在空间绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), [self CGImage]);
    // // 把绘制的图片的不需要显示的部分都把像素值设为空
    int x_keep = imageWidth * percentage;
    int y_keep = imageHeight;
    for (int y=0; y<y_keep; y++)
    {
        for (int x=x_keep; x<imageWidth; x++)
        {
            uint8_t *rgba = (uint8_t *) &pixels[y * imageWidth + x];
            rgba[RED] = 0;
            rgba[GREEN] = 0;
            rgba[BLUE] = 0;
            rgba[ALPHA] = 0;
        }
    }
    // // 把绘制出来的空间图片做成一个CGImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    // // 释放资源
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // // 制作成UIImage
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return uiImage;
        
}
@end

@interface ProgressImageView()
-(void)doVariablesInit;     // // 基本数据初始化
-(void)updateProgress;      // // 更新进度值
-(void)doSetProgressPerProgressUpdateTime;  // // 每隔一个时间间隔更细一次进度值
-(UIImage *)doGetImageWithRect:(CGRect)rect image:(UIImage *)image;
@end
@implementation ProgressImageView
@synthesize progress = _progress;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // // do init
        [self doVariablesInit];
    }
    return self;
}
-(void)dealloc
{
    [_progressImg release];
    [super dealloc];
}

#pragma mark - private methods
//*******************//
// // 基本数据初始化 // //
-(void)doVariablesInit
{
    _progress = 0.0f;
    _progressImg = nil;
}

//**************************//
// // 每次调用更新当前进度值 // //
-(void)updateProgress
{
    _progress = MIN(1.0f, MAX(0.0, _progress));
    if (_progressImg != nil)
    {
        //self.image = [_progressImg partialImageWithPercentage:_progress];
        CGRect rect = CGRectMake(0, 0, _progressImg.size.width * _progress, _progressImg.size.height);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width * _scaleX, rect.size.height * _scaleY);
        self.image = [self doGetImageWithRect:rect image:_progressImg];
    }
}

//********************************//
// // 每隔一个时间间隔更新一次进度值 // //
-(void)doSetProgressPerProgressUpdateTime
{
    if (_progress < _progressTo)
    {
        _progress += _progressOffset;
        _progress = MIN(_progress, _progressTo);
        [self updateProgress];
    }
    else 
    {
        // // 停止更新
        [_progressTimer invalidate];
    }

    
}

-(UIImage *)doGetImageWithRect:(CGRect)rect image:(UIImage *)image
{
    if (nil == image || fabs(rect.size.width) < 0.000001f)
    {
        return nil;
    }
    
    //SNSLog(@"%f,%f",rect.size.width,rect.size.height);
    // // 因为图片都用的是@2x的图片，截取图片的时候矩形要乘以2，范围要扩大一倍
    CGRect newRect = CGRectMake(rect.origin.x * 2, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2);
    CGImageRef tmpRef = CGImageCreateWithImageInRect([image CGImage], newRect);
    UIImage *returnImage = [UIImage imageWithCGImage:tmpRef];
    CGImageRelease(tmpRef);
    //self.image = returnImage;
    return returnImage;
}


#pragma mark - open methods
//*********************************//
// // 设置精进度条图片 并根据进度显示 // //
-(void)doSetProgressImg:(UIImage *)progressImg scaleX:(float)x scaleY:(float)y
{
    if (_progressImg != nil)
    {
        [_progressImg release];
        _progressImg = nil;
    }
    _progressImg = [progressImg retain];
    _scaleX = x;
    _scaleY = y;
    [self updateProgress];
}

//*****************//
// // 设置进度值  // //
-(void)doSetProgress:(float)progressValue
{
    _progress = MIN(1.0f, MAX(0.0f, progressValue));
    [self updateProgress];
}

//********************//
// //   进度条动画   // //
// // 平滑的加载进度  // //
-(void)doProgressTo:(float)progressValue time:(float)time
{
    // // 每次时间间隔更新的进度值
    _progressOffset = (progressValue - _progress) / (time / PROGRESS_UPDATE_TIME);
    // // 最终到达进度值
    _progressTo = MIN(1.0f, MAX(0.0f, progressValue));

//    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:PROGRESS_UPDATE_TIME target:self selector:@selector(doSetProgressPerProgressUpdateTime) userInfo:nil repeats:YES];
    
    __block ProgressImageView *weakSelf = self;
    _progressTimer = [[RNTimer repeatingTimerWithTimeInterval:PROGRESS_UPDATE_TIME block:^{
        [weakSelf doSetProgressPerProgressUpdateTime];
    }] retain];
}

@end


