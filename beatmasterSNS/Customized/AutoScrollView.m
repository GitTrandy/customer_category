 //Sunny
//2012.7.19

#import "AutoScrollView.h"
#import "AdInfo.h"
#import "Math.h"
#import "DataManager.h"

#import <dispatch/dispatch.h>       // Using GCD

#import "RNTimer.h"

@interface AutoScrollView (Private)
- (void)autoScroll;
@end

@implementation AutoScrollView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //bgImageView 背景图片View
        _bgImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_bgImageView];
        
        _carouselView = [[iCarousel alloc] initWithFrame:frame];
        _carouselView.dataSource = self;
        _carouselView.delegate = self;
        _carouselView.vertical = YES;
        [_carouselView scrollToItemAtIndex:0 animated:NO];
        [self addSubview:_carouselView];
        
        //page view
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = SNSPoint(_carouselView.center.x + _carouselView.frame.size.width / 2 +5, _carouselView.center.y);
        
        
        _pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:_pageControl];
        
        //_carouselView.con
        
        _needDownloadImg = [[NSMutableSet alloc] init];
        
        _itemObjects = [[NSMutableArray alloc] init];
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        
        __block AutoScrollView *weakSelf = self;
        _timer = [[RNTimer repeatingTimerWithTimeInterval:5.f block:^{
            
            [weakSelf autoScroll];
        }] retain];

    }
    return self;
}

- (void)removeFromSuperview
{
    if (_timer)
    {
        [_timer invalidate];
    }
    
    [super removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SNS_RELEASE_NIL(_bgImageView);
    SNS_RELEASE_NIL(_carouselView);
    SNS_RELEASE_NIL(_pageControl);
    SNS_RELEASE_NIL(_needDownloadImg);
    SNS_RELEASE_NIL(_itemObjects);
    
    SNS_RELEASE_NIL(_timer);
    
    [super dealloc];
}

- (void)autoScroll
{
    [_carouselView scrollToItemAtIndex:_carouselView.currentItemIndex + 1 duration:2.0f];
}
- (void)addAdItem:(AdInfo *)itemAd
{
    NSAssert(itemAd,@"AutoScrollView:addItemView: itemView cannot be nil");
    
    //加入数组
    [_itemObjects addObject:itemAd];
    _pageControl.numberOfPages = [_itemObjects count];
}


- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _bgImageView.image = backgroundImage;
}

-(void)beginDownloadAdImage
{
    //更新carousel中的数据
    [_carouselView reloadData];
    
    if ([_needDownloadImg count] == 0) {
        SNSLog(@"没有需要下载的广告图片！");
        return;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"Ad_downLoadPicSuccess" object:nil];
    [center removeObserver:self name:@"Ad_downLoadPicFail" object:nil];
    
    [center addObserver:self selector:@selector(Ad_downLoadPicSuccess:) name:@"Ad_downLoadPicSuccess" object:nil];
    [center addObserver:self selector:@selector(Ad_downLoadPicFail:) name:@"Ad_downLoadPicFail" object:nil];
    NSMutableArray* _downLoadArray = [[[NSMutableArray alloc] initWithArray:[_needDownloadImg allObjects]] autorelease];
    [[DataManager shareDataManager] startFileBatchDownloading:_downLoadArray ofFileType:FILEPATH_AD doneNotification:@"Ad_downLoadPicSuccess" failedNotification:@"Ad_downLoadPicFail"];
    [_needDownloadImg removeAllObjects];
}

-(void)Ad_downLoadPicSuccess:(NSNotification *)sender
{
    NSDictionary *imgInfoDict = [sender userInfo];
    if (imgInfoDict == nil || ![imgInfoDict isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSString *imgName = imgInfoDict[@"file"];
    
    
//    [_carouselView reloadData];
    
    //更新指定View
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        for (int i = 0; i< [_itemObjects count]; i++) {
            AdInfo* info = _itemObjects[i];
            if ([imgName isEqualToString:info.picName]) {
                SNSLog(@"ccccccinfo.picName====%@   index====%d",info.picName,i);
                [self carousel:_carouselView viewForItemAtIndex:i reusingView:[_carouselView itemViewAtIndex:i]];
                break;
            }
        }
    });

}

-(void)Ad_downLoadPicFail:(NSNotification *)sender
{
    NSDictionary *imgInfoDict = [sender userInfo];
    if (imgInfoDict == nil || ![imgInfoDict isKindOfClass:[NSDictionary class]])
    {
        return;
    }
//    NSString *imgName = [imgInfoDict objectForKey:@"file"];
}
#pragma mark - iCarousel data source delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_itemObjects count];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    AdInfo* adInfo =  _itemObjects[index];
//    [carousel itemViewAtIndex:index];
    UIImageView* imageView = (UIImageView*)view;
    if (imageView == nil) {
        imageView = [[[UIImageView alloc] init]autorelease];
        imageView.frame = SNSRect(0, 0, 118, 290);
    }
    DataManager *sharedDM = [DataManager shareDataManager];
    NSString *localPath = [NSString stringWithFormat:@"%@%@", sharedDM.localFileManager.bmSNS_Path, adInfo.picName];
    if ([Math isFileExist:localPath]) {
        SNSLog(@"%@",[adInfo.picName lastPathComponent]);
        imageView.image = [UIImage imageWithContentsOfFile_New:localPath];
    }else{
        imageView.image = [UIImage imageNamed_New:@"ad_default.png"];
        [_needDownloadImg addObject:adInfo.picName];
    }
    return imageView;
}

	
#pragma mark - iCarousel delegate

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    _pageControl.currentPage = carousel.currentItemIndex ;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    SNSLog(@"你已经点中了第%d个~~~~",index);
    AdInfo* adInfo = _itemObjects[index];
    SNSLog(@"adInfo.musicID====%@",adInfo.musicID);
    [_delegate jumpToAdPresentVC:adInfo];
}

@end
