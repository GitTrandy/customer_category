//Sunny
//2012.7.30

#import "GridView.h"

@interface GridView (Private)

//manage reusing queue
- (void)queueView:(UIView *)view;
- (UIView *)dequeueView;

- (void)gridLayout;

@end


@implementation GridView

#pragma mark - property

//data source
@synthesize dataSource = _dataSource;
@synthesize offset = _offset;
@synthesize style = _style;

//layout
@synthesize isVertical = _isVertical, limitCount = _limitCount, items = _items;

#pragma mark - create

+ (GridView *)gridViewWithFrame:(CGRect)frame isVertical:(BOOL)isVertical limitItemCount:(NSInteger)limitCount
{
    GridView* gridView = [[[self alloc] initWithFrame:frame] autorelease];
    gridView.isVertical = isVertical;
    gridView.limitCount = limitCount;
    return gridView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //init scroll view
        CGRect scrollViewFrame = frame;
        scrollViewFrame.origin = CGPointZero;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //init items array
        _items = [[NSMutableArray alloc] init];
        
        //创建重用池
        _reusingViewPool = [[NSMutableSet alloc] init];
        
        //deafult option
        _isVertical = YES;
        _limitCount = 1;
        _offset = 0.0f;
        _style = ScrollLineStyleRed;
    
    }
    return self;
}

#pragma mark - public

- (void)reloadData
{
    //移除原有view，清空数组
    for (UIView* item in _items) 
    {
        //将之前的对象加入缓存池
        [self queueView:item];
        
        //移除之前view
        [item removeFromSuperview];
        
    }
    [_items removeAllObjects];
    
    //向dataSource发送消息取得item的个数
    NSInteger itemsCount = 0;
    
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInGridView:)]) 
    {
        itemsCount = [_dataSource numberOfItemsInGridView:self];
    }
    
    //向dataSource发送消息取得各个index的View
    UIView* itemView = nil;
    if (itemsCount > 0 && [_dataSource respondsToSelector:@selector(gridView:itemViewForIndex:reusingView:)]) 
    {
        for (int i = 0; i < itemsCount; i++) 
        {
            itemView = [_dataSource gridView:self itemViewForIndex:i reusingView:[self dequeueView]];
            
            [_items addObject:itemView];
            
        }

    }
    else if([_dataSource respondsToSelector:@selector(gridView:itemViewForIndex:)])
    {
        for (int i = 0; i < itemsCount; i++) 
        {
            itemView = [_dataSource gridView:self itemViewForIndex:i];
            [_items addObject:itemView];
        } 
    }
    
    //重新布局
    [self gridLayout];
}

// // 跳转到顶部
-(void)toGridViewTop
{
    if (_scrollView)
    {
        _scrollView.contentOffset = CGPointZero;
    }
}
// // 跳转到底部
-(void)toGridViewBottom
{
    if (_scrollView)
    {
        _scrollView.contentOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height);
    }
}


#pragma mark - property setters

#pragma mark - override

#pragma mark - private

//manage reusing view

- (void)queueView:(UIView *)view
{
    if (view) 
    {
        [_reusingViewPool addObject:view];
    }
}

- (UIView *)dequeueView
{
    UIView* reusingView = [[_reusingViewPool anyObject] retain];
    if (reusingView) 
    {
        [_reusingViewPool removeObject:reusingView];
    }
    return [reusingView autorelease];
}

//layout

- (void)gridLayout
{
    
    UIView* itemView = nil;
    CGRect itemFrame = CGRectZero;
    
    //根据_isVertical和_limitCount布局
    for (int i = 0; i < _items.count; i++) 
    {
        itemView = _items[i];
        
        itemFrame = itemView.frame;
        
        if (_isVertical) 
        {
            itemFrame.origin.x = itemFrame.size.width * (i % _limitCount);
            itemFrame.origin.y = itemFrame.size.height * (i / _limitCount);
        }
        else 
        {
            itemFrame.origin.x = itemFrame.size.width * (i / _limitCount);
            itemFrame.origin.y = itemFrame.size.height * (i % _limitCount);
        }
        
        itemView.frame = itemFrame;
        [_scrollView addSubview:itemView];
        
    }
    
    //计算scrollView的contentSize
    CGSize contentSize = CGSizeZero;
    contentSize.width = itemFrame.size.width * (_isVertical ? _limitCount : (NSInteger)((_items.count + _limitCount - 1) / _limitCount));
    contentSize.height = itemFrame.size.height * (_isVertical ? (NSInteger)((_items.count + _limitCount - 1) / _limitCount) : _limitCount);
    _scrollView.contentSize = contentSize;
    SNSLog(@"peng %f %f",contentSize.width,contentSize.height);
    
    if (_lineView != nil)
    {
        [_lineView removeFromSuperview];
        [_lineView release];
        _lineView = nil;
    }
    
    _lineView = [[TableViewScrollLineView alloc] initWithSuperScrollView:_scrollView lineStyle:_style margin:_offset*SNS_SCALE_MIDDLE];
    [_scrollView addSubview:_lineView];
    [_lineView doSetScrollLineViewFrame];
    //[_lineView doSetHideAnimation];
    [_lineView setAlpha:0.f];
    
}

-(void) hidLine:(BOOL)_bool
{
    if (_lineView != nil)
    {
        _lineView.hidden = _bool;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    //class variables
    [_scrollView release];
    [_items release];
    [_reusingViewPool release];
    [_lineView release];
    
    //properties
    _dataSource = nil;
    
    [super dealloc];
    SNSLogFunction;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_lineView && (scrollView.dragging || scrollView.decelerating))
    {
        [_lineView doSetScrollLineViewFrame];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (_lineView != nil)
        {
            [_lineView doSetHideAnimation];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_lineView != nil)
    {
        [_lineView doSetHideAnimation];
    }
}


@end
