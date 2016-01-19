//Sunny
//2012.7.20

#import <UIKit/UIKit.h>

#import "ScrollRefreshView.h"

typedef enum{
    ScrollDirectionVertical,
    ScrollDirectionHorizon
}SrollDirection;

@interface ScrollPageView : UIView <UIScrollViewDelegate>
{
    UIScrollView        *_scrollView;
    NSMutableArray      *_pageViews;
    
    ScrollRefreshView   *_refreshView;
}

@property (retain, nonatomic) UIScrollView* scrollView;
@property (assign, nonatomic) CGSize pageSize;
@property (assign, nonatomic) SrollDirection direction;
@property (retain, nonatomic) ScrollRefreshView* refreshView;
@property (retain, nonatomic) NSMutableArray* pageViews;
- (void)addPageView:(UIView *)view;
- (void)addPageViews:(NSArray *)views;
@end
