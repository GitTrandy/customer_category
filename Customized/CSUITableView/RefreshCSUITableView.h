//
//  RefreshCSUITableView.h
//  beatmasterSNS
//
//  Created by chengsong on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

#define UIEdgeInsetViewWidth (60*SNS_SCALE)      // // 更新状态栏得高度
//#define MinOffsetToLoading      (60*SNS_SCALE)    // // 触发更新的最小偏移量

#define RT_StateLabelWidth      (30*SNS_SCALE)    // // 刷新状态Label宽度

// zzy del on 2012-11-01 在RefreshTableView.h中已经定义
/*
typedef enum 
{
    RefreshStateNeedPull = 0,        // // 拉动cell但未触发刷新状态
    RefreshStateReadyForLoading,     // // 拉动的cell距离达到要求状态，松手就可以刷新
    RefreshStateIsLoading,           // // 正在刷新状态
    RefreshStateInit                 // // View初始化的显示状态
}RefreshState;
 */

@protocol RefreshCSUITableViewDelegate;
@interface RefreshCSUITableView : UIView
{
    UILabel     *_stateLabel;                       // // 状态显示Label
    UIActivityIndicatorView     *_activeView;       // // Loading等待动画控件
    
    RefreshState                _refreshState;      // // 刷新状态
    
    id<RefreshCSUITableViewDelegate>  _delegate;
    
    BOOL        bIsHeadView;                        // // YES：顶端刷新 NO：底部刷新
    
}
@property(nonatomic,assign)id<RefreshCSUITableViewDelegate>  delegate;
// // 滚动事件
-(void)tableRefreshDidScroll:(UIScrollView *)scrollView;
// // 滚动结束事件
-(void)tableRefreshDidEndDragging:(UIScrollView *)scrollView;
// // 数据更新完毕事件
-(void)tableRefreshDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol RefreshCSUITableViewDelegate <NSObject>

// // 数据是否正在更新
-(BOOL)tableRefreshIsLoading:(RefreshCSUITableView *)refreshCSUITableView;
// // 数据正在更新
-(void)tableRefreshDidLoadingData:(RefreshCSUITableView *)refreshCSUITableView;

@end
