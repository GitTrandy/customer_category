//
//  ComFreshTableView.m
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-16.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import "ComFreshTableView.h"

@interface  ComFreshTableView ()

-(void)createView:(CGRect)frame;
-(void)refreshStateSetting:(COM_RefreshState)state;
@end

@implementation ComFreshTableView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame isHeaderView:(BOOL) isHead
{
    self = [super initWithFrame:frame];
    if (self) {
        
        bIsHeadView = isHead;
        
        // // 初始化刷新页面信息
        [self createView:frame];
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        // // 确定是顶端刷新还是底部刷新
//        if (frame.origin.y < 0)
//        {
//            // // 顶端
//            bIsHeadView = YES;
//        }
//        else
//        {
//            bIsHeadView = NO;
//        }
//        
//        // // 初始化刷新页面信息
//        [self createView:frame];
//    }
//    return self;
//}

#pragma mark -
#pragma mark dealloc
-(void)dealloc
{
    [_stateLabel release];
    [_activeView release];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

-(void)createView:(CGRect)frame
{
    // // 确定 Label和activeIndicator在本View中的位置的Y坐标
    CGFloat yAxis = 0.0f;
    if (bIsHeadView)
    {
        yAxis = frame.size.height - 30.0f;
    }
    else
    {
        yAxis = 0.0;
    }
    
    // self view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    // state label
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, frame.size.width, 20)];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.adjustsFontSizeToFitWidth = YES;
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.text = @"test";
    [self addSubview:_stateLabel];
    
    // activeIndicator
    _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activeView.frame = CGRectMake(25.0f, yAxis, 20.0f, 20.0f);
    [_activeView startAnimating];
    [self addSubview:_activeView];
    
    [self refreshStateSetting:COM_RefreshStateNeedPull];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateSubviewsFrame:frame];
}

-(void) updateSubviewsFrame:(CGRect) frame
{
    // // 确定 Label和activeIndicator在本View中的位置的Y坐标
    CGFloat yAxis = 0.0f;
    if (bIsHeadView)
    {
        yAxis = frame.size.height - 30.0f;
    }
    else
    {
        yAxis = 0.0;
    }
    
    _stateLabel.frame =CGRectMake(0, yAxis, frame.size.width, 20);
    _activeView.frame = CGRectMake(25.0f, yAxis, 20.0f, 20.0f);
}

-(void)refreshStateSetting:(COM_RefreshState)state
{
    switch (state)
    {
        case COM_RefreshStateNeedPull:
            if (bIsHeadView)
            {
                _stateLabel.text = @"下拉启动刷新";
            }
            else
            {
                _stateLabel.text = @"上拉启动刷新";
            }
            
            [_activeView stopAnimating];
            break;
        case COM_RefreshStateReadyForLoading:
            _stateLabel.text = @"松开开始刷新";
            break;
        case COM_RefreshStateIsLoading:
            _stateLabel.text = @"数据更新中...";
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
    //    if (self.frame.origin.y>=0 && self.frame.origin.y<self.frame.size.height)
    //    {
    //        _stateLabel.text = @"";
    //        [_activeView stopAnimating];
    //        return;
    //    }
    
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
    if (_refreshState == COM_RefreshStateIsLoading)
    {
        CGFloat offset = 0.0f;
        if (bIsHeadView)
        {
            offset = MAX(contentOffset_y, 0);
            offset = MIN(offset, COM_UIEdgeInsetViewHeight);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
        }
        else
        {
            offset = MAX(contentOffset_y, contentSizeHeight);
            offset = MIN(offset-contentSizeHeight, COM_UIEdgeInsetViewHeight);
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, offset + MAX((scrollView.bounds.size.height - contentSizeHeight), 0), 0);
        }
    }
    else if(scrollView.isDragging)
    {
        // // 是否正在更新
        BOOL bLoading = NO;
        if ([_delegate respondsToSelector:@selector(tableRefreshDelegateIsLoadingState:)])
        {
            bLoading = [_delegate tableRefreshDelegateIsLoadingState:self];
        }
        
        if (_refreshState == COM_RefreshStateNeedPull && edgeOffset < 60 && !bLoading)
        {
            [self refreshStateSetting:COM_RefreshStateNeedPull];
        }
        else if (_refreshState == COM_RefreshStateReadyForLoading && edgeOffset < 60 && !bLoading)
        {
            // // 偏移量小于60的时候显示NeedPull状态
            [self refreshStateSetting:COM_RefreshStateNeedPull];
        }
        else if (_refreshState == COM_RefreshStateNeedPull && edgeOffset >= 60 && !bLoading)
        {
            // // 偏移量小于60的时候显示ReadyForLoading状态
            [self refreshStateSetting:COM_RefreshStateReadyForLoading];
        }
        
    }
}
-(void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    // // 当数据条数的高度 没有超过Table高度 的时候，Table底部的刷新View不显示
    //    if (self.frame.origin.y>=0 && self.frame.origin.y<self.frame.size.height)
    //    {
    //        _stateLabel.text = @"";
    //        [_activeView stopAnimating];
    //        [_delegate tableRefreshDelegateDidLoadingData:self];
    //        return;
    //    }
    // //
    
    
    //    CGFloat contentSizeHeight = scrollView.contentSize.height;
    //    CGFloat contentOffset_y = scrollView.contentOffset.y+scrollView.bounds.size.height;
    //    NSLog(@"height:%f , _y:%f",contentSizeHeight,contentOffset_y);
    
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
    if ([_delegate respondsToSelector:@selector(tableRefreshDelegateIsLoadingState:)])
    {
        bLoading = [_delegate tableRefreshDelegateIsLoadingState:self];
    }
    
    if (edgeOffset >= 60 && !bLoading)
    {
        
        if ([_delegate respondsToSelector:@selector(tableRefreshDelegateDidLoadingData:)])
        {
            // // 更新加载数据
            [_delegate tableRefreshDelegateDidLoadingData:self];
        }
        [self refreshStateSetting:COM_RefreshStateIsLoading];
        //        scrollView.contentInset = UIEdgeInsetsMake(0, 0, UIEdgeInsetViewHeight, 0);
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        if (bIsHeadView)
        {
            scrollView.contentInset = UIEdgeInsetsMake(COM_UIEdgeInsetViewHeight, 0.0f, 0.0f, 0.0f);
        }
        else {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, COM_UIEdgeInsetViewHeight, 0);
        }
		
		[UIView commitAnimations];
    }
}
-(void)tableRefreshScrollViewDateSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
    [self refreshStateSetting:COM_RefreshStateNeedPull];
}

@end
