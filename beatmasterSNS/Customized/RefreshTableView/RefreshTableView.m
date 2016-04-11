//
//  RefreshTableView.m
//  RefreshTableView
//
//  Created by chengsong on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshTableView.h"

@interface  RefreshTableView ()

-(void)createView:(CGRect)frame;
-(void)refreshStateSetting:(RefreshState)state;
@end

@implementation RefreshTableView
@synthesize delegate = _delegate;
@synthesize bIsFollowLastCell = _bIsFollowLastCell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // // 确定是顶端刷新还是底部刷新
        if (frame.origin.y < 0)
        {
            // // 顶端
            bIsHeadView = YES;
        }
        else 
        {
            bIsHeadView = NO;
        }
        
        // // 初始化刷新页面信息
        [self createView:frame];
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

#pragma mark -
#pragma mark dealloc
-(void)dealloc
{
    [_stateLabel release];
    [_activeView release];
    [super dealloc];
    SNSLog(@"%s",__FUNCTION__);
}

#pragma mark -
#pragma mark private methods

-(void)createView:(CGRect)frame
{
    // // 确定 Label和activeIndicator在本View中的位置的Y坐标
    CGFloat yAxis = 0.0f; 
    if (bIsHeadView)
    {
        yAxis = frame.size.height - 30.0f*SNS_SCALE;
    }
    else 
    {
        yAxis = 0.0;
    }
    
    // self view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    // state label
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, yAxis, frame.size.width, 20.f*SNS_SCALE)];
    _stateLabel.textAlignment = UITextAlignmentCenter;
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.adjustsFontSizeToFitWidth = YES;
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.font = [UIFont systemFontOfSize:18.f*SNS_SCALE];
    _stateLabel.text = @"test";
    [self addSubview:_stateLabel];
    
    // activeIndicator
    _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activeView.frame = CGRectMake(_stateLabel.frame.origin.x - 25.0f*SNS_SCALE, yAxis, 20.0f*SNS_SCALE, 20.0f*SNS_SCALE);
    [_activeView startAnimating];
    [self addSubview:_activeView];
    
    [self refreshStateSetting:RefreshStateNeedPull];
}

-(void)refreshStateSetting:(RefreshState)state
{
    switch (state)
    {
        case RefreshStateNeedPull:
            if (bIsHeadView)
            {
                _stateLabel.text = MultiLanguage(rtvLNeedPull_Header);//MultiLanguage(rtvLDownRefresh);
            }
            else 
            {
                _stateLabel.text = MultiLanguage(rtvLNeedPull_Footer);//MultiLanguage(rtvLUpRefresh);
            }
            
            [_activeView stopAnimating];
            break;
        case RefreshStateReadyForLoading:
            if (bIsHeadView)
            {
                _stateLabel.text = MultiLanguage(rtvLForLoading_Header);
            }
            else
            {
                _stateLabel.text = MultiLanguage(rtvLForLoading_Footer);
            }
            //_stateLabel.text = MultiLanguage(rtvLUpRefresh);
            break;
        case RefreshStateIsLoading:
            if (bIsHeadView)
            {
                _stateLabel.text = MultiLanguage(rtvLIsLoading_Header);
            }
            else
            {
                _stateLabel.text = MultiLanguage(rtvLIsLoading_Footer);
            }
            //_stateLabel.text = MultiLanguage(rtvLUpdata);
            [_activeView startAnimating];
            break;
            
        default:
            _stateLabel.text = @"";
            break;
    }
    
    _refreshState = state;
}

#pragma mark -
#pragma mark interface methods
-(void)tableRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    // // 当数据条数的高度 没有超过Table高度 的时候，Table底部的刷新View不显示
    if (self.frame.origin.y>=0 && self.frame.origin.y<self.frame.size.height && !_bIsFollowLastCell)
    {
        _stateLabel.text = @"";
        [_activeView stopAnimating];
        return;
    }
    // // 
    
//    CGFloat contentSizeHeight = scrollView.contentSize.height;
//    CGFloat contentOffset_y = scrollView.contentOffset.y+scrollView.bounds.size.height;
    // // test
    
    // // ScrollView整个内容的高度
    CGFloat contentSizeHeight = scrollView.contentSize.height;
    
    // // 1、headerView:手机顶端相对ScrollView原点的高度 2、footerView:手机底端相对ScrollView原点的高度
    CGFloat contentOffset_y = 0.0f;
    
    // // 1、headerView:手机顶端出现的空白高度(UIEdgeInset.top) 2、footerView:手机底端出现的空白高度(UIEdgeInset.bottom)
    CGFloat edgeOffset = 0.0;
    if (bIsHeadView)
    {
        contentOffset_y = scrollView.contentOffset.y * (-1);
        edgeOffset = MAX(contentOffset_y, 0);
    }
    else 
    {
        contentOffset_y = scrollView.contentOffset.y+scrollView.bounds.size.height;
        edgeOffset = MAX(contentOffset_y, contentSizeHeight) -  MAX(scrollView.bounds.size.height, contentSizeHeight);
    }
    
    // // isLoading...
    if (_refreshState == RefreshStateIsLoading) 
    {
//        CGFloat offset = MAX(contentOffset_y, contentSizeHeight);
//        offset = MIN(offset-contentSizeHeight, UIEdgeInsetBottomHeight);
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
        CGFloat offset = 0.0f;
        if (bIsHeadView)
        {
            offset = MAX(contentOffset_y, 0);
            offset = MIN(offset, UIEdgeInsetViewHeight);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
        }
        else 
        {
            //offset = MAX(contentOffset_y, contentSizeHeight);
            //offset = MIN(offset-contentSizeHeight, UIEdgeInsetViewHeight);
            //scrollView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
            
            offset = MAX(contentOffset_y, contentSizeHeight);
            offset = MIN(offset-contentSizeHeight, UIEdgeInsetViewHeight);
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, offset + MAX((scrollView.bounds.size.height - contentSizeHeight), 0), 0);
        }
    }
    else if(scrollView.isDragging)
    {
        // // 是否正在更新
        BOOL bLoading = NO;
        if (_delegate != nil && [_delegate respondsToSelector:@selector(tableRefreshDelegateIsLoadingState:)])
        {
            bLoading = [_delegate tableRefreshDelegateIsLoadingState:self];
        }
        
        if (_refreshState == RefreshStateReadyForLoading && edgeOffset < 60 && !bLoading)
        {
            // // 偏移量小于60的时候显示NeedPull状态
            [self refreshStateSetting:RefreshStateNeedPull];
        }
        else if (_refreshState == RefreshStateNeedPull && edgeOffset >= 60 && !bLoading)
        {
            // // 偏移量小于60的时候显示ReadyForLoading状态
            [self refreshStateSetting:RefreshStateReadyForLoading];
        }
        
    }
}
-(void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    // // 当数据条数的高度 没有超过Table高度 的时候，Table底部的刷新View不显示
    if (self.frame.origin.y>=0 && self.frame.origin.y<self.frame.size.height && !_bIsFollowLastCell)
    {
        _stateLabel.text = @"";
        [_activeView stopAnimating];
        if (_delegate != nil)
        {
            [_delegate tableRefreshDelegateDidLoadingData:self];
        }
        
        return;
    }
    // // 
    
    
//    CGFloat contentSizeHeight = scrollView.contentSize.height;
//    CGFloat contentOffset_y = scrollView.contentOffset.y+scrollView.bounds.size.height;
//    SNSLog(@"height:%f , _y:%f",contentSizeHeight,contentOffset_y);
    
    // // ScrollView整个内容的高度
    CGFloat contentSizeHeight = scrollView.contentSize.height;
    
    // // 1、headerView:手机顶端相对ScrollView原点的高度 2、footerView:手机底端相对ScrollView原点的高度
    CGFloat contentOffset_y = 0.0f;
    
    // // 1、headerView:手机顶端出现的空白高度(UIEdgeInset.top) 2、footerView:手机底端出现的空白高度(UIEdgeInset.bottom)
    CGFloat edgeOffset = 0.0;
    if (bIsHeadView)
    {
        contentOffset_y = scrollView.contentOffset.y * (-1);
        edgeOffset = MAX(contentOffset_y, 0);
    }
    else 
    {
        contentOffset_y = scrollView.contentOffset.y+scrollView.bounds.size.height;
        edgeOffset = MAX(contentOffset_y, contentSizeHeight) -  MAX(scrollView.bounds.size.height, contentSizeHeight);
    }
    
    // // 是否正在更新
    BOOL bLoading = NO;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tableRefreshDelegateIsLoadingState:)])
    {
        bLoading = [_delegate tableRefreshDelegateIsLoadingState:self];
    }
    
    if (edgeOffset >= 60 && !bLoading)
    {
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(tableRefreshDelegateDidLoadingData:)])
        {
            // // 更新加载数据
            [_delegate tableRefreshDelegateDidLoadingData:self];
        }
        [self refreshStateSetting:RefreshStateIsLoading];
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, UIEdgeInsetViewHeight, 0);
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        if (bIsHeadView)
        {
            scrollView.contentInset = UIEdgeInsetsMake(UIEdgeInsetViewHeight, 0.0f, 0.0f, 0.0f);
        }
        else {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, UIEdgeInsetViewHeight, 0);
        }
		
		[UIView commitAnimations];
    }
}
-(void)tableRefreshScrollViewDateSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    SNSLog(@"scrollViewOFFSETBefore1:%f",scrollView.contentOffset.y);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //CGPoint point = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-30);//-UIEdgeInsetViewHeight);
    //CGPoint point = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-UIEdgeInsetViewHeight);
    //scrollView.contentOffset = point;
    [UIView commitAnimations];
    SNSLog(@"scrollViewOFFSETBefore2:%f",scrollView.contentOffset.y);
    [self refreshStateSetting:RefreshStateNeedPull];
    
}



@end
