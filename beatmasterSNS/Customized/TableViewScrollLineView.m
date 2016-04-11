//
//  TableViewScrollLineView.m
//  beatmasterSNS
//
//  Created by chengsong on 13-4-24.
//
//

#import "TableViewScrollLineView.h"

@implementation TableViewScrollLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithSuperScrollView:(UIScrollView *)scrollView lineStyle:(ScrollLineStyle)style margin:(CGFloat)margin
{
    self = [super init];
    if (self) {
        // // init codes
        
        if ([scrollView isKindOfClass:[UIScrollView class]])
        {
            _superScrollView = scrollView;
        }
        else
        {
            _superScrollView = nil;
        }
        
        _lineStyle = style;
        _lineMargin = margin;
        _isFirstShow = YES;
        
        [self createView];
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    SNSLog(@"%s",__FUNCTION__);
}


#pragma mark - private methods

/*
 *  @brief: 创建内容
 */
-(void)createView
{
    if (_superScrollView == nil)
    {
        return;
    }
    
    NSString *lineStr = [NSString stringWithFormat:@"ScrollLineStyle_%02d.png",_lineStyle];
    UIImage *lineImg = [UIImage imageNamed_New:lineStr];
    UIImage *lineImgNew = [lineImg resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
    UIImageView *line = [[UIImageView alloc]initWithImage:lineImgNew];
    line.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (IS_IPAD)
    {
        line.transform = CGAffineTransformMakeScale(SNS_SCALE, SNS_SCALE);
    }
    
    _lineWidth = 8.0f*SNS_SCALE;
    _lineHeight = 90.0f*SNS_SCALE;
    line.frame = SNSRect(0, 0, _lineWidth, _lineHeight);
    self.frame = SNSRect(0, 0, _lineWidth, _lineHeight);
    
    [self addSubview:line];
    [line release];
    
}
/*
 *  @brief: 设置Scroll Line 的位置和长度
 */
-(void)doSetScrollLineViewFrame
{
    if (_superScrollView == nil || ![_superScrollView isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    
    CGRect lineFrame = CGRectZero;
    CGFloat contentOffsetY = _superScrollView.contentOffset.y;
    CGFloat contentHeight = _superScrollView.contentSize.height;
    CGFloat scrollViewWidth = _superScrollView.bounds.size.width;
    CGFloat scrollViewHeight = _superScrollView.bounds.size.height;
    
    // // 不超过屏幕的时候不显示
    if (contentHeight <= scrollViewHeight || _isFirstShow)
    {
        _isFirstShow = NO;
        [self setAlpha:0.0f];
        return;
    }
    else
    {
        [self setAlpha:1.0f];
    }
    
    contentHeight = MAX(contentHeight,scrollViewHeight+1);
    _lineHeight = MAX(scrollViewHeight * scrollViewHeight / contentHeight, TVSLV_MinLineHeight);
    lineFrame.origin.x = scrollViewWidth - _lineWidth+2.0f*SNS_SCALE+_lineMargin;
    
    lineFrame.origin.y = 0.0f;
    lineFrame.size.width = _lineWidth;
    lineFrame.size.height = _lineHeight;
    if (_superScrollView.contentOffset.y <= 0)
    {
        // // 往下拉
        lineFrame.size.height = (1.0 - 2.0f*(contentOffsetY * (-1)/scrollViewHeight))*_lineHeight;
        lineFrame.origin.y += contentOffsetY;
    }
    else if(contentOffsetY > contentHeight - scrollViewHeight)
    {
        // // 往上拉
        lineFrame.size.height = (1.0 - 2.0f*((contentOffsetY - (contentHeight-scrollViewHeight))/scrollViewHeight))*(_lineHeight);
        lineFrame.origin.y += (contentOffsetY + scrollViewHeight - lineFrame.size.height);
    }
    else
    {
        // // 在中间
        lineFrame.origin.y += contentOffsetY + (contentOffsetY / (contentHeight-scrollViewHeight)) * (scrollViewHeight-_lineHeight);
    }
    
    self.frame = lineFrame;
    
}

/*
 *  @brief: scroll line 隐藏动画
 */
-(void)doSetHideAnimation
{
    [UIView beginAnimations:@"HideAni" context:nil];
    [UIView setAnimationDuration:TVSLV_HideTime];
    [self setAlpha:0.0f];
    [UIView commitAnimations];
}

@end
