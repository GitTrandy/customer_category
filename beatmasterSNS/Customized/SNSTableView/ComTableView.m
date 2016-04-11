//
//  ComTableView.m
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-14.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import "ComTableView.h"
//#import "SNSTableView.h"

@interface ComTableView ()

@property(nonatomic, assign) BOOL isFirstShow;      //滚动条是否第一次出现
@property(nonatomic, assign) BOOL isLoadingData;    //是否正在刷新数据
@property(nonatomic, assign) float lineWidth;       //滚动条宽度
@property(nonatomic, assign) float lineHeight;      //滚动条高度
//上下拉刷新view
@property(nonatomic, assign) ComFreshTableView *refreshTableViewHeader;
@property(nonatomic, assign) ComFreshTableView *refreshTableViewFooter;
@property(nonatomic, assign) NSTimer *timer;        //拖动结束后的time,用来更新滚动条

@end

@implementation ComTableView

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.showsVerticalScrollIndicator = NO;     //隐藏滚动条
//        self.indicatorStyle=UIScrollViewIndicatorStyleWhite;
//        self.separatorStyle = NO;                   //去掉分割线
        self.bounces = YES;
        self.freshStyle = _refreshDefalut;
        _footerStyle = UnderBound;
        
        //滚动条
        _isFirstShow = YES;
        _lineWidth = 8.f*COM_SCALE;
        _lineHeight = 90.0f*COM_SCALE;
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth, _lineHeight)];
        _lineView.transform = CGAffineTransformMakeScale(COM_SCALE,COM_SCALE);
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
        self.lineMargin = 0;
        
        //下拉刷新
        _refreshTableViewHeader = [[ComFreshTableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f-self.bounds.size.height, self.frame.size.width, self.bounds.size.height) isHeaderView:YES];
        _refreshTableViewHeader.delegate = self;
        [self addSubview:_refreshTableViewHeader];
        
        //上拉刷新
        _refreshTableViewFooter = [[ComFreshTableView alloc]initWithFrame:CGRectMake(0.0f, MAX(self.contentSize.height, self.bounds.size.height), self.frame.size.width, self.bounds.size.height) isHeaderView:NO];
        [self setFootFreshViewFrame];
        _refreshTableViewFooter.delegate = self;
        [self addSubview:_refreshTableViewFooter];
        
        [self.panGestureRecognizer addTarget:self action:@selector(move)];
        
        _timer = nil;
    }
    return self;
}

-(void) update
{
    if (self.decelerating)
    {
        //正在惯性移动,现在不做事
    }
    else
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
            if (!_isLoadingData)
            {
                [self doSetHideAnimation];
            }
        }
        [self setFootFreshViewFrame];
    }
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setFootFreshViewFrame];
    _refreshTableViewHeader.frame = CGRectMake(0, 0.0f-self.bounds.size.height, self.frame.size.width, self.bounds.size.height);
}

-(void) setFooterStyle:(RefrehFooterStyle)footerStyle
{
    _footerStyle = footerStyle;
    [self setFootFreshViewFrame];
}

-(void) setFootFreshViewFrame
{
    _refreshTableViewFooter.frame = CGRectMake(_refreshTableViewFooter.frame.origin.x, MAX(self.contentSize.height, self.bounds.size.height), _refreshTableViewFooter.frame.size.width, _refreshTableViewFooter.frame.size.height);
    
    if (self.contentSize.height < self.bounds.size.height && _footerStyle == UnderContensize)
    {
        _refreshTableViewFooter.frame = CGRectMake(_refreshTableViewFooter.frame.origin.x, self.contentSize.height, _refreshTableViewFooter.frame.size.width, _refreshTableViewFooter.frame.size.height);
        _refreshTableViewFooter.hidden = YES;
    }
}

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFreshStyle:(RefreshStyle) freshStyle
{
    if (self = [self initWithFrame:frame style:style])
    {
        self.freshStyle = freshStyle;
    }
    return self;
}

-(void) move
{
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (_timer != nil && [_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (1 != self.decelerating) {
            [self doSetHideAnimation];
        }
        else
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(update) userInfo:nil repeats:YES];
        }
        
        if (self.contentOffset.y <= 0.0 && (_freshStyle == _refreshHeader || _freshStyle == _refreshAll))
        {
            [_refreshTableViewHeader tableRefreshScrollViewDidEndDragging:self];
        }
        if (self.contentOffset.y > 0.0 && (_freshStyle == _refreshFooter || _freshStyle == _refreshAll))
        {
            [_refreshTableViewFooter tableRefreshScrollViewDidEndDragging:self];
        }
    }
}

-(void)doSetScrollLineViewFrame
{
    CGRect lineFrame = CGRectZero;
    CGFloat contentOffsetY = self.contentOffset.y;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat scrollViewWidth = self.bounds.size.width;
    CGFloat scrollViewHeight = self.bounds.size.height;
    
    // // 不超过屏幕的时候不显示
    if (contentHeight <= scrollViewHeight || _isFirstShow)
    {
        _isFirstShow = NO;
        [_lineView setAlpha:0.0f];
        return;
    }
    else
    {
        [_lineView setAlpha:1.0f];
    }
    
    contentHeight = MAX(contentHeight,scrollViewHeight+1);
    _lineHeight = MAX(scrollViewHeight * scrollViewHeight / contentHeight, COM_MinLineHeight);
    lineFrame.origin.x = scrollViewWidth - _lineWidth+2.0f*COM_SCALE+_lineMargin;
    
    lineFrame.origin.y = 0.0f;
    lineFrame.size.width = _lineWidth;
    lineFrame.size.height = _lineHeight;
    if (self.contentOffset.y <= 0)
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
    
    _lineView.frame = lineFrame;
    
}

-(void)doSetHideAnimation
{
    [UIView beginAnimations:@"HideAni" context:nil];
    [UIView setAnimationDuration:COM_HideTime];
    [_lineView setAlpha:0.0f];
    [UIView commitAnimations];
}

-(void) setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
    [self doSetScrollLineViewFrame];
}

-(void) setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    if (self.dragging || self.decelerating)
    {
        [self doSetScrollLineViewFrame];
    }
    
    if (self.contentOffset.y <= 0 && (_freshStyle == _refreshHeader || _freshStyle == _refreshAll))
    {
        [_refreshTableViewHeader tableRefreshScrollViewDidScroll:self];
    }
    if (self.contentOffset.y > 0 && (_freshStyle == _refreshFooter || _freshStyle == _refreshAll))
    {
        [_refreshTableViewFooter tableRefreshScrollViewDidScroll:self];
        _refreshTableViewFooter.hidden = NO;
    }
}

-(void) dealloc
{
    [_lineView removeFromSuperview];
    [_lineView release];
    _lineView = nil;
    
    [_refreshTableViewHeader removeFromSuperview];
    [_refreshTableViewHeader release];
    _refreshTableViewHeader = nil;
    
    [_refreshTableViewFooter removeFromSuperview];
    [_refreshTableViewFooter release];
    _refreshTableViewFooter = nil;
    
    _timer = nil;
    [super dealloc];
}

-(void) reloadData
{
    [super reloadData];
    
    if (_refreshTableViewFooter)
    {
        [self setFootFreshViewFrame];
    }
}

-(void) setFreshStyle:(RefreshStyle)freshStyle
{
    _freshStyle = freshStyle;
    switch (_freshStyle)
    {
        case _refreshDefalut:
        {
            _refreshTableViewHeader.hidden = YES;
            _refreshTableViewFooter.hidden = YES;
        }
            break;
        case _refreshHeader:
        {
            _refreshTableViewHeader.hidden = NO;
            _refreshTableViewFooter.hidden = YES;
        }
            break;
        case _refreshFooter:
        {
            _refreshTableViewHeader.hidden = YES;
            _refreshTableViewFooter.hidden = NO;
        }
            break;
        case _refreshAll:
        {
            _refreshTableViewHeader.hidden = NO;
            _refreshTableViewFooter.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)didRefreshTableViewDataHeader
{
    _isLoadingData = NO;
	[_refreshTableViewHeader tableRefreshScrollViewDateSourceDidFinishedLoading:self];
}

-(void)didRefreshTableViewDataFooter
{
    _isLoadingData = NO;
    [_refreshTableViewFooter tableRefreshScrollViewDateSourceDidFinishedLoading:self];
}

-(void) freshDataOverCallBack
{
    if (self.contentOffset.y <= 0.0 && (_freshStyle == _refreshHeader || _freshStyle == _refreshAll))
    {
        [self didRefreshTableViewDataHeader];
    }
    if (self.contentOffset.y > 0.0 && (_freshStyle == _refreshFooter || _freshStyle == _refreshAll))
    {
        [self didRefreshTableViewDataFooter];
    }
    [self reloadData];
    [self doSetHideAnimation];
}

#pragma mark- RefreshTableViewDelegate
-(void)tableRefreshDelegateDidLoadingData:(ComFreshTableView *)view
{
    _isLoadingData = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewFreshingData:)])
    {
        [self.delegate tableViewFreshingData:self];
    }
}

-(BOOL)tableRefreshDelegateIsLoadingState:(ComFreshTableView *)view
{
    return _isLoadingData;
}

@end
