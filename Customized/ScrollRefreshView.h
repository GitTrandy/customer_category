//
//  DragRefreshView.h
//  SunnyPageScrollView
//
//  Created by  on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol ScrollRefreshViewDelegate;
@interface ScrollRefreshView : UIView
{
    
    //UIImage                 *_arrowImage;
    UILabel                 *_textLabel;
    id <ScrollRefreshViewDelegate> _delegate;
    
}

@property (assign, nonatomic) id <ScrollRefreshViewDelegate> delegate;
//@property (retain, nonatomic) UIImage* arrowImage;
@property (retain, nonatomic) UILabel* textLabel;


//初始化方法
- (id)initWithFrame:(CGRect)frame arrowImage:(UIImage *)arrowImage;
- (void)setArrowImage:(UIImage *)image;

//将目标UIScrollView的delegate相应事件传进来：
- (void)refreshViewDidScroll:(UIScrollView *)scrollView;       //--正在滑动
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView;  //--手指滑动松开

//外部更新完数据之后调用，通知此类以结束更新等待状态
- (void)refreshViewDidFinishRefreshData:(UIScrollView *)scrollView;

@end



@protocol ScrollRefreshViewDelegate <NSObject>

- (void)scrollRefreshViewShouldBeginRefresh:(ScrollRefreshView *)refreshView;
- (void)scrollRefreshViewDidEndRefresh:(ScrollRefreshView *)refreshView;

@end


