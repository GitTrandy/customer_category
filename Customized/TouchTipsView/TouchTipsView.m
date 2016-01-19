//
//  TouchTipsView.m
//  TipsView
//
//  Created by chengsong on 13-8-20.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import "TouchTipsView.h"

static TouchTipsView *s_shareTouchTipsView = nil;

@implementation TouchTipsView
@synthesize tipsText = _tipsText;
@synthesize autoShowOrientation = _autoShowOrientation;
@synthesize margin = _margin;
@synthesize tipsBgImg = _tipsBgImg, labelFont = _labelFont, textColor = _textColor, isTipsBgSizeFitText = _isTipsBgSizeFitText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self variablesInitialization];
        [self createTouchTipsView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame orien:(TouchTipsShow)orien text:(NSString *)text margin:(CGFloat)margin
{
    self = [super initWithFrame:frame];
    if (self) {
        // // init codes
        _touchTipsShowOrientation = orien;
        self.tipsText = text;
        _margin = margin;
        
        [self variablesInitialization];
        [self createTouchTipsView];
    }
    
    return self;
}

+(id)sharedTouchTipsView
{
    if (s_shareTouchTipsView == nil)
    {
        s_shareTouchTipsView = [[self alloc]initWithFrame:SNSRect(0, 0, 50.0f*SNS_SCALE, 50.0f*SNS_SCALE)];
        s_shareTouchTipsView.autoShowOrientation = YES;
        s_shareTouchTipsView.margin = 10.0f*SNS_SCALE;
    }
    return s_shareTouchTipsView;
}
+(void)releaseSharedTouchTipsView
{
    if (s_shareTouchTipsView != nil)
    {
        [s_shareTouchTipsView release];
        s_shareTouchTipsView = nil;
    }
}

-(void)popTouchTipsView:(CGRect)targetFrame orien:(TouchTipsShow)orien text:(NSString *)text margin:(CGFloat)margin withBgImg:(UIImage *)bgImg bgSizeFitText:(BOOL)isBgSizeFitText font:(UIFont *)labelFont textColor:(UIColor *)textColor
{
    self.frame = targetFrame;
    self.tipsText = text;
    self.margin = margin;
    self.tipsBgImg = bgImg;
    self.labelFont = labelFont;
    self.textColor = textColor;
    
    _isTipsBgSizeFitText = isBgSizeFitText;
    _touchTipsShowOrientation = orien;
    if (orien == TouchTipsShowDefault)
    {
        _autoShowOrientation = YES;
    }
    else
    {
        _autoShowOrientation = NO;
    }
    
    _curCenterPoint.x = targetFrame.origin.x + targetFrame.size.width/2.0f;
    _curCenterPoint.y = targetFrame.origin.y + targetFrame.size.height/2.0f;
    if (_autoShowOrientation)
    {
        [self checkOrientation];
    }
    
    [self doChangeLayoutAfterTouch];
}

-(void)dealloc
{
    [self dismissPopTipsView];
    
    self.tipsText = nil;
    
    self.tipsBgImg = nil;
    self.labelFont = nil;
    self.textColor = nil;
    
    [super dealloc];
    //NSLog(@"%s",__FUNCTION__);
}

-(void)variablesInitialization
{
    _touchTipsShowOrientation = TouchTipsShowDefault;
    _mapView = [[[UIApplication sharedApplication].delegate window] rootViewController].view;
    _curCenterPoint = CGPointZero;
    _margin = 0.0f;
    _popTipsView = nil;
    _tipsBg = nil;
    _tipsBgImg = nil;
    _isTipsBgSizeFitText = YES;
    _tipsText = @"这是一个提示...";
    _tipsLabel = nil;
    _labelFont = nil;
    _textColor = nil;
    _autoShowOrientation = NO;
}

-(void)createTouchTipsView
{
    self.backgroundColor = [UIColor clearColor];
}
-(void)createPopTipsView
{
    [self dismissPopTipsView];
    
    _popTipsView = [[PopTipsView alloc]initWithFrame:SNSRect(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT) withTarget:self];
    [_mapView addSubview:_popTipsView];
    
    if (_tipsBgImg == nil || ![_tipsBgImg isKindOfClass:[UIImage class]])
    {
        _isTipsBgSizeFitText = YES;
        _tipsBgImg = [[[UIImage imageNamed:@"Com_TouchTipsBg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)]retain];
        
    }
    _tipsBg = [[UIImageView alloc]initWithImage:_tipsBgImg];
    [_popTipsView addSubview:_tipsBg];
    
    _tipsLabel = [[UILabel alloc]init];
    _tipsLabel.text = _tipsText;
    _tipsLabel.textColor = _textColor!=nil ? _textColor : [UIColor whiteColor];
    _tipsLabel.font = _labelFont!=nil ? _labelFont : [UIFont boldSystemFontOfSize:12.0f*SNS_SCALE];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textAlignment = NSTextAlignmentLeft;
    _tipsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _tipsLabel.backgroundColor = [UIColor clearColor];
    [_popTipsView addSubview:_tipsLabel];
    
}
-(void)dismissPopTipsView
{
    if (_popTipsView != nil)
    {
        [_popTipsView removeFromSuperview];
        [_popTipsView release];
        _popTipsView = nil;
    }
    if (_tipsBg != nil)
    {
        [_tipsBg release];
        _tipsBg = nil;
    }
    if (_tipsLabel != nil)
    {
        [_tipsLabel release];
        _tipsLabel = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    [self calcCenterPoint:touch];
    
    if (_autoShowOrientation)
    {
        [self checkOrientation];
    }
    
    [self doChangeLayoutAfterTouch];
    
}

/*
 *  @brief: 计算self的中心在屏幕上的位置
 */
-(void)calcCenterPoint:(UITouch *)touch
{
    CGPoint localPoint = [touch locationInView:self];
    CGPoint mapPoint = [touch locationInView:_mapView];
    CGFloat centerOffsetX = localPoint.x - self.bounds.size.width/2.0f;
    CGFloat centerOffsetY = localPoint.y - self.bounds.size.height/2.0f;
    _curCenterPoint.x = mapPoint.x - centerOffsetX;
    _curCenterPoint.y = mapPoint.y - centerOffsetY;
}

-(void)doChangeLayoutAfterTouch
{
    [self createPopTipsView];
    
    [self doTipsBgAndTextLabelLayout];
    
}
-(void)doTipsBgAndTextLabelLayout
{
    CGSize labelSize = [_tipsText sizeWithFont:_tipsLabel.font constrainedToSize:TTV_MaxLabelSize lineBreakMode:_tipsLabel.lineBreakMode];
    
    CGSize tipsBgSize = CGSizeZero;
    if (_isTipsBgSizeFitText)
    {
        tipsBgSize = CGSizeMake(labelSize.width + 8.0f*SNS_SCALE, labelSize.height + 8.0f*SNS_SCALE);
    }
    else
    {
        if (_tipsBgImg != nil)
        {
            tipsBgSize = CGSizeMake(_tipsBgImg.size.width*SNS_SCALE, _tipsBgImg.size.height*SNS_SCALE);
        }
    }
    
    CGRect tipsBgRect = [self calcTipsBgFrame:tipsBgSize];
    
    _tipsBg.frame = tipsBgRect;
    
    _tipsLabel.frame = CGRectMake(0.0f, 0.0f, labelSize.width, labelSize.height);
    _tipsLabel.center = _tipsBg.center;
}

/*
 *  @brief: 提示bgview的frame
 */
-(CGRect)calcTipsBgFrame:(CGSize)bgSize
{
    CGRect  tipsBgRect = CGRectZero;
    tipsBgRect.size = bgSize;
    CGSize selfSize = self.frame.size;
    
    switch (_touchTipsShowOrientation)
    {
        case TouchTipsShowDefault:
            tipsBgRect.origin.x = _popTipsView.bounds.size.width/2.0f - bgSize.width/2.0f;
            tipsBgRect.origin.y = _popTipsView.bounds.size.height/2.0f - bgSize.height/2.0f;
            break;
        case TouchTipsShowTop:
            tipsBgRect.origin.x = MAX(_curCenterPoint.x - bgSize.width/2.0f, TTV_edgeWidth);
            tipsBgRect.origin.y = _curCenterPoint.y - selfSize.height/2.0f - bgSize.height - _margin;
            break;
        case TouchTipsShowBot:
            tipsBgRect.origin.x = MAX(_curCenterPoint.x - bgSize.width/2.0f, TTV_edgeWidth);
            tipsBgRect.origin.y = _curCenterPoint.y + selfSize.height/2.0f + _margin;
            break;
        case TouchTipsShowLeft:
            tipsBgRect.origin.x = MAX(_curCenterPoint.x - selfSize.width/2.0f - bgSize.width - _margin, TTV_edgeWidth);
            tipsBgRect.origin.y = _curCenterPoint.y - bgSize.height/2.0f;
            break;
        case TouchTipsShowRight:
            tipsBgRect.origin.x = MIN(_curCenterPoint.x + selfSize.width/2.0f + _margin, _popTipsView.bounds.size.width - bgSize.width - TTV_edgeWidth);
            tipsBgRect.origin.y = _curCenterPoint.y - bgSize.height/2.0f;
            break;
            
        default:
            break;
    }
    
    return tipsBgRect;
}
/*
 *         1     |     2
 *    -----------|------------
 *         3     |     4
 *    ------------------------
 *         3     |     4      
 *    -----------|------------
 *         5     |     6
 */
-(void)checkOrientation
{
    CGRect rect_1 = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/4.0f);
    CGRect rect_2 = CGRectMake(SCREEN_WIDTH/2.0f, 0.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/4.0f);
    CGRect rect_3 = CGRectMake(0.0f, SCREEN_HEIGHT/4.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f);
    CGRect rect_4 = CGRectMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/4.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f);
    CGRect rect_5 = CGRectMake(0.0f, SCREEN_HEIGHT*3.0f/4.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/4.0f);
    CGRect rect_6 = CGRectMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT*3.0f/4.0f, SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/4.0f);
    
    if (CGRectContainsPoint(rect_1, _curCenterPoint) || CGRectContainsPoint(rect_2, _curCenterPoint))
    {
        _touchTipsShowOrientation = TouchTipsShowBot;
    }
    else if (CGRectContainsPoint(rect_3, _curCenterPoint))
    {
        _touchTipsShowOrientation = TouchTipsShowRight;
    }
    else if (CGRectContainsPoint(rect_4, _curCenterPoint))
    {
        _touchTipsShowOrientation = TouchTipsShowLeft;
    }
    else if (CGRectContainsPoint(rect_5, _curCenterPoint) || CGRectContainsPoint(rect_6, _curCenterPoint))
    {
        _touchTipsShowOrientation = TouchTipsShowTop;
    }
    
}

@end
