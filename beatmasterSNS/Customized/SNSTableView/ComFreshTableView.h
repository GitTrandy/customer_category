//
//  ComFreshTableView.h
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-16.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import <UIKit/UIKit.h>
#define COM_UIEdgeInsetViewHeight 60      // // 更新状态栏得高度
#define COM_MinOffsetToLoading      60    // // 触发更新的最小偏移量

typedef enum
{
    COM_RefreshStateNeedPull = 0,        // // 拉动cell但未触发刷新状态
    COM_RefreshStateReadyForLoading,     // // 拉动的cell距离达到要求状态，松手就可以刷新
    COM_RefreshStateIsLoading,           // // 正在刷新状态
    COM_RefreshStateInit                 // // View初始化的显示状态
}COM_RefreshState;
@protocol COM_RefreshTableViewDelegate;


@interface ComFreshTableView : UIView
{
    UILabel     *_stateLabel;                       // // 状态显示Label
    UIActivityIndicatorView     *_activeView;       // // Loading等待动画控件
    
    COM_RefreshState                _refreshState;      // // 刷新状态
    
    id<COM_RefreshTableViewDelegate>  _delegate;
    
    BOOL        bIsHeadView;                        // // YES：顶端刷新 NO：底部刷新
    
}

@property(nonatomic,assign)id<COM_RefreshTableViewDelegate> delegate;

-(void)tableRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
-(void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
-(void)tableRefreshScrollViewDateSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (id)initWithFrame:(CGRect)frame isHeaderView:(BOOL) isHead;

@end


// protocol
@protocol COM_RefreshTableViewDelegate <NSObject>

-(void)tableRefreshDelegateDidLoadingData:(ComFreshTableView *)view;
-(BOOL)tableRefreshDelegateIsLoadingState:(ComFreshTableView *)view;

@end
