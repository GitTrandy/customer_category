//Sunny
//8.8

#import <UIKit/UIKit.h>

#import "ScrollTabBarItem.h"

#define DEFAULT_RETURN_ITEM [ScrollTabBarItem itemWithImageName:@"Com_ReturnBtnRed_1.png" selected:@"Com_ReturnBtnRed_2.png"]

#define OFFSET_INDICATOR    (6.f * SNS_SCALE)
#define OFFSET_INDICATOR_Y  (2.f * SNS_SCALE)

@class ImageFrame;
@class ActionItem;
@interface ScrollTabBar : UIView <UIScrollViewDelegate>
{
    @private
    UIScrollView*   _scrollView;
    UIView*         _contentView;
    
    UIImageView*    _indicatorImageView;
    
    BOOL _scrollFrameIsSet;
    CGRect _setedScrollFrame;
    
    BOOL    _isShowBtnAni;
    
    BOOL    _isAverage;
    
    UIView*     _lightAnimBg;          //选中动画背景
    //ImageFrame* _lightAnimBaseView;  // 选中状态下转动动画
    //ImageFrame* _lightAnimBaseView2;
}

+ (id)tabBar;
+ (id)tabBarWithFrame:(CGRect)frame;
+ (id)tabBarWithItems:(NSMutableArray *)items block:(void (^)(ScrollTabBarItem* item, int index))block;
+ (id)tabBarWithReturnItem:(ScrollTabBarItem *)returnItem 
               returnBlock:(void (^)(ScrollTabBarItem* returnItem))returnBlock 
                     items:(NSMutableArray *)items
                 itemBlock:(void (^)(ScrollTabBarItem* item, int index))itemBlock;

+ (id)tabBarWithFrameAndItems:(CGRect)frame
                 leftBtnImage:(NSMutableArray *)leftBtnImageArr
                rightBtnImage:(NSMutableArray *)rightBtnImageArr;

- (void)updateLeftBtnState;

- (void) setScrollViewShowsVerticalScrollIndicator:(BOOL) isShow;

//background
@property (nonatomic, retain) UIView* backgroundView;     //default nil, lazy add

//layout
@property (nonatomic) BOOL isVertical;          //default is YES, set NO to horizon

@property (nonatomic) UIEdgeInsets contentInsets;   //inset of content, default UIEdgeInsetsZero, set BEFORE itemInsets
@property (nonatomic) UIEdgeInsets itemInsets;      //inset of items, default UIEdgeInsetsZero

//items
@property (nonatomic, retain)   ScrollTabBarItem* returnItem;     //return key reserved, default nil, set outside;
@property (nonatomic, retain)   NSMutableArray* items;         //default nil, NOT INCLUDE return item

- (void)selectAtIndex:(NSUInteger)index;    //auto select 0

@property (nonatomic, copy)     void (^returnItemBlock)(ScrollTabBarItem*);
@property (nonatomic, copy)     void (^itemBlock)(ScrollTabBarItem*, int);
@property (nonatomic, copy)     BOOL (^willChangeBlock)(int, int);

//execute block when return item touched
- (void)setReturnItem:(ScrollTabBarItem *)returnItem block:(void (^)(ScrollTabBarItem* returnItem))block;

//execute block when item touched (not include return, start at index of 0)
- (void)setItems:(NSMutableArray *)items block:(void (^)(ScrollTabBarItem* item, int index))block;

- (void)setSelectedImageFrame:(NSString *)indicatorImageFilePath;
- (void)disableTarSelectedIndicator;

//current selected item info, read only to refer
//return nil when items empty
@property (nonatomic, readonly) ScrollTabBarItem*   selectedItem;       //read only, default is the first item (without return item)
@property (nonatomic, readonly) NSUInteger          selectedItemIndex;  //read only, default is the first item (without return item)

@property (retain, nonatomic) ActionItemParallel*   lightAnimWhenSelected; // 选中状态下转动动画

- (void)setScrollFrame:(CGRect)frameRect;

@property (nonatomic, retain) UIButton *leftBtn;
- (void)setLeftBtn_ByImages:(NSMutableArray *)imageArr;
- (void)leftBtnClick;

@property (nonatomic, retain) UIButton *rightBtn;
- (void)setRightBtn_ByImages:(NSMutableArray *)imageArr;
- (void)rightBtnClick;

@property(nonatomic,assign) BOOL isShowBtnAni;
@property(nonatomic,retain)UIImageView  *indicatorImageView;

@property(nonatomic,assign) BOOL isAverage;

@end



//adapt to old (deprecate)
@interface ScrollTabBar(ScrollTabBarDeprecated)

@property (nonatomic) BOOL hasReturnKey;

- (id)initWithFrame:(CGRect)frame bgImage:(UIImage *)image block:(void(^)(int))block DEPRECATED_ATTRIBUTE;

- (void)addItem:(ScrollTabBarItem *)item DEPRECATED_ATTRIBUTE;
- (void)addItems:(NSArray *)items DEPRECATED_ATTRIBUTE;

@end
