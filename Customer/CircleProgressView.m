//
//  CircleProgressView.m
//  circle_iphone
//
//  Created by trandy on 15/3/5.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView()
-(void)createProgressView;
-(UIImage *)drawCircle;
@end
@implementation CircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame radius:(CGFloat)radius circleWidth:(CGFloat)circleWidth lineColor:(UIColor *)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // // init codes
        self.radius = radius;
        self.circleWidth = circleWidth;
        self.progressValue = 0.0f;
        if (lineColor == nil)
        {
            self.lineColor = [[UIColor alloc]initWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        }
        else 
        {
            self.lineColor = lineColor;
        }
        self.progressBgView = nil;
        //_progressView = nil;
        self.progressFrontView = nil;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shouldRasterize = YES;
        [self createProgressView];
        
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat radian_start = -90.0f * M_PI / 180.0f;
    CGFloat radian_end = radian_start + 2.0f * M_PI *self.progressValue;
    CGPoint circlePoint = CGPointMake(rect.size.width/2, rect.size.width/2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetFlatness(context, 0.0f);
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circlePoint radius:self.radius startAngle:radian_start endAngle:radian_end clockwise:YES];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    
    
    
}

-(void)dealloc
{
    [self.progressTimer invalidate];
}

#pragma mark - private methods

-(void)createProgressView
{
    // // 进度条view
    self.progressBgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.progressFrontView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.progressBgView];
    [self addSubview:self.progressFrontView];
    
    // // 进度条数字Label
    self.progressLabel = [[UILabel alloc]init];
    [self doSetProgressLabel:[UIFont systemFontOfSize:10] textColor:[UIColor whiteColor]];
    [self addSubview:self.progressLabel];
}

/*
 *  @brief: 设置进度数字属性
 */
-(void)doSetProgressLabel:(UIFont *)font textColor:(UIColor *)textColor
{
//    if (self.progressLabel == nil)
//    {
//        return;
//    }
//    self.labelFont = nil;
//    
//    self.labelTextColor = nil;
//    
//    if (font != nil)
//    {
//        self.labelFont = font;
//    }
//    else {
//        self.labelFont = [UIFont systemFontOfSize:10];
//    }
//    if (textColor != nil)
//    {
//        self.labelTextColor = textColor;
//    }
//    else {
//        self.labelTextColor = [UIColor whiteColor];
//    }
//    
//    int percent = _progressValue * 100;
//    NSString *percentStr = [NSString stringWithFormat:@"%d%%",percent];
//    [Utils autoTextSizeLabel:_progressLabel font:_labelFont labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(0, 0, _radius * 2.0, _radius * 2.0) text:percentStr textColor:_labelTextColor];
//    _progressLabel.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
}

/*
 *  @brief: 背景
 */
-(void)doSetProgressBgView:(UIImage *)progressBgImg
{
    if (progressBgImg == nil)
    {
        return;
    }
    _progressBgView.frame = CTRect(0, 0, progressBgImg.size.width, progressBgImg.size.height);
    _progressBgView.center = CTPoint(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    _progressBgView.image = progressBgImg;
}

/*
 *  @brief: 前景
 */
-(void)doSetProgressFrontView:(UIImage *)progressFrontImg
{
    if (progressFrontImg == nil)
    {
        return;
    }
    _progressFrontView.frame = CTRect(0, 0, progressFrontImg.size.width, progressFrontImg.size.height);
    _progressFrontView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    _progressFrontView.image = progressFrontImg;
}

-(void)doSetProgressValue:(CGFloat)progress
{
    _progressValue = MIN(MAX(progress, 0.0), 1.0);
    
//    int percent = _progressValue * 100;
//    NSString *percentStr = [NSString stringWithFormat:@"%d%%",percent];
//    [Utils autoTextSizeLabel:_progressLabel font:_labelFont labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(0, 0, _radius * 2.0, _radius * 2.0) text:percentStr textColor:_labelTextColor];
    _progressLabel.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    //_progressView.circlePercent = _progressValue;
    
    [self setNeedsDisplay];
}

/*
 *  @brief: 画环形Line
 */
-(UIImage *)drawCircle
{
    if (_radius <= 0.0f || _circleWidth <= 0.0f)
    {
        return nil;
    }
    
    CGFloat radian_start = -90.0f * M_PI / 180.0f;
    CGFloat radian_end = radian_start + 2.0f * M_PI *_progressValue;
    CGSize circleSize = CGSizeMake((_radius * 2.0f+ _circleWidth + 1), (_radius * 2.0f+ _circleWidth + 1));
    CGPoint circlePoint = CGPointMake(circleSize.width/2.0f, circleSize.height/2.0f);
    
    UIGraphicsBeginImageContext(circleSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _circleWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFlatness(context, 0.0f);
    CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circlePoint radius:_radius startAngle:radian_start endAngle:radian_end clockwise:YES];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    
    UIImage *circleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return circleImg;
}

//********************//
// //   进度条动画   // //
// // 平滑的加载进度  // //
-(void)doProgressTo:(float)progress time:(float)time
{
    // // 每次时间间隔更新的进度值
    _progressOffset = (progress - _progressValue) / (time / CSCIRCLEPROGRESS_UPDATE_TIME);
    // // 最终到达进度值
    _progressTo = MIN(1.0f, MAX(0.0f, progress));
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:CSCIRCLEPROGRESS_UPDATE_TIME target:self selector:@selector(doSetProgressPerProgressUpdateTime) userInfo:nil repeats:YES];
}

//********************************//
// // 每隔一个时间间隔更新一次进度值 // //
-(void)doSetProgressPerProgressUpdateTime
{
    if (_progressValue < _progressTo)
    {
        _progressValue += _progressOffset;
        _progressValue = MIN(_progressTo, _progressValue);
        [self doSetProgressValue:_progressValue];
    }
    else 
    {
        // // 停止更新
        [_progressTimer invalidate];
    }
}

@end
