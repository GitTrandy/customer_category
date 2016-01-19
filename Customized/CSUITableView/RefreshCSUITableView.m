//
//  RefreshCSUITableView.m
//  beatmasterSNS
//
//  Created by chengsong on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshCSUITableView.h"

@interface RefreshCSUITableView()
-(void)createView:(CGRect)frame;
-(void)refreshStateSetting:(RefreshState)state;
@end

@implementation RefreshCSUITableView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // // 确定是顶端刷新还是底部刷新
        if (frame.origin.x < 0)
        {
            // // 顶端
            bIsHeadView = YES;
        }
        else 
        {
            bIsHeadView = NO;
        }
        [self createView:frame];
    }
    return self;
}

#pragma mark - life circle methods
-(void)dealloc
{
    [_stateLabel release];
    [_activeView release];
    [super dealloc];
    SNSLog(@"%s",__FUNCTION__);
}

#pragma mark - private methods
-(void)createView:(CGRect)frame
{
    // // 确定 Label和activeIndicator在本View中的位置的Y坐标
    CGFloat xAxis = 0.0f; 
    if (bIsHeadView)
    {
        xAxis = frame.size.width - RT_StateLabelWidth;
    }
    else 
    {
        xAxis = 0.0;
    }
    
    // self view
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    
    // state label
//    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xAxis, 0, RT_StateLabelWidth, frame.size.height)];
//    _stateLabel.textAlignment = UITextAlignmentCenter;
//    _stateLabel.textColor = [UIColor whiteColor];
//    _stateLabel.adjustsFontSizeToFitWidth = YES;
//    _stateLabel.backgroundColor = [UIColor clearColor];
//    _stateLabel.text = @"test";
    _stateLabel = [[UILabel alloc]init];
    [Utils autoTextSizeLabel:_stateLabel font:[UIFont boldSystemFontOfSize:20*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignLeft frame:SNSRect(xAxis, 100*SNS_SCALE, RT_StateLabelWidth, frame.size.height) text:@"test" textColor:[UIColor whiteColor]];
    _stateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_stateLabel];
    //_stateLabel.transform = CGAffineTransformMakeRotation(-90*M_PI/180.0f);
    
    // activeIndicator
    _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activeView.frame = CGRectMake(xAxis-5*SNS_SCALE, 70*SNS_SCALE, 20.0f*SNS_SCALE, 20.0f*SNS_SCALE);
    _activeView.color = [UIColor whiteColor]; // 注意：5.0以上才能用
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
                _stateLabel.text = MultiLanguage(rtvLRightRefresh);
            }
            else 
            {
                _stateLabel.text = MultiLanguage(rtvLLeftRefresh);
            }
            
            [_activeView stopAnimating];
            break;
        case RefreshStateReadyForLoading:
            _stateLabel.text = MultiLanguage(rtvLBeginRefresh);
            break;
        case RefreshStateIsLoading:
            _stateLabel.text = MultiLanguage(rtvLUpdata);
            [_activeView startAnimating];
            break;
            
        default:
            _stateLabel.text = @"";
            break;
    }
    
    _refreshState = state;
    //[Utils autoTextSizeLabel:_stateLabel font:[UIFont systemFontOfSize:15] labelAlign:AutoTextSizeLabelAlignLeft frame:SNSRect(15, 100, 15, 320) text:_stateLabel.text textColor:[UIColor whiteColor]];
    [Utils autoTextSizeLabel:_stateLabel font:[UIFont systemFontOfSize:15*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignLeft frame:SNSRect(_stateLabel.frame.origin.x, 100*SNS_SCALE, 15*SNS_SCALE, SCREEN_HEIGHT) text:_stateLabel.text textColor:[UIColor whiteColor]];
    _stateLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - public methods
-(void)tableRefreshDidScroll:(UIScrollView *)scrollView
{
    // // 当数据条数的高度 没有超过Table高度 的时候，Table底部的刷新View不显示
    if (self.frame.origin.x>=0 && self.frame.origin.x<self.frame.size.width)
    {
        _stateLabel.text = @"";
        [_activeView stopAnimating];
        return;
    }
    
    // // ScrollView整个内容的高度
    CGFloat contentSizeWidth = scrollView.contentSize.width;
    
    // // 1、headerView:手机顶端相对ScrollView原点的高度 2、footerView:手机底端相对ScrollView原点的高度
    CGFloat contentOffset_x = 0.0f;
    
    // // 1、headerView:手机顶端出现的空白高度(UIEdgeInset.top) 2、footerView:手机底端出现的空白高度(UIEdgeInset.bottom)
    CGFloat edgeOffset = 0.0;
    if (bIsHeadView)
    {
        contentOffset_x = scrollView.contentOffset.x * (-1);
        edgeOffset = MAX(contentOffset_x, 0);
    }
    else 
    {
        contentOffset_x = scrollView.contentOffset.x+scrollView.bounds.size.width;
        edgeOffset = MAX(contentOffset_x, contentSizeWidth) -  MAX(scrollView.bounds.size.width, contentSizeWidth);
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
            offset = MAX(contentOffset_x, 0);
            offset = MIN(offset, UIEdgeInsetViewWidth);
            scrollView.contentInset = UIEdgeInsetsMake(0, offset, 0, 0);
        }
        else 
        {
            offset = MAX(contentOffset_x, contentSizeWidth);
            offset = MIN(offset-contentSizeWidth, UIEdgeInsetViewWidth);
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, offset);
        }
    }
    else if(scrollView.isDragging)
    {
        // // 是否正在更新
        BOOL bLoading = NO;
        if ([_delegate respondsToSelector:@selector(tableRefreshIsLoading:)])
        {
            bLoading = [_delegate tableRefreshIsLoading:self];
        }
        
        if (_refreshState == RefreshStateReadyForLoading && edgeOffset < 60*SNS_SCALE && !bLoading)
        {
            // // 偏移量小于60的时候显示NeedPull状态
            [self refreshStateSetting:RefreshStateNeedPull];
        }
        else if (_refreshState == RefreshStateNeedPull && edgeOffset >= 60*SNS_SCALE && !bLoading)
        {
            // // 偏移量小于60的时候显示ReadyForLoading状态
            [self refreshStateSetting:RefreshStateReadyForLoading];
        }
        
    }
    
}

-(void)tableRefreshDidEndDragging:(UIScrollView *)scrollView
{
    // // 当数据条数的高度 没有超过Table高度 的时候，Table底部的刷新View不显示
    if (self.frame.origin.x>=0 && self.frame.origin.x<self.frame.size.width)
    {
        _stateLabel.text = @"";
        [_activeView stopAnimating];
        [_delegate tableRefreshDidLoadingData:self];
        return;
    }
    
    // // ScrollView整个内容的高度
    CGFloat contentSizeWidth = scrollView.contentSize.width;
    
    // // 1、headerView:手机顶端相对ScrollView原点的高度 2、footerView:手机底端相对ScrollView原点的高度
    CGFloat contentOffset_x = 0.0f;
    
    // // 1、headerView:手机顶端出现的空白高度(UIEdgeInset.top) 2、footerView:手机底端出现的空白高度(UIEdgeInset.bottom)
    CGFloat edgeOffset = 0.0;
    if (bIsHeadView)
    {
        contentOffset_x = scrollView.contentOffset.x * (-1);
        edgeOffset = MAX(contentOffset_x, 0);
    }
    else 
    {
        contentOffset_x = scrollView.contentOffset.x+scrollView.bounds.size.width;
        edgeOffset = MAX(contentOffset_x, contentSizeWidth) -  MAX(scrollView.bounds.size.width, contentSizeWidth);
    }
    
    // // 是否正在更新
    BOOL bLoading = NO;
    if ([_delegate respondsToSelector:@selector(tableRefreshIsLoading:)])
    {
        bLoading = [_delegate tableRefreshIsLoading:self];
    }
    
    if (edgeOffset >= 60*SNS_SCALE && !bLoading)
    {
        
        if ([_delegate respondsToSelector:@selector(tableRefreshDidLoadingData:)])
        {
            // // 更新加载数据
            [_delegate tableRefreshDidLoadingData:self];
        }
        [self refreshStateSetting:RefreshStateIsLoading];
        //        scrollView.contentInset = UIEdgeInsetsMake(0, 0, UIEdgeInsetViewHeight, 0);
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        if (bIsHeadView)
        {
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, UIEdgeInsetViewWidth, 0.0f, 0.0f);
        }
        else {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, UIEdgeInsetViewWidth);
        }
		
		[UIView commitAnimations];
    }
}

-(void)tableRefreshDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
    [self refreshStateSetting:RefreshStateNeedPull];
}


@end
