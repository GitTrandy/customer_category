//Sunny
//8.8

#import "ScrollTabBar.h"
#import "ImageFrame.h"
#import "ActionBase.h"
#import "SoundComDef.h"

@interface ScrollTabBar ()

- (void)layout;

@end


@implementation ScrollTabBar

#pragma mark - property

@synthesize backgroundView = _backgroundView;
@synthesize isVertical = _isVertical;
@synthesize contentInsets = _contentInsets;
@synthesize itemInsets = _itemInsets;
@synthesize returnItem = _returnItem;
@synthesize items = _items;
@synthesize returnItemBlock = _returnItemBlock;
@synthesize itemBlock = _itemBlock;
@synthesize willChangeBlock = _willChangeBlock;
@synthesize selectedItem = _selectedItem;
@synthesize selectedItemIndex = _selectedItemIndex;
@synthesize leftBtn = _leftBtn;
@synthesize rightBtn = _rightBtn;
@synthesize lightAnimWhenSelected = _lightAnimWhenSelected;
@synthesize isShowBtnAni = _isShowBtnAni;
@synthesize indicatorImageView = _indicatorImageView;
@synthesize isAverage = _isAverage;


#pragma mark - delegate

-(void) updateLeftBtnState{
    
    CGPoint offsetPt = _scrollView.contentOffset;
    if (offsetPt.x<=0)
    {
        if (_leftBtn)
            [_leftBtn setHighlighted:NO];
        
        if (_rightBtn)
            [_rightBtn setHighlighted:YES];
    }
    else if (offsetPt.x>0)
    {
        if (_leftBtn)
            [_leftBtn setHighlighted:YES];
        
        if ((offsetPt.x + _scrollView.frame.size.width) < (_scrollView.contentSize.width-20.f))
        {
            if (_rightBtn)
                [_rightBtn setHighlighted:YES];
        }
        else
        {
            if (_rightBtn)
                [_rightBtn setHighlighted:NO];
        }
    }
        
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self updateLeftBtnState];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self updateLeftBtnState];
}


#pragma mark - create

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //init default value
        _isVertical = YES;
        _contentInsets = UIEdgeInsetsZero;
        _itemInsets = UIEdgeInsetsZero;
        _isShowBtnAni = NO;
                
        //init content view
        _contentView = [[UIView alloc] init];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
        _indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_contentView addSubview:_indicatorImageView];
        _indicatorImageView.hidden = YES;
        _indicatorImageView.clipsToBounds = NO;
        
        [self setSelectedImageFrame:@"019-tabbar-selected@2x.png"];

        CGRect f = _indicatorImageView.frame;
        f.origin.x -= OFFSET_INDICATOR;
        f.origin.y -= OFFSET_INDICATOR_Y;
        _indicatorImageView.frame = f;
        
        
        //init scroll view
        _setedScrollFrame = CGRectNull;
        _scrollFrameIsSet = NO;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsVerticalScrollIndicator = YES;
        [_contentView addSubview:_scrollView];
        _scrollView.delegate = self;
        
//        UIImage *selectedImage = [UIImage imageNamed_New:@"019-tabbar-selected@2x.png"];
//        _indicatorImageView = [[UIImageView alloc] initWithImage:selectedImage];
//        [_contentView addSubview:_indicatorImageView];
        
    }
    return self;
}

+ (id)tabBar
{
    return [[[self alloc] init] autorelease];
}

+ (id)tabBarWithFrame:(CGRect)frame
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

+ (id)tabBarWithItems:(NSMutableArray *)items block:(void (^)(ScrollTabBarItem *, int))block
{
    ScrollTabBar* tabBar = [self tabBar];
    [tabBar setItems:items block:block];
    return tabBar;
}

+ (id)tabBarWithReturnItem:(ScrollTabBarItem *)returnItem returnBlock:(void (^)(ScrollTabBarItem *))returnBlock items:(NSMutableArray *)items itemBlock:(void (^)(ScrollTabBarItem *, int))itemBlock
{
    ScrollTabBar* tabBar = [self tabBar];
    [tabBar setReturnItem:returnItem block:returnBlock];
    [tabBar setItems:items block:itemBlock];
    return self;
}

+ (id)tabBarWithFrameAndItems:(CGRect)frame leftBtnImage:(NSMutableArray *)leftBtnImageArr rightBtnImage:(NSMutableArray *)rightBtnImageArr{
    
    ScrollTabBar *tabBar = [ScrollTabBar tabBarWithFrame:frame];
    if (nil != leftBtnImageArr) {
        [tabBar setLeftBtn_ByImages:leftBtnImageArr];
    }
    
    return tabBar;
}

#pragma mark - public

- (void)setLeftBtn_ByImages:(NSMutableArray *)imageArr{
    if (0 == [imageArr count]) {
        return;
    }
    if (nil != _leftBtn) {
        [_leftBtn release];
    }
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage_ = imageArr[0];
    [_leftBtn setBackgroundImage:normalImage_ forState:UIControlStateNormal];
    if (nil != imageArr[1]) {
        [_leftBtn setBackgroundImage:imageArr[1] forState:UIControlStateHighlighted];
    }
    
    CGRect scrollFrame = _contentView.bounds;
    int offsetX = (scrollFrame.size.width - _setedScrollFrame.size.width)/2;
    int x = (offsetX - normalImage_.size.width*SNS_SCALE)/2;
    int y = (scrollFrame.size.height - normalImage_.size.height*SNS_SCALE)/2;
    _leftBtn.frame = SNSRect(x, y, normalImage_.size.width*SNS_SCALE, normalImage_.size.height*SNS_SCALE);
    [_contentView addSubview:_leftBtn];
    
}

- (void) setScrollViewShowsVerticalScrollIndicator:(BOOL) isShow
{
    _scrollView.showsVerticalScrollIndicator = isShow;
}

- (void)leftBtnClick{
    
    CGPoint tmpPoint = _scrollView.contentOffset;
    ScrollTabBarItem *oneItem_ = _items[0];
    int offsetX = oneItem_.frame.size.width;
    CGPoint onePoint_ = tmpPoint;
    if (tmpPoint.x - offsetX >= 0) {
        onePoint_ = CGPointMake(tmpPoint.x-offsetX, tmpPoint.y);
    }
    [_scrollView setContentOffset:onePoint_ animated:YES];
}

- (void)setRightBtn_ByImages:(NSMutableArray *)imageArr{
    if (0 == [imageArr count]) {
        return;
    }
    if (nil != _rightBtn) {
        [_rightBtn release];
    }
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage_ = imageArr[0];
    [_rightBtn setBackgroundImage:normalImage_ forState:UIControlStateNormal];
    if (nil != imageArr[1]) {
        [_rightBtn setBackgroundImage:imageArr[1] forState:UIControlStateHighlighted];
    }
    
    CGRect scrollFrame = _contentView.bounds;
    int offsetX = (scrollFrame.size.width - _setedScrollFrame.size.width)/2;
    int x = scrollFrame.size.width - (offsetX - normalImage_.size.width*SNS_SCALE)/2 - normalImage_.size.width*SNS_SCALE;
    int y = (scrollFrame.size.height - normalImage_.size.height*SNS_SCALE)/2;
    _rightBtn.frame = SNSRect(x, y, normalImage_.size.width*SNS_SCALE, normalImage_.size.height*SNS_SCALE);
    [_contentView addSubview:_rightBtn];
}

- (void)rightBtnClick{
    CGPoint tmpPoint = _scrollView.contentOffset;
    ScrollTabBarItem *oneItem_ = _items[0];
    int offsetX = oneItem_.frame.size.width;
    int scrollSizeWidth = _scrollView.frame.size.width;
    CGPoint onePoint_ = tmpPoint;
    if (tmpPoint.x + offsetX + scrollSizeWidth <= _scrollView.contentSize.width) {
        onePoint_ = CGPointMake(tmpPoint.x+offsetX, tmpPoint.y);
    }
    [_scrollView setContentOffset:onePoint_ animated:YES];
}

- (void)setReturnItem:(ScrollTabBarItem *)returnItem block:(void (^)(ScrollTabBarItem *))block
{
    [self setReturnItemBlock:block];
    [self setReturnItem:returnItem];
    [self setOrientationToItem];
}

- (void)setItems:(NSMutableArray *)items block:(void (^)(ScrollTabBarItem *, int))block
{
    [self setItemBlock:block];
    [self setItems:items];
    [self setOrientationToItem];
}

- (void)setSelectedImageFrame:(NSString *)indicatorImageFilePath
{
    UIImage *selectedImage = [UIImage imageNamed_New:indicatorImageFilePath];
    _indicatorImageView.image = selectedImage;

//    ScrollTabBarItem *selectedOne = _items[_selectedItemIndex];
//    ScrollTabBarItem *firstOne = _items[0];
//    CGRect r = selectedOne.frame;
//    CGRect b = _indicatorImageView.bounds;
//    r.origin.y += r.size.height/2 + firstOne.frame.size.height;
//    r.size = b.size;
//    _indicatorImageView.frame = r;

    _indicatorImageView.bounds = SNSRect(0, 0, selectedImage.size.width * SNS_SCALE + OFFSET_INDICATOR, selectedImage.size.height * SNS_SCALE);
}

- (void)disableTarSelectedIndicator
{
    _indicatorImageView.hidden = YES;
}

- (void)setScrollFrame:(CGRect)frameRect{
    _scrollFrameIsSet = YES;
    _setedScrollFrame = frameRect;
    
}

- (void)setOrientationToItem
{
    for (ScrollTabBarItem* item in _items)
    {
        item.isVertical = _isVertical;
    }
    _returnItem.isVertical = YES;
}

#pragma mark - property setters

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView)
    {
        if (!_backgroundView) 
        {
            [self addSubview:backgroundView];
        }
        
        [_backgroundView release];
        _backgroundView = [backgroundView retain];
        [self sendSubviewToBack:_backgroundView];
    }
}

//layout
- (void)setIsVertical:(BOOL)isVertical
{
    _isVertical = isVertical;
    
    if (!_isVertical)
    {
        _indicatorImageView.hidden = YES;
    }
    
    [self setOrientationToItem];
    [self layout];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    [self layout];
}

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    _itemInsets = itemInsets;
    [self layout];
}

//items
- (void)setReturnItem:(ScrollTabBarItem *)returnItem
{
    if (_returnItem != returnItem) 
    {
        [_returnItem release];
        _returnItem = [returnItem retain];
        
        __block typeof(self) weakSelf = self;
        
        [returnItem setBlock:^(ScrollTabBarItem *item) {
            // 返回的音效
            PlayEffect(SFX_RETURN);
            
            if (weakSelf->_returnItemBlock) 
            {
                if (NO == weakSelf.userInteractionEnabled) {
                    return;
                }
                // 添加延时标记，防止频繁点击按钮
                weakSelf.userInteractionEnabled = NO;
                [weakSelf performSelector:@selector(returnblockActionDelay) withObject:nil afterDelay:0.3f];
                
                weakSelf->_returnItemBlock(item);
            }
        }];
        
        
        [_contentView addSubview:_returnItem];
        [self layout];
    }
}

-(void)returnblockActionDelay
{
    self.userInteractionEnabled = YES;
}

- (void)setItems:(NSMutableArray *)items
{
    if (_items != items) 
    {
        if (_isVertical)
        {
            _indicatorImageView.hidden = NO;
        }
        
        //remove fore items
        if (nil != _items) {
            for (ScrollTabBarItem* item in _items)
            {
                [item removeFromSuperview];
            }
            
            [_items removeAllObjects];
            [_items release];
            _items = nil;
        }
        
        _items = [[NSMutableArray arrayWithArray:items] retain];
        
        __block typeof(self) weakSelf = self;
        
        for (ScrollTabBarItem* item in items) 
        {
            
            [item setBlock:^(ScrollTabBarItem* selectedItem) {
                
                if (weakSelf->_selectedItem != selectedItem) 
                {
//                    //change last item state
//                    weakSelf->_selectedItem.selected = NO;
//                    
//                    //set new selected item selected
//                    selectedItem.selected = YES;
//                    
//                    //update old _selectedItem
//                    weakSelf->_selectedItem = selectedItem;
//                    
//                    //exe block, send msg outter
//                    if (weakSelf->_itemBlock) 
//                    {
//                        weakSelf->_itemBlock(selectedItem, weakSelf.selectedItemIndex);
//                    }
                    
                    PlayEffect(SFX_BUTTON);
                    [weakSelf selectAtIndex:[items indexOfObject:selectedItem]];
                }
                
            }];
            
            [_scrollView addSubview:item];
        }
        
        // // by cheng song 不默认运行第一个页面
//        if (_itemBlock) 
//        {
//            [self selectAtIndex:0]; //default 0
//        }
        // // by cheng song
        
        [self layout];
    }
}

- (void)setItemBlock:(void (^)(ScrollTabBarItem *, int))itemBlock
{
    Block_release(_itemBlock);
    _itemBlock = Block_copy(itemBlock);
    //[self selectAtIndex:0]; //default 0
    
}

-(void)setWillChangeBlock:(BOOL (^)(int, int))willChangeBlock{
    Block_release(_willChangeBlock);
    _willChangeBlock = Block_copy(willChangeBlock);
}

- (void)selectAtIndex:(NSUInteger)index
{
    if (_willChangeBlock)
    {
        //外面不让切换状态，要做别的处理
        if (NO==_willChangeBlock(_selectedItemIndex, index))
            return;
    }
    
    if (_itemBlock) 
    {
        // 增加index的有效性判断
        if (index >= _items.count)
        {
            index = 0;
        }
        //NSAssert(index <= _items.count,@"ScrollTabBar:selectAtIndex, index beyond array's count");
        
        NSInteger lastSelected = _selectedItemIndex;
        
        //select the index of item
        ScrollTabBarItem* item = _items[index];
        
        //change selected state
        _selectedItem.selected = NO;
        item.selected = YES;
        _selectedItem = item;
        _selectedItemIndex = index;
                
        //exe the block
        _itemBlock(item, index);
        
        if (_indicatorImageView &&
            (_selectedItemIndex == 0 ||
            _selectedItemIndex != lastSelected))
        {
            if (_isVertical)
            {
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationCurveEaseInOut
                                 animations:^{
                                     ScrollTabBarItem *selectedOne = _items[_selectedItemIndex];
                                     CGRect r = selectedOne.frame;
                                     CGRect b = _indicatorImageView.bounds;
                                     r.origin.x = -OFFSET_INDICATOR;
                                     r.origin.y += /*r.size.height/2 +*/ _returnItem.frame.size.height;
                                     r.origin.y -= OFFSET_INDICATOR_Y;
                                     r.size = b.size;
                                     _indicatorImageView.frame = r;
                                     
                                     // 选中状态下光条旋转的动画
                                     //[_lightAnimWhenSelected stopAction];
                                     CGPoint origin = selectedOne.frame.origin;
                                     CGSize itemSize = selectedOne.frame.size;
                                     CGPoint center = CGPointMake(origin.x + itemSize.width / 2.f, origin.y + itemSize.height / 2.f);
                                     _lightAnimBg.frame = SNSRect(0, 0, itemSize.width, itemSize.height);
                                     _lightAnimBg.center = center;
                                     _lightAnimBg.hidden = YES;
                                 }
                                 completion:^(BOOL finished) {
                                     // 选中状态下光条旋转的动画
                                     //[_lightAnimWhenSelected startAction];
                                     _lightAnimBg.hidden = NO;
                                 }];
            } else {
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationCurveEaseInOut
                                 animations:^{
                                     
                                     // TODO: Need debug
//                                     ScrollTabBarItem *selectedOne = _items[_selectedItemIndex];
//                                     CGRect r = selectedOne.frame;
//                                     CGRect b = _indicatorImageView.bounds;
//                                     r.origin.y += r.size.width/2 + _returnItem.frame.size.width;
//                                     r.size = b.size;
//                                     _indicatorImageView.frame = r;
                                 }
                                 completion:^(BOOL finished) {
                                 }];
            }
        }

    }
}

- (NSUInteger)selectedItemIndex
{
    return [_items indexOfObject:_selectedItem];
}


#pragma mark - override

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layout];
}

-(void)setIsShowBtnAni:(BOOL)isShowBtnAni
{
    _isShowBtnAni = isShowBtnAni;
    
    //只有要加动画的才这样，这样做的目的是为了防止小闪光动画被切
    if (_isShowBtnAni && _isVertical)
        _scrollView.clipsToBounds = NO;
    
    [self layout];
}

#pragma mark - private

- (void)layout
{
    //content view
    _contentView.frame = UIEdgeInsetsInsetRect(self.bounds, _contentInsets);
    
    //default scroll frame
    CGRect scrollFrame = _contentView.bounds;
    
    if (_returnItem) 
    {
        
        if (_isVertical) 
        {
            //return item frame
            [_returnItem setFrameKeepRatioWithWidth:_contentView.frame.size.width];
            
            //scroll view frame
            scrollFrame.origin.y += _returnItem.bounds.size.height;
            scrollFrame.size.height -= _returnItem.bounds.size.height;
            
        }
        else 
        {
            //return item frame
            [_returnItem setFrameKeepRatioWithWidth:_contentView.frame.size.height];
            
            //scroll view frame
            scrollFrame.origin.x += _returnItem.bounds.size.width;
            scrollFrame.size.width -= _returnItem.bounds.size.width;
        }
        
        //item insets
        _returnItem.frame = UIEdgeInsetsInsetRect(_returnItem.frame, _itemInsets);
    }
    
    //set scroll view frame
    if (NO == _scrollFrameIsSet) {
        _scrollView.frame = scrollFrame;
    }
    else{
        if (_isVertical) {
            //暂时没有
        }
        else{
            int offsetX = (scrollFrame.size.width - _setedScrollFrame.size.width)/2;
            if (offsetX < 0) {
                offsetX = 0;
            }
            
            _setedScrollFrame.origin.x = scrollFrame.origin.x + offsetX;
//            _setedScrollFrame.origin.y = scrollFrame.origin.y;
        }
        
        _scrollView.frame = _setedScrollFrame;
    }
    
    
    //layout the items
    CGSize scrollViewContentSize = CGSizeZero;
    
    CGFloat indicatorOffsetX = 0.f;
//    CGFloat step = 16.f * SNS_SCALE;
    
    float itemOffsetForIpad = IS_IPAD ? 10.0f : 0.0f;
    if (_isAverage)
    {
        _returnItem.center = CGPointMake(scrollFrame.size.width/2.0f, 49.0f/2.0f*SCREEN_SCALE_H);
    }
    
    for (ScrollTabBarItem* item in _items)
    {
        int index = [_items indexOfObject:item];
        
        //set frame
        if (_isVertical) 
        {
            if (_isAverage)
            {
                [item setFrameKeepRatioWithWidth:_scrollView.frame.size.width];
                float averageHeight = (SCREEN_HEIGHT-49.0f*SCREEN_SCALE_H);
                float averageValue = averageHeight/8.0f;
                item.center = CGPointMake(scrollFrame.size.width/2.0f, averageValue*(1.0f+2.0f*index)+itemOffsetForIpad);
                scrollViewContentSize.width = item.frame.size.width;
                scrollViewContentSize.height += item.frame.size.height;
            }
            else
            {
                //set size
                //            [item setFrameKeepRatioWithWidth:_scrollView.frame.size.width - 9];
                [item setFrameKeepRatioWithWidth:_scrollView.frame.size.width];
                
                CGFloat step = (SNS_HEIGHT_SCROLLTABBAR - 8 * SNS_SCALE - _returnItem.frame.size.height - item.frame.size.height * 4) / 3.f ;
                
                //set frame
                CGFloat xOffset = (self.frame.size.width - indicatorOffsetX - item.frame.size.width) / 2.f;
                item.frame = CGRectMake(indicatorOffsetX + xOffset, index * item.frame.size.height + index*step, item.frame.size.width, item.frame.size.height);
                
                //update content size
                scrollViewContentSize.width = item.frame.size.width;
                scrollViewContentSize.height += item.frame.size.height;
            }
        }
        else 
        {
            //set size
            [item setFrameKeepRatioWithWidth:_scrollView.frame.size.height];
            
            //set frame
            item.frame = CGRectMake(index * item.frame.size.width, 0+5, item.frame.size.width, item.frame.size.height);
            
            //update content size
            scrollViewContentSize.width += item.frame.size.width;
            scrollViewContentSize.height = item.frame.size.height;
        }
        
        //item insets
        item.frame = UIEdgeInsetsInsetRect(item.frame, _itemInsets);
        
    }
    
    ScrollTabBarItem *selectedOne = _items[_selectedItemIndex];
    
    if (selectedOne && _returnItem)
    {
        if (_isVertical)
        {
            
            // Vertical layout
            CGRect r = selectedOne.frame;
            CGRect b = _indicatorImageView.bounds;
            r.origin.x = -OFFSET_INDICATOR;
            r.origin.y += /*r.size.height/2 +*/ _returnItem.frame.size.height;
            r.origin.y -= OFFSET_INDICATOR_Y;
            r.size = b.size;
            _indicatorImageView.frame = r;
        } else {
            
            // Horizontal layout
            // TODO:
        }
    }
    
    //set content size
    _scrollView.contentSize = scrollViewContentSize;
    
    // 增加选中时光条滚动的动画，需要是竖直的TabBar并且不是SubTabBar
    if (_isShowBtnAni && _isVertical && !CGRectEqualToRect(self.frame, SNSSubTabBarFrame))
    {
        [self addLightAnimation];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    if (nil != _items) {
        for (ScrollTabBarItem* item in _items)
        {
            [item removeFromSuperview];
        }
        
        [_items removeAllObjects];
        [_items release];
        _items = nil;
    }
    //class variables
    [_scrollView release];
    [_contentView release];
    [_indicatorImageView release];
    
    //property
    [_backgroundView release];
    [_returnItem release];
//    [_items release];
    
    Block_release(_returnItemBlock);
    Block_release(_itemBlock);
    Block_release(_willChangeBlock);
    _selectedItem = nil;
    
    // 移除选中时的动画
    [self removeLightAnimation];
    
    SNSLog(@"tab bar dealloc");
    [super dealloc];
}


- (void)addLightAnimation
{
    if (nil == _lightAnimBg)
    {
        _lightAnimBg = [[UIView alloc] init];
        _lightAnimBg.hidden = YES;
        //_lightAnimBg.frame = SNSRect(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        //[_lightAnimBg setUserInteractionEnabled:YES];
        //_lightAnimBg.backgroundColor = [UIColor redColor];
    }
    [_scrollView addSubview:_lightAnimBg];
    
//    if (nil == _lightAnimBaseView)
//    {
//        UIImage* image = [UIImage imageNamed_New:@"tabbar_item_select_Ani1_00.png"];
//        _lightAnimBaseView = [[[ImageFrame alloc] initWithImage:image] autorelease];
//        _lightAnimBaseView.frame = CGRectMake(0.f, 0.f, image.size.width * SNS_SCALE, image.size.height * SNS_SCALE);
//        _lightAnimBaseView.hidden = YES;
//        
//    }
//    [_lightAnimBg addSubview:_lightAnimBaseView];
//    
//    if (nil == _lightAnimBaseView2)
//    {
//        UIImage* image = [UIImage imageNamed_New:@"tabbar_item_select_Ani2_00.png"];
//        _lightAnimBaseView2 = [[[ImageFrame alloc] initWithImage:image] autorelease];
//        _lightAnimBaseView2.frame = CGRectMake(0.f, 0.f, image.size.width * SNS_SCALE, image.size.height * SNS_SCALE);
//        _lightAnimBaseView2.hidden = YES;
//    }
//    [_lightAnimBg addSubview:_lightAnimBaseView2];
    
    if (nil == _lightAnimWhenSelected)
    {
        //大闪光
        UIImage* image = [UIImage imageNamed_New:@"tabbar_item_select_Ani1_00.png"];
        ImageFrame* lightAnimBaseView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        lightAnimBaseView.frame = CGRectMake(14.f*SNS_SCALE, 9.f*SNS_SCALE, image.size.width * SNS_SCALE, image.size.height * SNS_SCALE);
        //lightAnimBaseView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5];
        [_lightAnimBg addSubview:lightAnimBaseView];
        ImagesAction* imageAction = [ImagesAction action:lightAnimBaseView duration:0.7f formatKey:@"tabbar_item_select_Ani1_%02d.png" beginIdx:0 imagesCount:8 repeatCount:1 imageCache:true];
        DelayAction* delayAction = [DelayAction action:1.5f];
        ActionItem* item1 = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, delayAction, nil];
        
        //小光
        image = [UIImage imageNamed_New:@"tabbar_item_select_Ani2_00.png"];
        ImageFrame* lightAnimBaseView2 = [[[ImageFrame alloc] initWithImage:image] autorelease];
        lightAnimBaseView2.frame = CGRectMake(17.f*SNS_SCALE, -15.f*SNS_SCALE, image.size.width * SNS_SCALE, image.size.height * SNS_SCALE);
        [_lightAnimBg addSubview:lightAnimBaseView2];
        ImagesAction* imageAction1 = [ImagesAction action:lightAnimBaseView2 duration:0.7f formatKey:@"tabbar_item_select_Ani2_%02d.png" beginIdx:0 imagesCount:11 repeatCount:1 imageCache:true];
        ActionItem* item2 = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction1, nil];
        
        self.lightAnimWhenSelected = [ActionItemParallel actionItemParallels:item1, item2,nil];
        [_lightAnimWhenSelected startActionItems];
    }
}

- (void)removeLightAnimation
{
    if (nil != _lightAnimWhenSelected)
    {
        [_lightAnimWhenSelected clearActionItems];
        self.lightAnimWhenSelected = nil;
    }
//    if (nil != _lightAnimBaseView)
//    {
//        [_lightAnimBaseView removeFromSuperview];
//        _lightAnimBaseView = nil;
//    }
//    if (nil != _lightAnimBaseView2)
//    {
//        [_lightAnimBaseView2 removeFromSuperview];
//        _lightAnimBaseView2 = nil;
//    }
    
    if (nil != _lightAnimBg)
    {
        [_lightAnimBg removeFromSuperview];
        [_lightAnimBg release];
        _lightAnimBg = nil;
    }
}


@end


//adapter

@implementation ScrollTabBar (ScrollTabBarDeprecated)
@dynamic hasReturnKey;
static NSMutableArray* items = nil;
- (id)initWithFrame:(CGRect)frame bgImage:(UIImage *)image block:(void (^)(int))block
{
    self = [self init];
    self.frame = frame;
    self.itemBlock = ^(ScrollTabBarItem* item, int index){
        block(index);
    };
    return self;
}

- (void)addItem:(ScrollTabBarItem *)item
{
    if (!items) 
    {
        items = [NSMutableArray array];
    }
    
    [items addObject:item];
    self.items = items;
    
}

- (void)addItems:(NSArray *)items
{
    
}
@end


