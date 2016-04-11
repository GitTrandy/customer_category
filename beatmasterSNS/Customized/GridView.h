//Sunny
//2012.7.30

#import <UIKit/UIKit.h>
#import "TableViewScrollLineView.h"


@protocol GridViewDataSource;
@interface GridView : UIView <UIScrollViewDelegate>
{
    @private
    UIScrollView*   _scrollView;
    NSMutableArray* _items;
    NSMutableSet*   _reusingViewPool;
    TableViewScrollLineView *_lineView;
}

//data source
@property (nonatomic, assign) id<GridViewDataSource> dataSource;

//layout
@property (nonatomic) BOOL isVertical;          //default YES
@property (nonatomic) NSInteger limitCount;     //default 1
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, assign) float offset;
@property (nonatomic, assign) ScrollLineStyle style;

+ (GridView *)gridViewWithFrame:(CGRect)frame isVertical:(BOOL)isVertical limitItemCount:(NSInteger)limitCount;
- (void)reloadData;

// // addBy CS : 跳转到顶部
-(void)toGridViewTop;
-(void)hidLine:(BOOL) _bool;
// // addBy CS : 充值免费钻石需要直接跳转
-(void)toGridViewBottom;

@end

@protocol GridViewDataSource <NSObject>
@optional
- (NSInteger)numberOfItemsInGridView:(GridView *)gridView;
- (UIView *)gridView:(GridView *)gridView itemViewForIndex:(NSInteger)index  __deprecated;
- (UIView *)gridView:(GridView *)gridView itemViewForIndex:(NSInteger)index reusingView:(UIView *)reusingView;
@end