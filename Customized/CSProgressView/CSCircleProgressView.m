//
//  CSCircleProgressView.m
//  beatmasterSNS
//
//  Created by chengsong on 12-12-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSCircleProgressView.h"

@interface CSCircleProgressView()
-(void)createProgressView;
-(UIImage *)drawCircle;
@end
@implementation CSCircleProgressView

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
        _radius = radius;
        _circleWidth = circleWidth;
        _progressValue = 0.0f;
        if (lineColor == nil)
        {
            _lineColor = [[UIColor alloc]initWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        }
        else 
        {
            _lineColor = [lineColor retain];
        }
        _progressBgView = nil;
        //_progressView = nil;
        _progressFrontView = nil;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shouldRasterize = YES;
        [self createProgressView];
        
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat radian_start = -90.0f * M_PI / 180.0f;
    CGFloat radian_end = radian_start + 2.0f * M_PI *_progressValue;
    //CGSize circleSize = CGSizeMake((_radius * 2.0f+ _circleWidth + 1), (_radius * 2.0f+ _circleWidth + 1));
    CGPoint circlePoint = CGPointMake(rect.size.width/2, rect.size.width/2);
    
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
    
    
    
}

-(void)dealloc
{
    [_lineColor release];
    [_labelFont release];
    [_labelTextColor release];
    [_progressBgView release];
    //[_progressView release];
    [_progressFrontView release];
    [_progressLabel release];
    [super dealloc];
}

#pragma mark - private methods
-(void)createProgressView
{
    // // 进度条view
    _progressBgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _progressView = [[CircleView alloc]initWithRadius:_radius circleWidth:_circleWidth circleColor:_lineColor circlePercent:_progressValue];
//    _progressView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    _progressFrontView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_progressBgView];
    //[self addSubview:_progressView];
    [self addSubview:_progressFrontView];
    
    // // 进度条数字Label
    _progressLabel = [[UILabel alloc]init];
    [self doSetProgressLabel:[UIFont systemFontOfSize:10*SNS_SCALE] textColor:[UIColor whiteColor]];
    [self addSubview:_progressLabel];
}

/*
 *  @brief: 设置进度数字属性
 */
-(void)doSetProgressLabel:(UIFont *)font textColor:(UIColor *)textColor
{
    if (_progressLabel == nil)
    {
        return;
    }
    if (_labelFont != nil)
    {
        [_labelFont release];
        _labelFont = nil;
    }
    if (_labelTextColor != nil)
    {
        [_labelTextColor release];
        _labelTextColor = nil;
    }
    if (font != nil)
    {
        _labelFont = [font retain];
    }
    else {
        _labelFont = [[UIFont systemFontOfSize:10]retain];
    }
    if (textColor != nil)
    {
        _labelTextColor = [textColor retain];
    }
    else {
        _labelTextColor = [[UIColor whiteColor]retain];
    }
    
    int percent = _progressValue * 100;
    NSString *percentStr = [NSString stringWithFormat:@"%d%%",percent];
    [Utils autoTextSizeLabel:_progressLabel font:_labelFont labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(0, 0, _radius * 2.0, _radius * 2.0) text:percentStr textColor:_labelTextColor];
    _progressLabel.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
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
    _progressBgView.frame = SNSRect(0, 0, progressBgImg.size.width, progressBgImg.size.height);
    _progressBgView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
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
    _progressFrontView.frame = SNSRect(0, 0, progressFrontImg.size.width, progressFrontImg.size.height);
    _progressFrontView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    _progressFrontView.image = progressFrontImg;
}

-(void)doSetProgressValue:(CGFloat)progress
{
    _progressValue = MIN(MAX(progress, 0.0), 1.0);
    
    int percent = _progressValue * 100;
    NSString *percentStr = [NSString stringWithFormat:@"%d%%",percent];
    [Utils autoTextSizeLabel:_progressLabel font:_labelFont labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(0, 0, _radius * 2.0, _radius * 2.0) text:percentStr textColor:_labelTextColor];
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

@implementation CircleView
@synthesize circleWidth = _circleWidth;
@synthesize circleRadius = _circleRadius;
@synthesize circlePercent = _circlePercent;
@synthesize circleColor = _circleColor;

- (id)initWithRadius:(CGFloat)radius circleWidth:(CGFloat)width circleColor:(UIColor *)color circlePercent:(CGFloat)percent
{
    self = [super init];
    if (self) {
        _circleRadius = radius;
        _circleWidth = width;
        _circleColor = [color retain];
        _circlePercent = percent;
        self.frame = SNSRect(self.frame.origin.x, self.frame.origin.y, _circleRadius * 2.0 + _circleWidth + 2, _circleRadius * 2.0 + _circleWidth + 2);
        self.layer.shouldRasterize = YES;
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat radian_start = -90.0f * M_PI / 180.0f;
    CGFloat radian_end = radian_start + 2.0f * M_PI *_circlePercent;
    CGPoint circlePoint = CGPointMake(rect.size.width/2, rect.size.width/2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _circleWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFlatness(context, 0.0f);
    CGContextSetStrokeColorWithColor(context, [_circleColor CGColor]);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circlePoint radius:_circleRadius startAngle:radian_start endAngle:radian_end clockwise:YES];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

-(void)dealloc
{
    [_circleColor release];
    [super dealloc];
}

-(void)setCircleColor:(UIColor *)circleColor
{
    if (_circleColor != circleColor)
    {
        [_circleColor release];
        _circleColor = [circleColor retain];
    }
    [self setNeedsDisplay];
}
-(void)setCirclePercent:(CGFloat)circlePercent
{
    _circlePercent = circlePercent;
    [self setNeedsDisplay];
}
-(void)setCircleRadius:(CGFloat)circleRadius
{
    _circleRadius = circleRadius;
    self.frame = SNSRect(self.frame.origin.x, self.frame.origin.y, _circleRadius * 2.0 + _circleWidth + 1, _circleRadius * 2.0 + _circleWidth + 1);
    [self setNeedsDisplay];
}
-(void)setCircleWidth:(CGFloat)circleWidth
{
    _circleWidth = circleWidth;
    self.frame = SNSRect(self.frame.origin.x, self.frame.origin.y, _circleRadius * 2.0 + _circleWidth + 1, _circleRadius * 2.0 + _circleWidth + 1);
    [self setNeedsDisplay];
}

@end
