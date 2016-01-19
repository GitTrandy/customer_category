//Sunny
//2012.7.20

#import "ScrollPageView.h"

@interface ScrollPageView (Private)
- (void)addAndLayoutView:(UIView *)view;
@end



@implementation ScrollPageView
@synthesize pageSize = _pageSize;
@synthesize direction = _direction;
@synthesize refreshView = _refreshView;
@synthesize scrollView = _scrollView;
@synthesize pageViews = _pageViews;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //设置自身
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;           //截断
        
        //初始化scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;    //启动翻页效果
        _scrollView.showsVerticalScrollIndicator = NO;      //不显示垂直滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;    //不显示水平滚动条
        //_scrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        [self addSubview:_scrollView];
        
        
        _pageSize = frame.size;
        _scrollView.contentSize = frame.size;
        
        //初始化数组
        _pageViews = [[NSMutableArray alloc] init];
        
        //拖动更新的view
        _refreshView = [[ScrollRefreshView alloc] initWithFrame:SNSRect(-50, 0, 50, 320)];
        [_refreshView setArrowImage:[UIImage imageNamed_New:@"grayArrow.png"]];
        [_scrollView addSubview:_refreshView];
        [_refreshView release];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (nil != hitView) {
        return _scrollView;
    }
    return nil;
}

#pragma mark - 外部添加方法

- (void)addPageView:(UIView *)view
{
    if (view) 
    {
        [_pageViews addObject:view];
        [self addAndLayoutView:view];
    }
}
- (void)addPageViews:(NSArray *)views
{
    for (UIView* view in views) 
    {
        [self addPageView:view];
    }
}

- (void)addAndLayoutView:(UIView *)view
{
    //[_scrollView addSubview:view];
    _scrollView.frame = SNSRect(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.contentSize = SNSSize(_pageSize.width * _pageViews.count, _pageSize.height);
    
    
    CGRect newFrame = [[_pageViews lastObject] frame];
    newFrame.origin.x = _pageSize.width * [_pageViews indexOfObject:view];
    view.frame = newFrame;
    [_scrollView addSubview:view];
    

    
    
        
    
    
}

#pragma mark - UIScrollViewDelegate methods


//滑动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshView refreshViewDidScroll:scrollView];
}



//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView refreshViewDidEndDragging:scrollView];
}




@end
