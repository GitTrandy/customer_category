//
//  RefreshTableView.h
//  RefreshTableView
//
//  Created by chengsong on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIEdgeInsetViewHeight 60      // // 更新状态栏得高度
#define MinOffsetToLoading      60    // // 触发更新的最小偏移量

typedef enum 
{
    RefreshStateNeedPull = 0,        // // 拉动cell但未触发刷新状态
    RefreshStateReadyForLoading,     // // 拉动的cell距离达到要求状态，松手就可以刷新
    RefreshStateIsLoading,           // // 正在刷新状态
    RefreshStateInit                 // // View初始化的显示状态
}RefreshState;
@protocol RefreshTableViewDelegate;
@interface RefreshTableView : UIView
{
    UILabel     *_stateLabel;                       // // 状态显示Label
    UIActivityIndicatorView     *_activeView;       // // Loading等待动画控件
    
    RefreshState                _refreshState;      // // 刷新状态
    
    id<RefreshTableViewDelegate>  _delegate;
    
    BOOL        bIsHeadView;                        // // YES：顶端刷新 NO：底部刷新
    BOOL        _bIsFollowLastCell;                 // // 当在底步加刷新的时候，是否靠着最后一条cell显示
    
}

@property(nonatomic,assign)id<RefreshTableViewDelegate> delegate;
@property(nonatomic,assign)BOOL bIsFollowLastCell; // // 当在底步加刷新的时候，是否靠着最后一条cell显示

-(void)tableRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
-(void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
-(void)tableRefreshScrollViewDateSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


// protocol
@protocol RefreshTableViewDelegate <NSObject>

-(void)tableRefreshDelegateDidLoadingData:(RefreshTableView *)view;
-(BOOL)tableRefreshDelegateIsLoadingState:(RefreshTableView *)view;

@end
